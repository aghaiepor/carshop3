from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q
from .models import Car, Brand, Category, Inquiry
from .forms import InquiryForm

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
    brands = Brand.objects.all()
    categories = Category.objects.all()
    
    # Filtering
    brand_filter = request.GET.get('brand')
    category_filter = request.GET.get('category')
    min_price = request.GET.get('min_price')
    max_price = request.GET.get('max_price')
    search = request.GET.get('search')
    
    if brand_filter:
        cars = cars.filter(brand_id=brand_filter)
    if category_filter:
        cars = cars.filter(category_id=category_filter)
    if min_price:
        cars = cars.filter(price__gte=min_price)
    if max_price:
        cars = cars.filter(price__lte=max_price)
    if search:
        cars = cars.filter(
            Q(title__icontains=search) |
            Q(model__icontains=search) |
            Q(brand__name__icontains=search)
        )
    
    # Pagination
    paginator = Paginator(cars, 12)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'brands': brands,
        'categories': categories,
        'current_filters': {
            'brand': brand_filter,
            'category': category_filter,
            'min_price': min_price,
            'max_price': max_price,
            'search': search,
        }
    }
    return render(request, 'cars/car_list.html', context)

def car_detail(request, pk):
    car = get_object_or_404(Car, pk=pk)
    related_cars = Car.objects.filter(
        brand=car.brand, 
        status='available'
    ).exclude(pk=car.pk)[:4]
    
    if request.method == 'POST':
        form = InquiryForm(request.POST)
        if form.is_valid():
            inquiry = form.save(commit=False)
            inquiry.car = car
            inquiry.save()
            messages.success(request, 'Your inquiry has been sent successfully!')
            return redirect('car_detail', pk=car.pk)
    else:
        form = InquiryForm()
    
    context = {
        'car': car,
        'related_cars': related_cars,
        'form': form,
    }
    return render(request, 'cars/car_detail.html', context)

def brand_cars(request, brand_id):
    brand = get_object_or_404(Brand, pk=brand_id)
    cars = Car.objects.filter(brand=brand, status='available')
    
    paginator = Paginator(cars, 12)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'brand': brand,
        'page_obj': page_obj,
    }
    return render(request, 'cars/brand_cars.html', context)
