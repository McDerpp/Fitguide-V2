# serializers.py
from rest_framework import serializers
from .models import Exercise,ExerciseFavorite

class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = '__all__'
    

class ExerciseFavoriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExerciseFavorite
        fields = '__all__'
    
