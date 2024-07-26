from django.db import models
from accounts.models import Account
from exercises.models import Exercise



# for future: should have a filter for certain users that can share the workout for the whole users
# ordinary users: created workout can only be seen by himself
# creator users: created workout can be seen automatically by everyone 
# this should also be indicated
class Workout(models.Model):
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)
    name = models.CharField(max_length=100,default="THIS IS THE NAME")
    difficulty = models.CharField(max_length=100,default="Medium")
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='images/', null=True, blank=True) 
    

# this is used to add exercises to workout
class WorkoutExercise(models.Model):
    workout = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    exercise = models.ForeignKey(Exercise,default=1, on_delete=models.CASCADE)


class WorkoutFavorite(models.Model):
    exercise = models.ForeignKey(Workout,default=1, on_delete=models.CASCADE)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)