# Migration: add Slider and Slide models
from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):

    dependencies = [
        ('cars', '0002_sitesettings'),
    ]

    operations = [
        migrations.CreateModel(
            name='Slider',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('is_enabled', models.BooleanField(default=True, verbose_name='فعال')),
                ('autoplay_interval_ms', models.PositiveIntegerField(default=5000, verbose_name='فاصله اسلایدها (میلی‌ثانیه)')),
                ('show_indicators', models.BooleanField(default=True, verbose_name='نمایش نقطه‌ها')),
                ('show_controls', models.BooleanField(default=True, verbose_name='نمایش دکمه‌های قبلی/بعدی')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'verbose_name': 'اسلایدر',
                'verbose_name_plural': 'اسلایدر',
            },
        ),
        migrations.CreateModel(
            name='Slide',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(blank=True, max_length=200)),
                ('subtitle', models.CharField(blank=True, max_length=300)),
                ('button_label', models.CharField(blank=True, max_length=80)),
                ('button_url', models.CharField(blank=True, max_length=200)),
                ('image', models.ImageField(upload_to='slider/')),
                ('order', models.PositiveIntegerField(default=0)),
                ('is_active', models.BooleanField(default=True)),
                ('start_at', models.DateTimeField(blank=True, null=True)),
                ('end_at', models.DateTimeField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('slider', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='slides', to='cars.slider')),
            ],
            options={
                'verbose_name': 'اسلاید',
                'verbose_name_plural': 'اسلایدها',
                'ordering': ['order', 'id'],
            },
        ),
    ]
