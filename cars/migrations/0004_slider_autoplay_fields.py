from django.db import migrations, models

class Migration(migrations.Migration):

    dependencies = [
        ('cars', '0003_slider_and_slide'),
    ]

    operations = [
        migrations.AddField(
            model_name='slider',
            name='autoplay',
            field=models.BooleanField(default=True, verbose_name='پخش خودکار'),
        ),
        migrations.AddField(
            model_name='slider',
            name='pause_on_hover',
            field=models.BooleanField(default=True, verbose_name='توقف با هاور'),
        ),
        migrations.AddField(
            model_name='slider',
            name='wrap',
            field=models.BooleanField(default=True, verbose_name='گردش حلقه‌ای'),
        ),
    ]
