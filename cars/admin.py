from django.contrib import admin
from django.utils.html import format_html
from django import forms
from django_ckeditor_5.widgets import CKEditor5Widget

from .models import Brand, Category, Car, CarImage, Inquiry, SiteSettings, Slider, Slide

class CarImageInline(admin.TabularInline):
    model = CarImage
    extra = 1

class SiteSettingsForm(forms.ModelForm):
    header_html = forms.CharField(label="HTML هدر (اختیاری)", required=False, widget=CKEditor5Widget(config_name='extends'))
    footer_html = forms.CharField(label="HTML پاورقی", required=False, widget=CKEditor5Widget(config_name='extends'))

    class Meta:
        model = SiteSettings
        fields = "__all__"

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

class SlideInline(admin.TabularInline):
    model = Slide
    extra = 1
    fields = ('order', 'image', 'title', 'subtitle', 'button_label', 'button_url', 'is_active', 'start_at', 'end_at')
    ordering = ('order',)

@admin.register(Slider)
class SliderAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'is_enabled', 'autoplay', 'autoplay_interval_ms', 'pause_on_hover', 'wrap', 'show_indicators', 'show_controls', 'updated_at')
    list_editable = ('is_enabled', 'autoplay', 'autoplay_interval_ms', 'pause_on_hover', 'wrap', 'show_indicators', 'show_controls')
    fieldsets = (
        ("تنظیمات پخش", {'fields': ('is_enabled', 'autoplay', 'autoplay_interval_ms', 'pause_on_hover', 'wrap')}),
        ("نمایش", {'fields': ('show_indicators', 'show_controls')}),
    )
    inlines = [SlideInline]

@admin.register(SiteSettings)
class SiteSettingsAdmin(admin.ModelAdmin):
    form = SiteSettingsForm
    fieldsets = (
        ("سرتیتر", {'fields': ('site_name', 'logo', 'primary_color', 'secondary_color', 'header_html')}),
        ("بخش هرو (صفحه اصلی)", {'fields': ('hero_title', 'hero_subtitle', 'hero_cta_label', 'hero_cta_url')}),
        ("پاورقی و تماس", {'fields': ('contact_phone', 'contact_email', 'contact_address', 'footer_html')}),
    )

    def has_add_permission(self, request):
        if SiteSettings.objects.exists():
            return False
        return super().has_add_permission(request)

admin.site.site_header = "پنل مدیریت فروشگاه خودرو"
admin.site.site_title = "مدیریت فروشگاه خودرو"
admin.site.index_title = "به پنل مدیریت خوش آمدید"
