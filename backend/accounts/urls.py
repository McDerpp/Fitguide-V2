from django.urls import path
from . import views

urlpatterns = [
    path('api/accounts/register/', views.register, name='register'),
    path('api/accounts/login/', views.login, name='login'),
    path('api/accounts/editAccount/', views.editAccount, name='editAccount'),

]
