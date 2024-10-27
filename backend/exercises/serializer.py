# serializers.py
from rest_framework import serializers

from accounts.serializers import AccountSerializer
from models.models import TrainingProgress
from history.models import FavoriteExercise
from history.serializer import FavoriteWorkoutsSerializer
from models.serializer import DatasetSerializer, GetModelSerializer, ModelSerializer

from .models import Exercise,ExerciseFavorite

class ExerciseSerializer(serializers.ModelSerializer):
    is_favorited = serializers.SerializerMethodField()
    datasets = DatasetSerializer(many=True, read_only=True)
    model = GetModelSerializer(many=True, read_only=True)
    account = AccountSerializer() 

    class Meta:
        model = Exercise
        fields = '__all__'

    def get_is_favorited(self, obj):
        account_id = self.context.get('account_id')
        if account_id:
            return FavoriteExercise.objects.filter(
                exercise=obj,
                account_id=account_id
            ).exists()
        return False
    
class AddExerciseSerializer(serializers.ModelSerializer):

    class Meta:
        model = Exercise
        fields = '__all__'

class TrainingProgressSerializer(serializers.ModelSerializer):
    exercise = ExerciseSerializer( read_only = True)
    class Meta:
        model = TrainingProgress
        fields = '__all__'