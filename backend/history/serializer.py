from rest_framework import serializers
from .models import WorkoutsDone

class WorkoutsDoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkoutsDone
        fields = '__all__'
    