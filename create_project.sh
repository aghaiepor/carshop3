#!/bin/bash

echo "Creating Django Car Shop project structure..."

# Create directories
mkdir -p carshop cars templates/cars

# Create manage.py
cat > manage.py << 'EOF'
#!/usr/bin/env python
import os
import sys

if __name__ == '__main__':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'carshop.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)
EOF

# Create carshop/__init__.py
touch carshop/__init__.py

# Create carshop/settings.py
cat > carshop/settings.py << 'EOF'
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'django-insecure-your-secret-key-here-change-in-production'

DEBUG = True

ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'cars',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'carshop.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'carshop.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
EOF

# Create carshop/urls.py
cat > carshop/urls.py << 'EOF'
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('cars.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
EOF

# Create carshop/wsgi.py
cat > carshop/wsgi.py << 'EOF'
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'carshop.settings')
application = get_wsgi_application()
EOF

# Create cars/__init__.py
touch cars/__init__.py

# Create cars/apps.py
cat > cars/apps.py << 'EOF'
from django.apps import AppConfig

class CarsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cars'
EOF

# Create cars/models.py
cat > cars/models.py << 'EOF'
from django.db import models

class Brand(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "Categories"

class Car(models.Model):
    FUEL_CHOICES = [
        ('petrol', 'Petrol'),
        ('diesel', 'Diesel'),
        ('electric', 'Electric'),
        ('hybrid', 'Hybrid'),
    ]
    
    TRANSMISSION_CHOICES = [
        ('manual', 'Manual'),
        ('automatic', 'Automatic'),
        ('cvt', 'CVT'),
    ]
    
    STATUS_CHOICES = [
        ('available', 'Available'),
        ('sold', 'Sold'),
        ('reserved', 'Reserved'),
    ]

    title = models.CharField(max_length=200)
    brand = models.ForeignKey(Brand, on_delete=models.CASCADE)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    model = models.CharField(max_length=100)
    year = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    mileage = models.IntegerField()
    fuel_type = models.CharField(max_length=20, choices=FUEL_CHOICES)
    transmission = models.CharField(max_length=20, choices=TRANSMISSION_CHOICES)
    engine_size = models.DecimalField(max_digits=3, decimal_places=1)
    color = models.CharField(max_length=50)
    description = models.TextField()
    features = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='available')
    is_featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.brand.name} {self.model} ({self.year})"

    class Meta:
        ordering = ['-created_at']
EOF

# Create cars/admin.py
cat > cars/admin.py << 'EOF'
from django.contrib import admin
from .models import Brand, Category, Car

@admin.register(Brand)
class BrandAdmin(admin.ModelAdmin):
    list_display = ['name', 'created_at']
    search_fields = ['name']

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'created_at']
    search_fields = ['name']

@admin.register(Car)
class CarAdmin(admin.ModelAdmin):
    list_display = ['title', 'brand', 'category', 'year', 'price', 'status', 'is_featured']
    list_filter = ['brand', 'category', 'fuel_type', 'transmission', 'status', 'is_featured', 'year']
    search_fields = ['title', 'model', 'brand__name']
    list_editable = ['status', 'is_featured']

admin.site.site_header = "Car Shop Administration"
admin.site.site_title = "Car Shop Admin"
EOF

# Create cars/views.py
cat > cars/views.py << 'EOF'
from django.shortcuts import render
from .models import Car, Brand

def home(request):
    featured_cars = Car.objects.filter(is_featured=True, status='available')[:6]
    brands = Brand.objects.all()[:8]
    context = {
        'featured_cars': featured_cars,
        'brands': brands,
    }
    return render(request, 'cars/home.html', context)

def car_list(request):
    cars = Car.objects.filter(status='available')
    context = {'cars': cars}
    return render(request, 'cars/car_list.html', context)
EOF

# Create cars/urls.py
cat > cars/urls.py << 'EOF'
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('cars/', views.car_list, name='car_list'),
]
EOF

# Create templates/base.html
cat > templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}Car Shop{% endblock %}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="{% url 'home' %}">Car Shop</a>
            <div class="navbar-nav">
                <a class="nav-link" href="{% url 'home' %}">Home</a>
                <a class="nav-link" href="{% url 'car_list' %}">Cars</a>
                <a class="nav-link" href="/admin/">Admin</a>
            </div>
        </div>
    </nav>

    {% block content %}
    {% endblock %}

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
EOF

# Create templates/cars/home.html
cat > templates/cars/home.html << 'EOF'
{% extends 'base.html' %}

{% block content %}
<div class="container my-5">
    <div class="jumbotron bg-primary text-white p-5 rounded mb-5">
        <h1 class="display-4">Welcome to Car Shop</h1>
        <p class="lead">Find your perfect car today!</p>
        <a class="btn btn-light btn-lg" href="{% url 'car_list' %}">Browse Cars</a>
    </div>

    <h2>Featured Cars</h2>
    <div class="row">
        {% for car in featured_cars %}
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">{{ car.title }}</h5>
                    <p class="card-text">{{ car.year }} • ${{ car.price }}</p>
                    <p class="card-text">{{ car.description|truncatewords:20 }}</p>
                </div>
            </div>
        </div>
        {% empty %}
        <p>No featured cars available.</p>
        {% endfor %}
    </div>
</div>
{% endblock %}
EOF

# Create templates/cars/car_list.html
cat > templates/cars/car_list.html << 'EOF'
{% extends 'base.html' %}

{% block content %}
<div class="container my-5">
    <h2>All Cars</h2>
    <div class="row">
        {% for car in cars %}
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">{{ car.title }}</h5>
                    <p class="card-text">{{ car.year }} • ${{ car.price }}</p>
                    <p class="card-text">{{ car.description|truncatewords:15 }}</p>
                    <span class="badge bg-success">${{ car.price }}</span>
                </div>
            </div>
        </div>
        {% empty %}
        <p>No cars available.</p>
        {% endfor %}
    </div>
</div>
{% endblock %}
EOF

# Create requirements.txt
cat > requirements.txt << 'EOF'
Django==4.2.7
EOF

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
EOF

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    command: >
      sh -c "python manage.py migrate &&
             python manage.py runserver 0.0.0.0:8000"
EOF

echo "Project structure created successfully!"
echo "Run the following commands:"
echo "chmod +x create_project.sh"
echo "./create_project.sh"
echo "docker-compose up --build"
EOF
