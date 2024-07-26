# serializers.py
from rest_framework import serializers
from .models import Account

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = '__all__'
    
    def create(self, validated_data):
        user = Account.objects.create_user(**validated_data)
        return user

# serializers.py
class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
