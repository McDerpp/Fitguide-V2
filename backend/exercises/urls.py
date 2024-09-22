from django.urls import path

from . import views


urlpatterns = [
    path('add/',views.add, name='add'),
    path('edit/<int:exercise_id>/',views.edit, name='edit'),
    path('getExerciseCard/<int:account_id>/',views.getExerciseCard, name='getExerciseCard'),
    # path('getExerciseCard/',views.getExerciseCard, name='getExerciseCard'),
    path('getExercise/',views.getExercise, name='getExercise'),
    path('deleteExercise/<int:exercise_id>/',views.deleteExercise, name='deleteExercise'),


]
