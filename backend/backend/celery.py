
import os

from celery import Celery
from django.conf import settings


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')

app = Celery('backend', broker="redis://localhost")
app.config_from_object('django.conf:settings', namespace='CELERY')
app.conf.update(
    task_serializer='json',
    timezone='America/New_York',
)
# Use synchronous in local dev
# if settings.DEBUG:
#     app.conf.update(task_always_eager=True)
# app.autodiscover_tasks(lambda: settings.INSTALLED_APPS, related_name='celery')

app.conf.update(task_always_eager=False )
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS, related_name='celery')







# this is working
# celery --app=backend.celery worker --pool=threads --concurrency=8 --loglevel=info
# daphne -b 192.168.1.2 -p 8001 backend.asgi:application


# celery -A backend beat --loglevel=info








