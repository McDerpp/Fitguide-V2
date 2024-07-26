from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from django.contrib import admin


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('accounts.urls')),  
    path('', include('exercises.urls')),  
    path('', include('workouts.urls')),  
    path('', include('history.urls')),  
    path('', include('models.urls')),  




]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

