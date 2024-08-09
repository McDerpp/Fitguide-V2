from django.urls import path
from . import views


urlpatterns = [
    path('api/history/addWorkoutsDone/',views.addWorkoutsDone, name='addWorkoutsDone'),
    path('api/history/addFavoriteWorkout/<int:workout_id>/<int:account_id>/',views.addFavoriteWorkout, name='addFavoriteWorkout'),
    path('api/history/addFavoriteExercise/<int:exercise_id>/<int:account_id>/',views.addFavoriteExercise, name='addFavoriteExercise'),




]
