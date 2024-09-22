from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import AccountSerializer
from django.contrib.auth import authenticate
from .models import Account
import secrets
import base64
from django.contrib.auth import authenticate, login as django_login
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from django.http import JsonResponse, HttpResponseRedirect

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

    user = authenticate(username=username, password=password)
    if user is not None:
        django_login(request, user)

    else:
        print("invalid")
    
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

# @api_view(['POST'])
# def login(request):
#     print("logging in")
#     username = request.data.get('username')
#     password = request.data.get('password')

#     user = authenticate(username=username, password=password)
#     if user is not None:
#         django_login(request, user) 

#         oauth_authorize_url = (
#             "http://192.168.1.2:8000/o/authorize/"
#             "?response_type=code"
#             "&code_challenge=RoxsenII9mUjv-S183E017HU_0ypOR5wU1WdKR5LKfw"
#             "&code_challenge_method=S256"
#             "&client_id=k8e52BKZe7c0unzk391GikxWomL7gKbkINDTcbWy"
#             "&redirect_uri=http://192.168.1.2:8000/accounts/oauth_callback"
#         )
#         print("user-->", user)

#         return HttpResponseRedirect(oauth_authorize_url)
#     else:
#         return Response({'error': 'Invalid credentials'}, status=400)

@api_view(['GET'])
def oauth_callback(request):
    print("oauth!")

    code = request.GET.get('code')
    if not code:
        return JsonResponse({'error': 'No authorization code provided'}, status=400)

    token_url = "http://192.168.1.2:8000/o/token/"
    data = {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'http://192.168.1.2:8000/accounts/oauth_callback',
        'client_id': 'k8e52BKZe7c0unzk391GikxWomL7gKbkINDTcbWy',
        'client_secret': 'your_client_secret_here', 
    }

    try:
        response = requests.post(token_url, data=data)
        response.raise_for_status()  # Raise an exception for HTTP error responses
        tokens = response.json()
        access_token = tokens.get('access_token')
        refresh_token = tokens.get('refresh_token')
        return JsonResponse({'access_token': access_token, 'refresh_token': refresh_token})
    except requests.RequestException as e:
        print(f"Request failed: {e}")
        return JsonResponse({'error': 'Failed to obtain access token'}, status=500)











@api_view(['POST'])
def test(request):
    print("logging ing")


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

def generate_code_verifier(length=64):
    code_verifier = secrets.token_bytes(length)
    code_verifier = base64.urlsafe_b64encode(code_verifier).rstrip(b'=').decode('ascii')
    return code_verifier

def generate_code_challenge(code_verifier):
    code_challenge = hashlib.sha256(code_verifier.encode()).digest()
    code_challenge = base64.urlsafe_b64encode(code_challenge).rstrip(b'=').decode('ascii')
    return code_challenge

# def oauth_callback(request):
#     print("IN THE CALLBACK RN")
#     code = request.GET.get('code')
#     if code:
#         access_token_data = get_access_token('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET', code, 'YOUR_REDIRECT_URI')
#         return HttpResponse(f"Access Token Data: {access_token_data}")
#     else:
#         return HttpResponse("Authorization code not provided.", status=400)

def get_access_token(client_id, client_secret, code, redirect_uri):
    code_verifier = generate_code_verifier()
    code_challenge = generate_code_challenge(code_verifier)
    url = "http://192.168.1.2:8000/o/token/"
    data = {
        'client_id': settings.CLIENT_ID,
        'client_secret': settings.CLIENT_SECRET,
        'code': code,
        'code_verifier': code_verifier,
        'redirect_uri': redirect_uri,
        'grant_type': 'authorization_code'
    }
    
    headers = {
        'Cache-Control': 'no-cache',
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    
    response = requests.post(url, data=data, headers=headers)
    
    if response.status_code == 200:
        return response.json()  
    else:
        response.raise_for_status()





# @api_view(['POST'])
# @csrf_exempt
# def login(request):
#     print("logging in")
#     username = request.data.get('username')
#     password = request.data.get('password')

#     user = authenticate(username=username, password=password)
#     if user is not None:
#         django_login(request, user) 

#         oauth_authorize_url = (
#             "http://192.168.1.2:8000/o/authorize/"
#             "?response_type=code"
#             "&code_challenge=RoxsenII9mUjv-S183E017HU_0ypOR5wU1WdKR5LKfw"
#             "&code_challenge_method=S256"
#             "&client_id=k8e52BKZe7c0unzk391GikxWomL7gKbkINDTcbWy"
#             "&redirect_uri=http://192.168.1.2:8000/accounts/oauth_callback"
#         )
#         print("user-->",user)

#         return Response({'redirect_url': oauth_authorize_url})



