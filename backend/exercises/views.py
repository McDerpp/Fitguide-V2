import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from models.models import Dataset, Model
from modelTrainingProcess.mainTraining import trainModel
from models.serializer import DatasetSerializer, ModelSerializer

from .serializer import AddExerciseSerializer, ExerciseSerializer
from .models import Exercise

from django.core.files import File
from django.conf import settings


@api_view(['POST'])
def add(request):
    if request.method == 'POST':
        exercise_serializer = AddExerciseSerializer(data=request.data)
        print(request.data)
        if exercise_serializer.is_valid():           
            positive_dataset = request.FILES.get("positiveDataset") 
            negative_dataset = request.FILES.get("negativeDataset") 

            exercise_serializer.save()
            exerciseID = exercise_serializer.instance.id

            positive_data = {
                "exercise": exerciseID,
                "dataset": positive_dataset,
                "isPositive": True
            }
                

            negative_data = {
                "exercise": exerciseID,
                "dataset": negative_dataset,
                "isPositive": False
            }

            positive_serializer = DatasetSerializer(data=positive_data)
            negative_serializer = DatasetSerializer(data=negative_data)

            if positive_serializer.is_valid():
                if negative_serializer.is_valid():
                    positive_serializer.save()
                    negative_serializer.save()

                    positive_dataset_training = positive_serializer.instance.dataset.path
                    negative_dataset_training = negative_serializer.instance.dataset.path

                    positive_dataset_training = os.path.join('media', positive_dataset_training)
                    negative_dataset_training = os.path.join('media', negative_dataset_training)

                    trained_model = trainModel(positive_dataset_training,negative_dataset_training)
                    trained_model =trained_model.replace("media/","")
                    file_path = os.path.join(settings.MEDIA_ROOT, trained_model)

                    model_data = Model(
                        exercise = exercise_serializer.instance,
                        valLoss = 0,
                        valAccuracy = 0,
                    )
                    with open(file_path, 'rb') as file:
                        django_file = File(file)
                        model_data.model.save(os.path.basename(file_path), django_file)
                    
                    model_data.save()
                      
                else:
                    return Response(negative_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(positive_serializer.errors, status=status.HTTP_400_BAD_REQUEST)   
            final_serializer = ExerciseSerializer(exercise_serializer.instance,context={'account_id': exercise_serializer.instance.account.id})
            
            return Response( final_serializer.data, status=status.HTTP_201_CREATED)
        return Response(exercise_serializer.errors, status=status.HTTP_400_BAD_REQUEST)




@api_view(['POST'])
def edit(request,exercise_id):
    if request.method == 'POST':
        exercise_edit = Exercise.objects.get(id=exercise_id)
        negative_dataset_edit = Dataset.objects.get(exercise=exercise_id, isPositive=True)
        positive_dataset_edit = Dataset.objects.get(exercise=exercise_id, isPositive=False)
        model_dataset_edit = Model.objects.get(exercise=exercise_id)
        print("request.data---> ",request.data)
        exercise_serializer = ExerciseSerializer(exercise_edit, data=request.data, partial=True)

        positive_dataset = request.FILES.get("positiveDataset") 
        negative_dataset = request.FILES.get("negativeDataset") 


        if positive_dataset is not None:
            positive_data = {
                "exercise": exercise_id,
                "dataset": positive_dataset,
                "isPositive": True
            }
            positive_serializer_edit = DatasetSerializer(positive_dataset_edit, data=positive_data, partial=True)
            if positive_serializer_edit.is_valid():
                positive_serializer_edit.save()                    
                positive_dataset_training = positive_serializer_edit.instance.dataset.path
                positive_dataset_training = os.path.join('media', positive_dataset_training)
            else:
                return Response(positive_serializer_edit.errors, status=status.HTTP_400_BAD_REQUEST)     
        elif positive_dataset is  None:
            positive_dataset_training = positive_dataset_edit.dataset.path
            positive_dataset_training = os.path.join('media', positive_dataset_training)
        
        else:
            return Response(positive_serializer_edit.errors, status=status.HTTP_400_BAD_REQUEST)                     
                   
        if negative_dataset is not None:
            negative_data = {
                "exercise": exercise_id,
                "dataset": negative_dataset,
                "isPositive": False
            }
            negative_serializer_edit = DatasetSerializer(negative_dataset_edit, data=negative_data, partial=True)
            if negative_serializer_edit.is_valid():
                negative_serializer_edit.save()
                negative_dataset_training = negative_serializer_edit.instance.dataset.path
                negative_dataset_training = os.path.join('media', negative_dataset_training)
            else:
                return Response(negative_serializer_edit.errors, status=status.HTTP_400_BAD_REQUEST)   
        elif negative_dataset is None:
            negative_dataset_training = negative_dataset_edit.dataset.path
            negative_dataset_training = os.path.join('media', negative_dataset_training)
        else:
            return Response(positive_serializer_edit.errors, status=status.HTTP_400_BAD_REQUEST)  
            
        
        if negative_dataset is not None or positive_dataset is not None :
            trained_model = trainModel(positive_dataset_training,negative_dataset_training)
            
            model_data = {"exercise" : exercise_id,
                    "model" : trained_model,
                    "valLoss" : 0,
                    "valAccuracy" : 0,
                    }
            model_serializer_edit = ModelSerializer(model_dataset_edit, data=model_data, partial=True)
            if model_serializer_edit.is_valid():                        
                model_serializer_edit.save()
            else:
                return Response(model_serializer_edit.errors, status=status.HTTP_400_BAD_REQUEST)   

                          
        if exercise_serializer.is_valid():  
            exercise_serializer.save()

        else:
            return Response(exercise_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
     
        return Response(exercise_serializer.data, status=status.HTTP_201_CREATED)
        

@api_view(['GET'])
def getExerciseCard(request,account_id):
    name = request.GET.get("name")
    parts = request.GET.get("parts")
    intensity = request.GET.get("intensity")
    tag = request.GET.get("tag")

    exercises = Exercise.objects.all()

    if name:
        exercises = exercises.filter(name__icontains=name)

    if parts:
        exercises = exercises.filter(parts=parts)

    if intensity:
        exercises = exercises.filter(intensity=intensity)

    if tag:
        exercises = exercises.filter(tag=tag)

    serializer = ExerciseSerializer(exercises,context={'account_id': account_id}, many=True)
    
        
    return Response(serializer.data)


@api_view(['GET'])    
def getExercise(request):
    if request.method == 'GET':        
        # id = request.data["id"]
        exercises = Exercise.objects.all()
        serializer = ExerciseSerializer(exercises, many=True)
    return Response(serializer.data)




@api_view(['DELETE'])
def deleteExercise(request,exercise_id):
    try:
        if not id:
            return Response({"detail": "ID parameter is required."}, status=status.HTTP_400_BAD_REQUEST)
        
        exercise = Exercise.objects.get(id=exercise_id)
        exercise.delete()

        return Response({"detail": "Exercise deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    
    except Exercise.DoesNotExist:
        return Response({"detail": "Exercise not found."}, status=status.HTTP_404_NOT_FOUND)