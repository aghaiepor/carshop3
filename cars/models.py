from django.db import models
from django.urls import reverse
from django.utils import timezone
from django.utils.translation import gettext_lazy as _

class Brand(models.Model):
    name = models.CharField(max_length=100)
    logo = models.ImageField(upload_to='brands/', blank=True, null=True)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']
        verbose_name = _("برند")
        verbose_name_plural = _("برندها")


class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = _("دسته‌بندی")
        verbose_name_plural = _("دسته‌بندی‌ها")
        ordering = ['name']


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
    mileage = models.IntegerField(help_text="Mileage in kilometers")
    fuel_type = models.CharField(max_length=20, choices=FUEL_CHOICES)
    transmission = models.CharField(max_length=20, choices=TRANSMISSION_CHOICES)
    engine_size = models.DecimalField(max_digits=3, decimal_places=1, help_text="Engine size in liters")
    color = models.CharField(max_length=50)
    description = models.TextField()
    features = models.TextField(help_text="List key features separated by commas")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='available')
    is_featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.brand.name} {self.model} ({self.year})"

    def get_absolute_url(self):
        return reverse('car_detail', kwargs={'pk': self.pk})

    class Meta:
        ordering = ['-created_at']
        verbose_name = _("خودرو")
        verbose_name_plural = _("خودروها")


class CarImage(models.Model):
    car = models.ForeignKey(Car, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='cars/')
    is_primary = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Image for {self.car.title}"

    class Meta:
        ordering = ['-is_primary', 'created_at']
        verbose_name = _("تصویر خودرو")
        verbose_name_plural = _("تصاویر خودرو")


class Inquiry(models.Model):
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.EmailField()
    phone = models.CharField(max_length=20)
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    def __str__(self):
        return f"Inquiry for {self.car.title} by {self.name}"

    class Meta:
        verbose_name = _("استعلام")
        verbose_name_plural = _("استعلام‌ها")
        ordering = ['-created_at']


class SiteSettings(models.Model):
    site_name = models.CharField(max_length=150, default="فروشگاه خودرو")
    logo = models.ImageField(upload_to='site/', blank=True, null=True)
    primary_color = models.CharField(max_length=20, blank=True, default="#0ea5e9")
    secondary_color = models.CharField(max_length=20, blank=True, default="#10b981")

    hero_title = models.CharField(max_length=200, default="خودروی مورد نظرت را پیدا کن")
    hero_subtitle = models.CharField(max_length=300, blank=True, default="مجموعه‌ای گسترده از خودروهای باکیفیت با قیمت‌های رقابتی")
    hero_cta_label = models.CharField(max_length=80, default="مشاهده خودروها")
    hero_cta_url = models.CharField(max_length=200, default="/cars/")

    contact_phone = models.CharField(max_length=50, blank=True, default="+98 21 1234 5678")
    contact_email = models.EmailField(blank=True, default="info@carshop.test")
    contact_address = models.CharField(max_length=200, blank=True, default="تهران، خیابان خودرو، پلاک ۱۲۳")
    footer_html = models.TextField(blank=True, default="© ۱۴۰۳ فروشگاه خودرو. کلیه حقوق محفوظ است.")
    header_html = models.TextField(blank=True, default="")

    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = _("تنظیمات سایت")
        verbose_name_plural = _("تنظیمات سایت")

    def __str__(self):
        return "Site Settings"

    @staticmethod
    def get_solo():
        obj = SiteSettings.objects.first()
        if not obj:
            obj = SiteSettings.objects.create()
        return obj


class Slider(models.Model):
    is_enabled = models.BooleanField(default=True, verbose_name=_("فعال"))
    autoplay = models.BooleanField(default=True, verbose_name=_("پخش خودکار"))
    autoplay_interval_ms = models.PositiveIntegerField(default=5000, verbose_name=_("فاصله اسلایدها (میلی‌ثانیه)"))
    pause_on_hover = models.BooleanField(default=True, verbose_name=_("توقف با هاور"))
    wrap = models.BooleanField(default=True, verbose_name=_("گردش حلقه‌ای"))
    show_indicators = models.BooleanField(default=True, verbose_name=_("نمایش نقطه‌ها"))
    show_controls = models.BooleanField(default=True, verbose_name=_("نمایش دکمه‌های قبلی/بعدی"))
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = _("اسلایدر")
        verbose_name_plural = _("اسلایدر")

    def __str__(self):
        return "اسلایدر بالای سایت"

    @staticmethod
    def get_solo():
        obj = Slider.objects.first()
        if not obj:
            obj = Slider.objects.create()
        return obj


class Slide(models.Model):
    slider = models.ForeignKey(Slider, related_name='slides', on_delete=models.CASCADE)
    title = models.CharField(max_length=200, blank=True)
    subtitle = models.CharField(max_length=300, blank=True)
    button_label = models.CharField(max_length=80, blank=True)
    button_url = models.CharField(max_length=200, blank=True)
    image = models.ImageField(upload_to='slider/')
    order = models.PositiveIntegerField(default=0)
    is_active = models.BooleanField(default=True)
    start_at = models.DateTimeField(null=True, blank=True)
    end_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['order', 'id']
        verbose_name = _("اسلاید")
        verbose_name_plural = _("اسلایدها")

    def __str__(self):
        return self.title or f"Slide #{self.pk}"

    def is_currently_active(self):
        now = timezone.now()
        if not self.is_active:
            return False
        if self.start_at and now < self.start_at:
            return False
        if self.end_at and now > self.end_at:
            return False
        return True
