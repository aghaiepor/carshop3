from django import template

register = template.Library()

@register.filter
def split(value, sep=","):
    try:
        return [item.strip() for item in value.split(sep)]
    except Exception:
        return []
