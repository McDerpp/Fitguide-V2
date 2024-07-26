from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import AccountSerializer
from django.contrib.auth import authenticate

@api_view(['POST'])
def register(request):
    if request.method == 'POST':
        serializer = AccountSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')
    
    user = authenticate(username=username, password=password)
    
    if user is not None:
        return Response({'message': 'Login successful',
                          'user': user.username,
                          'fname':user.first_name,
                          'lname':user.last_name,
                          'email':user.email,
                          'joined':user.date_joined,
                          'usertype':user.userType,
                          'id':user.id,
                          
                          },)
    else:
        return Response({'error': 'Invalid credentials'}, status=400)
