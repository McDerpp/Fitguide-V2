from django.urls import path
from . import views
from datetime import datetime


urlpatterns = [
    path('addWorkoutsDone/<int:workout_id>/<int:account_id>/',views.addWorkoutsDone, name='addWorkoutsDone'),
    path('getWorkoutsDone/<int:account_id>/<int:year>/<int:month>/<int:day>/', views.getWorkoutsDone, name='getWorkoutsDone'),
    path('addFavoriteWorkout/<int:workout_id>/<int:account_id>/',views.addFavoriteWorkout, name='addFavoriteWorkout'),
    path('addFavoriteExercise/<int:exercise_id>/<int:account_id>/',views.addFavoriteExercise, name='addFavoriteExercise'),
    path('getWorkoutsDoneNumberMonthly/<int:account_id>/<int:year>/<int:month>/', views.getWorkoutsDoneNumberMonthly, name='getWorkoutsDoneNumberMonthly'),
    path('getWorkoutsDoneNumberWeekly/<int:account_id>/<int:year>/<int:month>/<int:week>', views.getWorkoutsDoneNumberMonthly, name='getWorkoutsDoneNumberMonthly'),


]
