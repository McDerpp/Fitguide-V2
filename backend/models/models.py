from django.db import models
from exercises.models import Exercise

class Dataset(models.Model):
    exercise = models.ForeignKey(Exercise, related_name='datasets', on_delete=models.CASCADE)
    dataset = models.FileField(upload_to='datasets/', default='datasets/default_dataset.csv')
    numData = models.IntegerField(default=69)
    isPositive = models.BooleanField(default=False)


class Model(models.Model):
    exercise = models.ForeignKey(Exercise, related_name='model',default= 1, on_delete=models.CASCADE)
    model = models.FileField(upload_to='models/') 
    valLoss = models.FloatField(default=69)
    valAccuracy = models.FloatField(default=60)

class TrainingProgress(models.Model):
    taskId = models.CharField(max_length=255, unique=True)
    exercise = models.ForeignKey(Exercise, related_name='model_training',default= 1, on_delete=models.CASCADE)
    status = models.CharField(max_length=50, default='PENDING')
    createdAt = models.DateTimeField(auto_now_add=True)
    updatedAt = models.DateTimeField(auto_now=True)
    # progress = models.FloatField(default = 0.0)  

    def __str__(self):
        return f"Task {self.taskId} for exercise {self.exerciseId} with status {self.status}"



