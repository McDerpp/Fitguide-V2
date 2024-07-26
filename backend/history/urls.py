from django.urls import path
from . import views


urlpatterns = [
    path('api/history/addWorkoutsDone/',views.addWorkoutsDone, name='addWorkoutsDone'),

]
