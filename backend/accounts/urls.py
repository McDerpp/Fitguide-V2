from django.urls import path
from . import views

urlpatterns = [
    path('api/accounts/register/', views.register, name='register'),
    path('api/accounts/login/', views.login, name='login'),

    # Add other paths here
]
