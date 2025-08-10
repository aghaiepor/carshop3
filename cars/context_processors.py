from django.utils import timezone

def site_settings(request):
    # Lazy imports to avoid issues during initial migrate
    try:
        from .models import SiteSettings, Slider
        settings_obj = SiteSettings.get_solo()
    except Exception:
        settings_obj = None
        Slider = None

    top_slider = None
    top_slides = []
    try:
        if Slider:
            top_slider = Slider.get_solo()
            now = timezone.now()
            # Filter active slides by time window
            slides_qs = top_slider.slides.filter(is_active=True).order_by('order', 'id')
            slides_qs = slides_qs.filter(start_at__lte=now) | slides_qs.filter(start_at__isnull=True)
            slides_qs = slides_qs.exclude(end_at__lt=now)
            top_slides = list(slides_qs)
    except Exception:
        top_slider = None
        top_slides = []

    return {
        'site_settings': settings_obj,
        'top_slider': top_slider,
        'top_slides': top_slides,
    }
