# serializers.py
from rest_framework import serializers

from accounts.serializers import AccountSerializer
from exercises.serializer import ExerciseSerializer
from history.models import FavoriteWorkout
from history.serializer import FavoriteWorkoutsSerializer

from .models import Workout,WorkoutExercise

class AddWorkoutSerializer(serializers.ModelSerializer):   

    class Meta:
        model = Workout
        fields = '__all__'

# class WorkoutSerializer(serializers.ModelSerializer):   
#     is_favorited = serializers.SerializerMethodField()
#     class Meta:
#         model = Workout
#         fields = '__all__'

#     def get_is_favorited(self, obj):
#         print("getting fav")
#         account_id = self.context.get('account_id')
#         if account_id:
#             print("account_id-->",account_id)
#             return FavoriteWorkout.objects.filter(
#                 workout=obj,
#                 account_id=account_id
#             ).exists()
#         return False
    

class WorkoutExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkoutExercise
        fields = '__all__'
        
class GetWorkoutExerciseSerializer(serializers.ModelSerializer):
    exercise = ExerciseSerializer()

    class Meta:
        model = WorkoutExercise
        fields = '__all__'
        


class WorkoutSerializer(serializers.ModelSerializer):   
    is_favorited = serializers.SerializerMethodField()
    exercises = serializers.SerializerMethodField()

    account = AccountSerializer()

    class Meta:
        model = Workout
        fields = '__all__'

    def get_is_favorited(self, obj):
        account_id = self.context.get('account_id')
        if account_id:
            return FavoriteWorkout.objects.filter(
                workout=obj,
                account_id=account_id
            ).exists()
        return False
    

    def get_exercises(self, obj):
        workout_exercises = WorkoutExercise.objects.filter(workout=obj)
        return WorkoutExerciseSerializer(workout_exercises, many=True).data