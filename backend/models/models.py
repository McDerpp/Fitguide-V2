from django.db import models
from exercises.models import Exercise

class Dataset(models.Model):
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    dataset = models.FileField(upload_to='datasets/') 
    isPositive = models.BooleanField(default=False)


class Model(models.Model):
    exercise = models.ForeignKey(Exercise, default= 1, on_delete=models.CASCADE)
    model = models.CharField(max_length=100,default="FILE PATH TEST")

    valLoss = models.FloatField(default=69)
    valAccuracy = models.FloatField(default=60)
