from django.shortcuts import render

from accounts.models import Account
from exercises.models import Exercise
from workouts.models import Workout
from datetime import datetime, timedelta
from django.db.models.functions import TruncDay
from django.db.models import Count

from .models import FavoriteExercise, FavoriteWorkout,WorkoutsDone
from .serializer import FavoriteExerciseSerializer, FavoriteWorkoutsSerializer
from workouts.serializer import WorkoutDoneSerializer,AddWorkoutDoneSerializer



from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status

from django.utils import timezone

@api_view(['POST'])
def addWorkoutsDone(request, account_id, workout_id):
    if request.method == 'POST':
        data = request.data.copy()
        data['workout'] = workout_id  
        data['account'] = account_id 

        serializer = AddWorkoutDoneSerializer(data=data)        

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def getWorkoutsDone(request, account_id, year, month, day):
    try:
        start_datetime = timezone.make_aware(datetime(year, month, day, 0, 0, 0))
        end_datetime = timezone.make_aware(datetime(year, month, day, 23, 59, 59, 999999))
        
        done_workouts = WorkoutsDone.objects.filter(
            performed_at__range=(start_datetime, end_datetime),
            account_id=account_id
        ).select_related('workout')

        serializer = WorkoutDoneSerializer(done_workouts, many=True, context={'account_id': account_id})

        return Response(serializer.data, status=status.HTTP_200_OK)
    
    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def getWorkoutsDoneNumberMonthly(request, account_id, year, month):
    try:
        start_datetime = timezone.make_aware(datetime(year, month, 1, 0, 0, 0))
        
        next_month = month % 12 + 1
        next_month_year = year if next_month > 1 else year + 1
        last_day_of_month = datetime(next_month_year, next_month, 1) - timedelta(days=1)
        end_datetime = timezone.make_aware(datetime(last_day_of_month.year, last_day_of_month.month, last_day_of_month.day, 23, 59, 59, 999999))
        
        daily_workout_counts = WorkoutsDone.objects.filter(
            performed_at__range=(start_datetime, end_datetime),
            account_id=account_id
        ).annotate(
            day=TruncDay('performed_at')  
        ).values('day').annotate(
            count=Count('id') 
        ).order_by('day')

        daily_workout_counts_list = list(daily_workout_counts)

        return Response(daily_workout_counts_list, status=status.HTTP_200_OK)
    
    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST', 'DELETE'])
def addFavoriteWorkout(request, workout_id, account_id):
    if request.method == 'POST':
        try:
            workout = Workout.objects.get(id=workout_id)
            account = Account.objects.get(id=account_id)
        except Workout.DoesNotExist:
            return Response({'error': 'Workout not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Account.DoesNotExist:
            return Response({'error': 'Account not found.'}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['workout'] = workout_id  
        data['account'] = account_id  
        
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
