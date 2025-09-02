from django.db.models.signals import post_migrate
from django.dispatch import receiver
from django.apps import apps

@receiver(post_migrate)
def ensure_site_settings(sender, **kwargs):
  try:
    SiteSettings = apps.get_model('cars', 'SiteSettings')
    if SiteSettings and not SiteSettings.objects.exists():
      SiteSettings.objects.create()
  except Exception:
    pass
