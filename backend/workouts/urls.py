from django.urls import path
from . import views


urlpatterns = [
    path('addWorkout/',views.addWorkout, name='addWorkout'),
    path('addWorkoutExercise/<int:workout_id>/<int:exercise_id>/',views.addWorkoutExercise, name='addWorkoutExercise'),
    path('getAllWorkout/<int:account_id>/',views.getAllWorkout, name='getAllWorkout'),
    path('getExercisesInWorkout/<int:workout_id>',views.getExercisesInWorkout, name='getExercisesInWorkout'),
    path('deleteWorkout/<int:workout_id>/',views.deleteWorkout, name='deleteWorkout'),
    path('editWorkout/<int:workout_id>/',views.editWorkout, name='editWorkout'),
    path('deleteWorkoutExercise/<int:workout_id>/<int:exercise_id>/',views.deleteWorkoutExercise, name='deleteWorkoutExercise'),



]
