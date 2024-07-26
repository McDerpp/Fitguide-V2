from django.urls import path
from . import views


urlpatterns = [
    path('api/exercises/add/',views.add, name='add'),
    path('api/exercises/getExerciseCard/',views.getExerciseCard, name='getExerciseCard'),
    path('api/exercises/getExercise/',views.getExercise, name='getExercise'),
    path('api/exercises/deleteExercise/<int:exercise_id>/',views.deleteExercise, name='deleteExercise'),



]
