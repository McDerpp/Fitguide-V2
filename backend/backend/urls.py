from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from django.contrib import admin
from oauth2_provider.views import AuthorizationView, TokenView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('o/authorize/', AuthorizationView.as_view(), name='authorize'),
    path('o/token/', TokenView.as_view(), name='token'),
    path('api/accounts/', include('accounts.urls')),  
    path('api/exercises/', include('exercises.urls')),  
    path('api/workouts/', include('workouts.urls')),  
    path('api/history/', include('history.urls')),  
    path('api/models/', include('models.urls')),  

]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

