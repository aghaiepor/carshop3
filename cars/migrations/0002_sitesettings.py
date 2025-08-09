from django.db import migrations, models

class Migration(migrations.Migration):
    dependencies = [
        ('cars', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SiteSettings',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('site_name', models.CharField(default='فروشگاه خودرو', max_length=150)),
                ('logo', models.ImageField(blank=True, null=True, upload_to='site/')),
                ('primary_color', models.CharField(blank=True, default='#0ea5e9', max_length=20)),
                ('secondary_color', models.CharField(blank=True, default='#10b981', max_length=20)),
                ('hero_title', models.CharField(default='خودروی مورد نظرت را پیدا کن', max_length=200)),
                ('hero_subtitle', models.CharField(blank=True, default='مجموعه‌ای گسترده از خودروهای باکیفیت با قیمت‌های رقابتی', max_length=300)),
                ('hero_cta_label', models.CharField(default='مشاهده خودروها', max_length=80)),
                ('hero_cta_url', models.CharField(default='/cars/', max_length=200)),
                ('contact_phone', models.CharField(blank=True, default='+98 21 1234 5678', max_length=50)),
                ('contact_email', models.EmailField(blank=True, default='info@carshop.test', max_length=254)),
                ('contact_address', models.CharField(blank=True, default='تهران، خیابان خودرو، پلاک ۱۲۳', max_length=200)),
                ('footer_html', models.TextField(blank=True, default='© ۱۴۰۳ فروشگاه خودرو. کلیه حقوق محفوظ است.')),
                ('header_html', models.TextField(blank=True, default='')),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={'verbose_name': 'تنظیمات سایت', 'verbose_name_plural': 'تنظیمات سایت'},
        ),
    ]
