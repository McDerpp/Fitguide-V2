# serializers.py
from rest_framework import serializers
from .models import Dataset,Model


class DatasetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dataset
        fields = '__all__'

# class ModelSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Model
#         fields = '__all__'
    
class ModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Model
        fields = ['exercise', 'valLoss', 'valAccuracy']

    def create(self, validated_data):
        return Model.objects.create(**validated_data)


class GetModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Model
        fields = '__all__'
