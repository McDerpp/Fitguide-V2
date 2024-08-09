from django.db import models
from exercises.models import Exercise

class Dataset(models.Model):
    exercise = models.ForeignKey(Exercise,related_name='datasets', on_delete=models.CASCADE)
    dataset = models.FileField(upload_to='datasets/') 
    numData = models.IntegerField(default=69)
    isPositive = models.BooleanField(default=False)


class Model(models.Model):
    exercise = models.ForeignKey(Exercise, related_name='model',default= 1, on_delete=models.CASCADE)
    model = models.FileField(upload_to='models/') 
    valLoss = models.FloatField(default=69)
    valAccuracy = models.FloatField(default=60)
