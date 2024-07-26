from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .serializer import ExerciseSerializer
from .models import Exercise

@api_view(['POST'])
def add(request):
    if request.method == 'POST':
        serializer = ExerciseSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# this is for exercise card in exercise library
@api_view(['GET'])
def getExerciseCard(request):
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

    serializer = ExerciseSerializer(exercises, many=True)
        
    return Response(serializer.data)

@api_view(['GET'])    
def getExercise(request):
    if request.method == 'GET':        
        id = request.data["id"]
        exercises = Exercise.objects.filter(id=id)
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