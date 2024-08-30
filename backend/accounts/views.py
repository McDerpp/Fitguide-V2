from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import AccountSerializer
from django.contrib.auth import authenticate
from .models import Account


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
    print("logging ing")
    username = request.data.get('username')
    password = request.data.get('password')

    print("username--->",username)
    print("password--->$",password)

    
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
                          'weight':user.weight,
                          'height':user.height,

                          
                          },)
    else:
        return Response({'error': 'Invalid credentials'}, status=400)


@api_view(['POST'])
def editAccount(request):
    if request.method == 'POST':
        account_id = request.data.get('id')
        print("request.data-->",request.data)
        if account_id:
            try:
                account = Account.objects.get(id=account_id)
                print("found the account")

                serializer = AccountSerializer(account, data=request.data, partial=True)
            except Account.DoesNotExist:
                return Response({'detail': 'Account not found.'}, status=status.HTTP_404_NOT_FOUND)

        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK if account_id else status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
