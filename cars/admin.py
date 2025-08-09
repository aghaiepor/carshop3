from django.contrib import admin
from django.utils.html import format_html
from .models import Brand, Category, Car, CarImage, Inquiry

class CarImageInline(admin.TabularInline):
    model = CarImage
    extra = 1

@admin.register(Brand)
class BrandAdmin(admin.ModelAdmin):
    list_display = ['name', 'logo_preview', 'created_at']
    search_fields = ['name']
    list_filter = ['created_at']

    def logo_preview(self, obj):
        if obj.logo:
            return format_html('<img src="{}" width="50" height="50" />', obj.logo.url)
        return "No Logo"
    logo_preview.short_description = "Logo"

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'created_at']
    search_fields = ['name']
    list_filter = ['created_at']

@admin.register(Car)
class CarAdmin(admin.ModelAdmin):
    list_display = ['title', 'brand', 'category', 'year', 'price', 'status', 'is_featured', 'created_at']
    list_filter = ['brand', 'category', 'fuel_type', 'transmission', 'status', 'is_featured', 'year']
    search_fields = ['title', 'model', 'brand__name']
    list_editable = ['status', 'is_featured']
    inlines = [CarImageInline]

@admin.register(CarImage)
class CarImageAdmin(admin.ModelAdmin):
    list_display = ['car', 'image_preview', 'is_primary', 'created_at']
    list_filter = ['is_primary', 'created_at']
    list_editable = ['is_primary']

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="100" height="75" />', obj.image.url)
        return "No Image"
    image_preview.short_description = "Preview"

@admin.register(Inquiry)
class InquiryAdmin(admin.ModelAdmin):
    list_display = ['car', 'name', 'email', 'phone', 'is_read', 'created_at']
    list_filter = ['is_read', 'created_at']
    search_fields = ['name', 'email', 'car__title']
    list_editable = ['is_read']
    readonly_fields = ['created_at']

admin.site.site_header = "Car Shop Administration"
admin.site.site_title = "Car Shop Admin"
admin.site.index_title = "Welcome to Car Shop Administration"
