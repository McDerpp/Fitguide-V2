from django.shortcuts import render

from accounts.models import Account
from exercises.models import Exercise
from workouts.models import Workout

from .models import FavoriteExercise, FavoriteWorkout
from .serializer import FavoriteExerciseSerializer, FavoriteWorkoutsSerializer, WorkoutsDoneSerializer
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
    


@api_view(['POST', 'DELETE'])
def addFavoriteWorkout(request, workout_id, account_id):
    if request.method == 'POST':
        # Check if the workout and account exist
        try:
            workout = Workout.objects.get(id=workout_id)
            account = Account.objects.get(id=account_id)
        except Workout.DoesNotExist:
            return Response({'error': 'Workout not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Account.DoesNotExist:
            return Response({'error': 'Account not found.'}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['workout'] = workout_id  # Note: use 'workout' instead of 'workout_id'
        data['account'] = account_id  # Note: use 'account' instead of 'account_id'
        
        serializer = FavoriteWorkoutsSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        favorite_workouts = FavoriteWorkout.objects.filter(workout_id=workout_id, account_id=account_id)
        if not favorite_workouts.exists():
            return Response({'error': 'Favorite workout not found.'}, status=status.HTTP_404_NOT_FOUND)
        
        favorite_workouts.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['POST', 'DELETE'])
def addFavoriteExercise(request, exercise_id, account_id):
    if request.method == 'POST':
        # Check if the exercise and account exist
        try:
            exercise = Exercise.objects.get(id=exercise_id)
            account = Account.objects.get(id=account_id)
        except exercise.DoesNotExist:
            return Response({'error': 'exercise not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Account.DoesNotExist:
            return Response({'error': 'Account not found.'}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['exercise'] = exercise_id 
        data['account'] = account_id  
        
        serializer = FavoriteExerciseSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        favorite_exercises = FavoriteExercise.objects.filter(exercise_id=exercise_id, account_id=account_id)
        if not favorite_exercises.exists():
            return Response({'error': 'Favorite exercise not found.'}, status=status.HTTP_404_NOT_FOUND)
        
        favorite_exercises.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
