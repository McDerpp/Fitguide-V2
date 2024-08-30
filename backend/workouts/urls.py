from django.urls import path
from . import views


urlpatterns = [
    path('api/workout/addWorkout/',views.addWorkout, name='addWorkout'),
    path('api/workout/addWorkoutExercise/<int:workout_id>/<int:exercise_id>/',views.addWorkoutExercise, name='addWorkoutExercise'),
    path('api/workout/getAllWorkout/<int:account_id>/',views.getAllWorkout, name='getAllWorkout'),
    path('api/workout/getExercisesInWorkout/<int:workout_id>',views.getExercisesInWorkout, name='getExercisesInWorkout'),
    path('api/workout/deleteWorkout/<int:workout_id>/',views.deleteWorkout, name='deleteWorkout'),
    path('api/workout/editWorkout/<int:workout_id>/',views.editWorkout, name='editWorkout'),
    path('api/workout/deleteWorkoutExercise/<int:workout_id>/<int:exercise_id>/',views.deleteWorkoutExercise, name='deleteWorkoutExercise'),



]
