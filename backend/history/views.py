from django.shortcuts import render
from .serializer import WorkoutsDoneSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status



@api_view(['POST'])
def addWorkoutsDone(request):
    if request.method == 'POST':
        serializer = WorkoutsDoneSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET'])
def addWorkoutsDone(request):
    if request.method == 'GET':
        serializer = WorkoutsDoneSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    