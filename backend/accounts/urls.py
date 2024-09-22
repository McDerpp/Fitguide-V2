from django.urls import path
from django.urls import path, include
from . import views

urlpatterns = [
    path('register/', views.register, name='register'),

    path('login/', views.login, name='login'),
    path('editAccount/', views.editAccount, name='editAccount'),
    path('oauth_callback/', views.oauth_callback, name='oauth_callback'),


]
