from celery import shared_task
from .models import Exercise
from models.models import  Model
import os
from modelTrainingProcess.mainTraining import trainModel


from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

from django.conf import settings
from django.core.files import File

from django import forms



@shared_task(bind=True, acks_late=True)
def save_model(self,positive_dataset_training,negative_dataset_training,exercise_id):
    exercise = Exercise.objects.get(id=exercise_id)
    print("trying to save mode2")

    trained_model = trainModel(self,positive_dataset_training,negative_dataset_training)
    trained_model =trained_model.replace("media/","")
    file_path = os.path.join(settings.MEDIA_ROOT, trained_model)
    print("file_path ->",file_path)

    model_data = Model(
        exercise = exercise,
        valLoss = 0,
        valAccuracy = 0,
    )
    with open(file_path, 'rb') as file:
        django_file = File(file)
        model_data.model.save(os.path.basename(file_path), django_file)
    
    model_data.save()
    print("trying to save model1->",self.request.id)


