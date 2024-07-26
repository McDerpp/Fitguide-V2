from django.db import models
from workouts.models import Workout
from accounts.models import Account

class WorkoutsDone(models.Model):
    workout = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    performed_at = models.DateTimeField(auto_now_add=True, null=True)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)




