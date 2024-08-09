from django.db import models
from exercises.models import Exercise
from workouts.models import Workout
from accounts.models import Account

class WorkoutsDone(models.Model):
    workout = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    performed_at = models.DateTimeField(auto_now_add=True, null=True)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)


class FavoriteWorkout(models.Model):
    workout = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)

class FavoriteExercise(models.Model):
    exercise = models.ForeignKey(Exercise,default=1, on_delete=models.CASCADE)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)






