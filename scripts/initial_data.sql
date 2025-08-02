-- Initial data for Car Shop application

-- Insert sample brands
INSERT INTO cars_brand (name, description, created_at) VALUES
('Toyota', 'Japanese automotive manufacturer known for reliability and fuel efficiency', GETDATE()),
('BMW', 'German luxury vehicle manufacturer', GETDATE()),
('Mercedes-Benz', 'German luxury automotive brand', GETDATE()),
('Audi', 'German luxury automobile manufacturer', GETDATE()),
('Honda', 'Japanese automotive manufacturer', GETDATE()),
('Ford', 'American multinational automaker', GETDATE()),
('Chevrolet', 'American automobile division of General Motors', GETDATE()),
('Nissan', 'Japanese multinational automobile manufacturer', GETDATE());

-- Insert sample categories
INSERT INTO cars_category (name, description, created_at) VALUES
('Sedan', 'Four-door passenger cars with separate trunk', GETDATE()),
('SUV', 'Sport Utility Vehicles with higher ground clearance', GETDATE()),
('Hatchback', 'Cars with a rear door that swings upward', GETDATE()),
('Coupe', 'Two-door cars with a fixed roof', GETDATE()),
('Convertible', 'Cars with a retractable roof', GETDATE()),
('Pickup Truck', 'Vehicles with an open cargo area', GETDATE()),
('Wagon', 'Cars with extended cargo area', GETDATE());

-- Insert sample cars
INSERT INTO cars_car (title, brand_id, category_id, model, year, price, mileage, fuel_type, transmission, engine_size, color, description, features, status, is_featured, created_at, updated_at) VALUES
('Toyota Camry 2022 - Excellent Condition', 1, 1, 'Camry', 2022, 28500.00, 15000, 'petrol', 'automatic', 2.5, 'Silver', 'Well-maintained Toyota Camry with low mileage. Perfect for daily commuting and family trips.', 'Backup Camera, Bluetooth, Cruise Control, Power Windows, Air Conditioning', 'available', 1, GETDATE(), GETDATE()),
('BMW X5 2021 - Luxury SUV', 2, 2, 'X5', 2021, 52000.00, 25000, 'petrol', 'automatic', 3.0, 'Black', 'Premium BMW X5 with advanced features and excellent performance. Ideal for luxury travel.', 'Leather Seats, Navigation System, Panoramic Sunroof, All-Wheel Drive, Premium Sound System', 'available', 1, GETDATE(), GETDATE()),
('Honda Civic 2020 - Reliable & Efficient', 5, 1, 'Civic', 2020, 22000.00, 35000, 'petrol', 'manual', 1.5, 'Blue', 'Fuel-efficient Honda Civic in excellent condition. Great first car or daily driver.', 'Manual Transmission, Fuel Efficient, Reliable Engine, Power Steering, Air Conditioning', 'available', 1, GETDATE(), GETDATE()),
('Mercedes-Benz C-Class 2023', 3, 1, 'C-Class', 2023, 45000.00, 8000, 'petrol', 'automatic', 2.0, 'White', 'Latest Mercedes-Benz C-Class with cutting-edge technology and luxury features.', 'MBUX Infotainment, LED Headlights, Wireless Charging, Premium Interior, Advanced Safety Features', 'available', 1, GETDATE(), GETDATE()),
('Ford F-150 2021 - Work Ready', 6, 6, 'F-150', 2021, 38000.00, 40000, 'petrol', 'automatic', 3.5, 'Red', 'Powerful Ford F-150 pickup truck perfect for work and recreation.', 'Towing Package, Bed Liner, 4WD, Heavy Duty Suspension, Work Lights', 'available', 0, GETDATE(), GETDATE()),
('Audi A4 2022 - Sport Package', 4, 1, 'A4', 2022, 42000.00, 18000, 'petrol', 'automatic', 2.0, 'Gray', 'Sporty Audi A4 with performance package and luxury amenities.', 'Sport Suspension, Premium Plus Package, Virtual Cockpit, Quattro AWD, Bang & Olufsen Sound', 'available', 1, GETDATE(), GETDATE()),
('Chevrolet Tahoe 2020 - Family SUV', 7, 2, 'Tahoe', 2020, 48000.00, 32000, 'petrol', 'automatic', 5.3, 'Black', 'Spacious Chevrolet Tahoe perfect for large families and road trips.', '8-Passenger Seating, Towing Capacity, Entertainment System, Third Row Seating, Cargo Space', 'available', 0, GETDATE(), GETDATE()),
('Nissan Altima 2021 - Low Mileage', 8, 1, 'Altima', 2021, 24500.00, 12000, 'petrol', 'cvt', 2.5, 'Silver', 'Low mileage Nissan Altima with modern features and excellent fuel economy.', 'CVT Transmission, Fuel Efficient, Safety Shield 360, Apple CarPlay, Remote Start', 'available', 0, GETDATE(), GETDATE());
