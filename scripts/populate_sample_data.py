#!/usr/bin/env python
import os
import django
from django.utils import timezone

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'carshop.settings')
django.setup()

from cars.models import Brand, Category, Car

def populate_data():
    # Create brands
    brands_data = [
        {'name': 'Toyota', 'description': 'Japanese automotive manufacturer known for reliability and fuel efficiency'},
        {'name': 'BMW', 'description': 'German luxury vehicle manufacturer'},
        {'name': 'Mercedes-Benz', 'description': 'German luxury automotive brand'},
        {'name': 'Audi', 'description': 'German luxury automobile manufacturer'},
        {'name': 'Honda', 'description': 'Japanese automotive manufacturer'},
        {'name': 'Ford', 'description': 'American multinational automaker'},
        {'name': 'Chevrolet', 'description': 'American automobile division of General Motors'},
        {'name': 'Nissan', 'description': 'Japanese multinational automobile manufacturer'},
    ]
    
    for brand_data in brands_data:
        brand, created = Brand.objects.get_or_create(
            name=brand_data['name'],
            defaults={'description': brand_data['description']}
        )
        if created:
            print(f"Created brand: {brand.name}")
    
    # Create categories
    categories_data = [
        {'name': 'Sedan', 'description': 'Four-door passenger cars with separate trunk'},
        {'name': 'SUV', 'description': 'Sport Utility Vehicles with higher ground clearance'},
        {'name': 'Hatchback', 'description': 'Cars with a rear door that swings upward'},
        {'name': 'Coupe', 'description': 'Two-door cars with a fixed roof'},
        {'name': 'Convertible', 'description': 'Cars with a retractable roof'},
        {'name': 'Pickup Truck', 'description': 'Vehicles with an open cargo area'},
        {'name': 'Wagon', 'description': 'Cars with extended cargo area'},
    ]
    
    for category_data in categories_data:
        category, created = Category.objects.get_or_create(
            name=category_data['name'],
            defaults={'description': category_data['description']}
        )
        if created:
            print(f"Created category: {category.name}")
    
    # Create sample cars
    cars_data = [
        {
            'title': 'Toyota Camry 2022 - Excellent Condition',
            'brand': 'Toyota',
            'category': 'Sedan',
            'model': 'Camry',
            'year': 2022,
            'price': 28500.00,
            'mileage': 15000,
            'fuel_type': 'petrol',
            'transmission': 'automatic',
            'engine_size': 2.5,
            'color': 'Silver',
            'description': 'Well-maintained Toyota Camry with low mileage. Perfect for daily commuting and family trips.',
            'features': 'Backup Camera, Bluetooth, Cruise Control, Power Windows, Air Conditioning',
            'is_featured': True,
        },
        {
            'title': 'BMW X5 2021 - Luxury SUV',
            'brand': 'BMW',
            'category': 'SUV',
            'model': 'X5',
            'year': 2021,
            'price': 52000.00,
            'mileage': 25000,
            'fuel_type': 'petrol',
            'transmission': 'automatic',
            'engine_size': 3.0,
            'color': 'Black',
            'description': 'Premium BMW X5 with advanced features and excellent performance. Ideal for luxury travel.',
            'features': 'Leather Seats, Navigation System, Panoramic Sunroof, All-Wheel Drive, Premium Sound System',
            'is_featured': True,
        },
        {
            'title': 'Honda Civic 2020 - Reliable & Efficient',
            'brand': 'Honda',
            'category': 'Sedan',
            'model': 'Civic',
            'year': 2020,
            'price': 22000.00,
            'mileage': 35000,
            'fuel_type': 'petrol',
            'transmission': 'manual',
            'engine_size': 1.5,
            'color': 'Blue',
            'description': 'Fuel-efficient Honda Civic in excellent condition. Great first car or daily driver.',
            'features': 'Manual Transmission, Fuel Efficient, Reliable Engine, Power Steering, Air Conditioning',
            'is_featured': True,
        },
        {
            'title': 'Mercedes-Benz C-Class 2023',
            'brand': 'Mercedes-Benz',
            'category': 'Sedan',
            'model': 'C-Class',
            'year': 2023,
            'price': 45000.00,
            'mileage': 8000,
            'fuel_type': 'petrol',
            'transmission': 'automatic',
            'engine_size': 2.0,
            'color': 'White',
            'description': 'Latest Mercedes-Benz C-Class with cutting-edge technology and luxury features.',
            'features': 'MBUX Infotainment, LED Headlights, Wireless Charging, Premium Interior, Advanced Safety Features',
            'is_featured': True,
        },
        {
            'title': 'Ford F-150 2021 - Work Ready',
            'brand': 'Ford',
            'category': 'Pickup Truck',
            'model': 'F-150',
            'year': 2021,
            'price': 38000.00,
            'mileage': 40000,
            'fuel_type': 'petrol',
            'transmission': 'automatic',
            'engine_size': 3.5,
            'color': 'Red',
            'description': 'Powerful Ford F-150 pickup truck perfect for work and recreation.',
            'features': 'Towing Package, Bed Liner, 4WD, Heavy Duty Suspension, Work Lights',
            'is_featured': False,
        },
        {
            'title': 'Audi A4 2022 - Sport Package',
            'brand': 'Audi',
            'category': 'Sedan',
            'model': 'A4',
            'year': 2022,
            'price': 42000.00,
            'mileage': 18000,
            'fuel_type': 'petrol',
            'transmission': 'automatic',
            'engine_size': 2.0,
            'color': 'Gray',
            'description': 'Sporty Audi A4 with performance package and luxury amenities.',
            'features': 'Sport Suspension, Premium Plus Package, Virtual Cockpit, Quattro AWD, Bang & Olufsen Sound',
            'is_featured': True,
        },
    ]
    
    for car_data in cars_data:
        brand = Brand.objects.get(name=car_data['brand'])
        category = Category.objects.get(name=car_data['category'])
        
        car, created = Car.objects.get_or_create(
            title=car_data['title'],
            defaults={
                'brand': brand,
                'category': category,
                'model': car_data['model'],
                'year': car_data['year'],
                'price': car_data['price'],
                'mileage': car_data['mileage'],
                'fuel_type': car_data['fuel_type'],
                'transmission': car_data['transmission'],
                'engine_size': car_data['engine_size'],
                'color': car_data['color'],
                'description': car_data['description'],
                'features': car_data['features'],
                'is_featured': car_data['is_featured'],
                'status': 'available',
            }
        )
        if created:
            print(f"Created car: {car.title}")

if __name__ == '__main__':
    populate_data()
    print("Sample data populated successfully!")
