from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Workout,WorkoutExercise
from exercises.models import Exercise
from exercises.serializer import ExerciseSerializer
from django.db.models import Q

from .serializer import AddWorkoutSerializer, WorkoutSerializer,WorkoutExerciseSerializer

@api_view(['POST'])
def addWorkout(request):
    if request.method == 'POST':
        serializer = AddWorkoutSerializer(data=request.data)
        if serializer.is_valid():
            workout = serializer.save()
            
            workout_serializer = WorkoutSerializer(workout)
            
            return Response(workout_serializer.data, status=status.HTTP_201_CREATED)
        
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
# def addWorkoutExercise(request,workout_id,exercise_id):
def addWorkoutExercise(request):
    if request.method == 'POST':
        exercise = Exercise.objects.get(id=int(request.data["exercise_id"]))
        workout = Workout.objects.get(id=int(request.data["workout_id"]))
        if exercise and workout:
            data = request.data.copy()
            data['exercise'] = exercise.id
            data['workout'] = workout.id
            data['sets'] = workout.id
            data['reps'] = workout.id
            serializer = WorkoutExerciseSerializer(data=data)
            print(request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response("workout or exercise not", status=status.HTTP_404_NOT_FOUND)

@api_view(['DELETE'])
def deleteWorkoutExercise(request,workout_id,exercise_id):
    try:
        if not workout_id:
            return Response({"detail": "ID parameter is required."}, status=status.HTTP_400_BAD_REQUEST)
        
        exercise = WorkoutExercise.objects.filter(workout_id=workout_id,exercise_id=exercise_id)
        print(exercise)
        exercise.delete()

        return Response({"detail": "Workout deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    
    except Exercise.DoesNotExist:
        return Response({"detail": "Workout not found."}, status=status.HTTP_404_NOT_FOUND)


# this gets all workouts that belongs to an account with usertype as FitCreator and also includes all of the workout created by the user
@api_view(['GET'])
def getAllWorkout(request, account_id):
    if request.method == 'GET':
        search = request.query_params.get('search', None)

        q_filter = Q(account__userType='Fit-Creator') | Q(account__id=account_id)
        
        workout = Workout.objects.filter(q_filter).order_by('name')     

        serializer = WorkoutSerializer(workout, context={'account_id': account_id}, many=True)
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