from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Workout,WorkoutExercise
from exercises.models import Exercise
from exercises.serializer import ExerciseSerializer

from .serializer import WorkoutSerializer,WorkoutExerciseSerializer

@api_view(['POST'])
def addWorkout(request):
    if request.method == 'POST':
        serializer = WorkoutSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['POST'])
def editWorkout(request, workout_id):
    try:
        # Retrieve the existing workout entry
        workout = Workout.objects.get(id=workout_id)
    except Workout.DoesNotExist:
        return Response({'error': 'Workout not found'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'POST':
        
        serializer = WorkoutSerializer(workout, data=request.data, partial=True) 
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteWorkout(request,workout_id):
    try:
        if not id:
            return Response({"detail": "ID parameter is required."}, status=status.HTTP_400_BAD_REQUEST)
        
        workout = Workout.objects.get(id=workout_id)
        workout.delete()

        return Response({"detail": "Workout deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    
    except Exercise.DoesNotExist:
        return Response({"detail": "Workout not found."}, status=status.HTTP_404_NOT_FOUND)


# for adding exercise for workout
@api_view(['POST'])
def addWorkoutExercise(request):
    if request.method == 'POST':
        exercise = Exercise.objects.get(id=int(request.data["exercise"]))
        workout = Workout.objects.get(id=int(request.data["workout"]))
        if exercise and workout:
            serializer = WorkoutExerciseSerializer(data=request.data)
            print(request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response("workout or exercise not", status=status.HTTP_404_NOT_FOUND)



@api_view(['GET'])    
def getWorkoutCard(request):
    if request.method == 'GET':
        search = request.query_params.get('search', None)
        if search:
            workout = Workout.objects.filter(name__icontains=search).order_by('name')
        else:
            workout = Workout.objects.all().order_by('name')

        serializer = WorkoutSerializer(workout, many=True)
    return Response(serializer.data)




@api_view(['POST'])
def getExercisesInWorkout(request,workout_id):
    if request.method == 'POST':

        workout_exercises = WorkoutExercise.objects.filter(workout=workout_id)
        
        filtered_exercises = []

        for workout_exercise in workout_exercises:
            exercises = Exercise.objects.filter(id=workout_exercise.exercise.id)
            filtered_exercises.extend(exercises)
        
        serializer = ExerciseSerializer(filtered_exercises, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)