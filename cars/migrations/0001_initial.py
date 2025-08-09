# Initial migration for cars app
from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):
    initial = True
    dependencies = []
    operations = [
        migrations.CreateModel(
            name='Brand',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('logo', models.ImageField(blank=True, null=True, upload_to='brands/')),
                ('description', models.TextField(blank=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={'ordering': ['name']},
        ),
        migrations.CreateModel(
            name='Category',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('description', models.TextField(blank=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={'verbose_name_plural': 'Categories', 'ordering': ['name']},
        ),
        migrations.CreateModel(
            name='Car',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=200)),
                ('model', models.CharField(max_length=100)),
                ('year', models.IntegerField()),
                ('price', models.DecimalField(decimal_places=2, max_digits=10)),
                ('mileage', models.IntegerField(help_text='Mileage in kilometers')),
                ('fuel_type', models.CharField(choices=[('petrol', 'Petrol'), ('diesel', 'Diesel'), ('electric', 'Electric'), ('hybrid', 'Hybrid')], max_length=20)),
                ('transmission', models.CharField(choices=[('manual', 'Manual'), ('automatic', 'Automatic'), ('cvt', 'CVT')], max_length=20)),
                ('engine_size', models.DecimalField(decimal_places=1, help_text='Engine size in liters', max_digits=3)),
                ('color', models.CharField(max_length=50)),
                ('description', models.TextField()),
                ('features', models.TextField(help_text='List key features separated by commas')),
                ('status', models.CharField(choices=[('available', 'Available'), ('sold', 'Sold'), ('reserved', 'Reserved')], default='available', max_length=20)),
                ('is_featured', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('brand', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='cars.brand')),
                ('category', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='cars.category')),
            ],
            options={'ordering': ['-created_at']},
        ),
        migrations.CreateModel(
            name='CarImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(upload_to='cars/')),
                ('is_primary', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('car', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='images', to='cars.car')),
            ],
            options={'ordering': ['-is_primary', 'created_at']},
        ),
        migrations.CreateModel(
            name='Inquiry',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('email', models.EmailField(max_length=254)),
                ('phone', models.CharField(max_length=20)),
                ('message', models.TextField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('is_read', models.BooleanField(default=False)),
                ('car', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='cars.car')),
            ],
            options={'verbose_name_plural': 'Inquiries', 'ordering': ['-created_at']},
        ),
    ]
