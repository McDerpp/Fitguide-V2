from __future__ import absolute_import, unicode_literals

import os
from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from models.models import Dataset, Model, TrainingProgress
from modelTrainingProcess.mainTraining import trainModel
from models.serializer import DatasetSerializer, ModelSerializer

from .serializer import AddExerciseSerializer, ExerciseSerializer
from .models import Exercise
from .task import save_model
from rest_framework.pagination import PageNumberPagination



from django.core.files import File
from django.conf import settings
import json



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
                
            print("positive_data->",positive_data)

            negative_data = {
                "exercise": exerciseID,
                "dataset": negative_dataset,
                "isPositive": False
            }
            print("negative_data->",negative_data)



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



                    result = save_model.delay(positive_dataset_training,negative_dataset_training,exerciseID)
                   
                    
                    TrainingProgress.objects.create(taskId=result.id, exercise=exercise_serializer.instance)
                    print("test123142 -> ",result.id)
                      
                else:
                    return Response(negative_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(positive_serializer.errors, status=status.HTTP_400_BAD_REQUEST)   
            final_serializer = ExerciseSerializer(exercise_serializer.instance,context={'account_id': exercise_serializer.instance.account.id})
            
            # return Response( final_serializer.data, status=status.HTTP_201_CREATED)
            return Response( result.id, status=status.HTTP_201_CREATED)

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
        


from rest_framework.pagination import PageNumberPagination
from math import ceil

@api_view(['POST'])
def getExerciseCard(request, account_id):
    name = request.data.get("name")
    parts = request.data.get("parts") 
    intensity = request.data.get("intensity")
    tag = request.data.get("tag")

    exercises = Exercise.objects.all()

    if name:
        exercises = exercises.filter(name__icontains=name)

    if parts:
        try:
            parts_list = json.loads(parts)
            exercises = exercises.filter(parts__contains=parts_list)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid parts format"}, status=400)

    if intensity:
        exercises = exercises.filter(intensity=intensity)

    if tag:
        exercises = exercises.filter(tag=tag)

    exercises = exercises.filter(is_active=True)

    paginator = PageNumberPagination()
    paginator.page_size = 10
    paginated_exercises = paginator.paginate_queryset(exercises, request)

    serializer = ExerciseSerializer(paginated_exercises, context={'account_id': account_id}, many=True)

    # Calculate the total number of pages
    total_exercises = exercises.count()
    max_pages = ceil(total_exercises / paginator.page_size)

    response_data = {
        "results": serializer.data,
        "max_pages": max_pages
    }

    return paginator.get_paginated_response(response_data)



@api_view(['GET'])    
def getExercise(request):
    if request.method == 'GET':        
        # id = request.data["id"]
        exercises = Exercise.objects.filter(is_active = True)
        # exercises = Exercise.objects.all()

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



    
@api_view(['DELETE'])
def delete_all_exerccise(request):
    try:
        exercise_deleted, _ = Exercise.objects.all().delete() 
        return Response({"message": f"Successfully deleted {exercise_deleted} tasks"}, status=status.HTTP_202_ACCEPTED)
    except TrainingProgress.DoesNotExist:
        return Response({"message": "No exercises available"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['PUT'])
def activate_exercise(request,exercise_id):
    try:
        exercise = Exercise.objects.get(id=exercise_id)
        exercise.is_active = True
        exercise.save()
        trainingProgress = TrainingProgress.objects.get(exercise__id=exercise_id)
        trainingProgress.delete()
        
        return Response({"message": f"Successfully activated exercise {exercise_id}"}, status=status.HTTP_202_ACCEPTED)
    except TrainingProgress.DoesNotExist:
        return Response({"message": "No exercises available"}, status=status.HTTP_404_NOT_FOUND)
