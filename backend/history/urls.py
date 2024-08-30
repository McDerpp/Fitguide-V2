from django.urls import path
from . import views
from datetime import datetime


urlpatterns = [
    path('api/history/addWorkoutsDone/<int:workout_id>/<int:account_id>/',views.addWorkoutsDone, name='addWorkoutsDone'),
    path('api/history/getWorkoutsDone/<int:account_id>/<int:year>/<int:month>/<int:day>/', views.getWorkoutsDone, name='getWorkoutsDone'),
    path('api/history/addFavoriteWorkout/<int:workout_id>/<int:account_id>/',views.addFavoriteWorkout, name='addFavoriteWorkout'),
    path('api/history/addFavoriteExercise/<int:exercise_id>/<int:account_id>/',views.addFavoriteExercise, name='addFavoriteExercise'),
    path('api/history/getWorkoutsDoneNumberMonthly/<int:account_id>/<int:year>/<int:month>/', views.getWorkoutsDoneNumberMonthly, name='getWorkoutsDoneNumberMonthly'),
    path('api/history/getWorkoutsDoneNumberWeekly/<int:account_id>/<int:year>/<int:month>/<int:week>', views.getWorkoutsDoneNumberMonthly, name='getWorkoutsDoneNumberMonthly'),





]
