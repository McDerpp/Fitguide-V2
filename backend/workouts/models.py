from django.db import models
from accounts.models import Account
from exercises.models import Exercise




class Workout(models.Model):
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)
    name = models.CharField(max_length=100,default="THIS IS THE NAME")
    difficulty = models.CharField(max_length=100,default="Medium")
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='images/', null=True, blank=True) 
    

class WorkoutExercise(models.Model):
    workout = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    exercise = models.ForeignKey(Exercise,default=1, on_delete=models.CASCADE)


