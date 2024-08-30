from rest_framework import serializers
from .models import FavoriteExercise, FavoriteWorkout, WorkoutsDone


class WorkoutsDoneSerializer(serializers.ModelSerializer):    
    class Meta:
        model = WorkoutsDone
        fields = '__all__'
    
class FavoriteWorkoutsSerializer(serializers.ModelSerializer):
    class Meta:
        model = FavoriteWorkout
        fields = '__all__'


class FavoriteExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = FavoriteExercise
        fields = '__all__'
    


