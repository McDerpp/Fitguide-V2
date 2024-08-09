import os
import random as rand
from datetime import datetime
from django.shortcuts import render

from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .serializer import DatasetSerializer,ModelSerializer

from django.views.decorators.csrf import csrf_exempt
from django.http import FileResponse, HttpResponse, HttpResponseNotFound, JsonResponse, StreamingHttpResponse
import json
import requests
import joblib


from modelTrainingProcess.dataAugmentations import translateCollectedDatatoTxt, txt_pre_process

from exercises.models import Exercise
from models.models import Dataset, Model
from modelTrainingProcess.mainTraining import trainModel

from django.contrib.sessions.backends.db import SessionStore

from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response


def test_connection(request):
    response = {'message': 'Connected to Django server successfully'}
    return JsonResponse(response)


@csrf_exempt
def set_session_variable(request):
    session_key = request.META.get('HTTP_AUTHORIZATION')
    print("session key is this 2-->", session_key)

    if session_key:
        print("giving value")
        session_store = SessionStore(session_key=session_key)

        variable_name = 'variable_name'
        variable_value = '153153153'

        session_store[variable_name] = variable_value
        session_store.save()

        return JsonResponse({'message': 'Session variable set successfully'})
    else:
        return JsonResponse({'error': 'No session key provided'})


@csrf_exempt
def get_session_variable(request):
    session_key = request.META.get('HTTP_AUTHORIZATION')
    print("session key is this 3-->", session_key)

    if session_key:
        session_store = SessionStore(session_key=session_key)

        value = session_store.get('variable_name')
        print("Session variable value:", value)

        if value is not None:
            return JsonResponse({'value': value})
        else:
            return JsonResponse({'error': 'Session variable not found'})
    else:
        return JsonResponse({'error': 'No session key provided'})


@csrf_exempt
def generate_session_key(request):
    session_store = SessionStore()
    session_store.save()  # Save the session to generate a session key
    session_key = session_store.session_key
    return HttpResponse(session_key)


def get_model(request, exercise_ID):
    dataset_info = Dataset.objects.get(
        exerciseID=exercise_ID, isPositive=0)
    model_info = Model.objects.filter(
        datasetID_id=dataset_info.datasetID).first()

    model_url = settings.base_path + model_info.modelUrl

    try:
        response = FileResponse(open(model_url, 'rb'))
        response['Content-Disposition'] = 'attachment; filename="model_file.tflite"'
        return HttpResponse(response, status=200)
    except FileNotFoundError:
        return HttpResponse('File not found', status=404)
    except Exception as e:
        return HttpResponse('An error occurred', status=500)


def get_demo(request, exercise_ID):
    try:
        if not exercise_ID:
            return HttpResponse('Exercise ID is required', status=400)

        try:
            exercise_info = Exercise.objects.get(id=exercise_ID)
        except Exercise.DoesNotExist:
            return HttpResponseNotFound('Exercise not found')
        print("settings.base_path --> ", settings.base_path)
        print("exercise_info.video --> ", str(exercise_info.video))
        video_path = settings.base_path + str(exercise_info.video)

        

        try:
            with open(video_path, 'rb') as video_file:
                response = HttpResponse(
                    video_file.read(), content_type='video/mp4')
                response['Content-Length'] = os.path.getsize(video_path)
            return response

        except Exception as error:
            print("get demo error -->", error)

            return response

    except Exception as e:
        return HttpResponse('An error occurred', status=500)


def get_retrain_info(request):
    exercise_info_queryset = Exercise.objects.filter(userID='696969')

    load_data = []

    if exercise_info_queryset.exists():
        exercise_info = exercise_info_queryset.all()
        for exercise in exercise_info:
            dataset_info_queryset = exercise.dataset_set.all()

            dataset_info_list = []
            for dataset_info in dataset_info_queryset:
                dataset_id = dataset_info.datasetID
                dataset_url = settings.base_path + dataset_info.datasetURL
                num_execution_dataset = dataset_info.numExecution
                avg_sequence = dataset_info.avgSequence
                min_sequence = dataset_info.minSequence
                max_sequence = dataset_info.maxSequence

                dataset_info_dict = {
                    'dataset_id': dataset_id,
                    'dataset_url': dataset_url,
                    'num_execution_dataset': num_execution_dataset,
                    'avg_sequence': avg_sequence,
                    'min_sequence': min_sequence,
                    'max_sequence': max_sequence,
                }
                dataset_info_list.append(dataset_info_dict)

            print("exercise.exerciseID --> ",
                  exercise.exerciseID)

            dataset_info = Dataset.objects.get(
                exerciseID=exercise.exerciseID, isPositive=False)
            model_info = Model.objects.get(datasetID=dataset_info)
            data = {
                'exercise_id': exercise.exerciseID,
                'exercise_demo': exercise.exerciseDemo,
                'exercise_name': exercise.exerciseName,
                'ignore_coordinates': exercise.ignoreCoordinates,
                'model_accuracy': model_info.valAccuracy,

                # 'num_execution': exercise.numExecution,
                # 'num_set': exercise.numSet,
                'dataset_info': dataset_info_list,
                # 'model_saved':model_saved,
            }
            load_data.append(data)
        response_data = json.dumps(load_data)

        return HttpResponse(response_data, content_type='application/json', status=200)
    else:
        return HttpResponse("Exercise not found.", status=404)


@csrf_exempt
def retrain_model(request):
    if request.method == 'POST':
        exercise_Id = request.POST.get('exerciseId')
        isNewRetrain = request.POST.get('isNewRetrain')

        try:
            # exercise_info = Exercise.objects.get(id=exercise_Id)
            exercise_info = Exercise.objects.get(id=76)

            dataset_info_queryset = exercise_info.dataset_set.all()
            uploaded_file = request.FILES['positiveDataset']
            uploaded_file2 = request.FILES['negativeDataset']

            randId_dataset = rand.randint(0, 999999999)

            formatted_number = '{:07d}'.format(randId_dataset)
            final_rand_id = str(formatted_number)

            # randId_filename_correct = 'coordinates_' +  final_rand_id + '_' + month + day + year + '.txt'
            randId_filename_postive = 'coordinates_positive_' + final_rand_id + '.txt'
            randId_filename_negative = 'coordinates_negative_' + final_rand_id + '.txt'

            destination_folder_positive = settings.base_path + \
                'fitguide_backend/assets/trainingData/negativeData'
            destination_folder_negative = settings.base_path + \
                'fitguide_backend/assets/trainingData/positiveData'

            os.makedirs(destination_folder_positive, exist_ok=True)
            os.makedirs(destination_folder_negative, exist_ok=True)

            file_path_positive = os.path.join(
                destination_folder_positive + '/', randId_filename_postive)

            with open(file_path_positive, 'wb') as destination_folder_positive:
                for chunk in uploaded_file.chunks():
                    destination_folder_positive.write(chunk)

            file_path_negative = os.path.join(
                destination_folder_negative + '/', randId_filename_negative)

            with open(file_path_negative, 'wb') as destination_folder_negative:
                for chunk in uploaded_file2.chunks():
                    destination_folder_negative.write(chunk)

            positive_dataset_temp_uploaded = txt_pre_process(
                file_path_positive, 1)
            positive_dataset_temp_uploaded = positive_dataset_temp_uploaded[0]
            negative_dataset_temp_uploaded = txt_pre_process(
                file_path_negative, 0)
            negative_dataset_temp_uploaded = negative_dataset_temp_uploaded[0]

            print("positive_dataset_temp_uploaded -->",
                  len(positive_dataset_temp_uploaded))
            print("negative_dataset_temp_uploaded -->",
                  len(negative_dataset_temp_uploaded))

            print(dataset_info_queryset)
            for dataset in dataset_info_queryset:
                if (dataset.isPositive == True):
                    dataset_URL_positive = settings.base_path + dataset.datasetURL
                    positive_dataset_temp = txt_pre_process(
                        settings.base_path + dataset.datasetURL, 1)

                else:
                    dataset_URL_negative = settings.base_path + dataset.datasetURL
                    negative_dataset_temp = txt_pre_process(
                        settings.base_path + dataset.datasetURL, 0)

            positive_dataset_temp = positive_dataset_temp[0]
            negative_dataset_temp = negative_dataset_temp[0]
            
            if(isNewRetrain=='false'):
                print("ADDING ON EXISTING DATASET")
                positive_dataset_temp.extend(
                    positive_dataset_temp_uploaded)
                negative_dataset_temp.extend(
                    negative_dataset_temp_uploaded)
            else:
                print("DELETING DATASET")

                positive_dataset_temp = []
                negative_dataset_temp = []
                positive_dataset_temp.extend(
                    positive_dataset_temp_uploaded)
                negative_dataset_temp.extend(
                    negative_dataset_temp_uploaded)
                

            translateCollectedDatatoTxt(
                positive_dataset_temp, dataset_URL_positive)
            translateCollectedDatatoTxt(
                negative_dataset_temp, dataset_URL_negative)
            print("dataset.datasetID retraining ---->", dataset.datasetID)

            model_info = Model.objects.get(datasetID_id=dataset.datasetID)

            print("model_info retraining ---->", model_info)

            for dataset in dataset_info_queryset:
                if (dataset.isPositive == True):
                    dataset.numExecution = len(positive_dataset_temp)
                    dataset.save()
                else:
                    dataset.numExecution = len(negative_dataset_temp)
                    dataset.save()

            trainModel(dataset_URL_positive, dataset_URL_negative,
                       None, model_info)

        except Exercise.DoesNotExist:
            return HttpResponse("Exercise not found.", status=404)

        return HttpResponse(exercise_Id, content_type='json', status=200)


# ========================================================================================================================================================================================


# @csrf_exempt
# def datasetSubmit(request):
#     base_dir = os.path.dirname(os.path.abspath(__file__))
#     if request.method == 'POST':

#         session_key = request.META.get('HTTP_AUTHORIZATION')
#         session_store = SessionStore(session_key=session_key)

#         uploaded_file = request.FILES['positiveDataset']
#         uploaded_file2 = request.FILES['negativeDataset']
#         uploaded_file3 = request.FILES['videoDemo']
#         uploaded_file4 = request.FILES['exerciseImage']


#         # exercise_image = settings.base_path + \
#         #     "fitguide_backend\media\images\exercises\pullup.jpg"

#         # current_datetime = datetime.now()

#         randId_dataset = rand.randint(0, 999999999)
#         randId_exercise = rand.randint(0, 999999999)

#         formatted_number = '{:07d}'.format(randId_dataset)
#         final_rand_id = str(formatted_number)

#         # randId_filename_correct = 'coordinates_' +  final_rand_id + '_' + month + day + year + '.txt'
#         randId_filename_postive = 'coordinates_positive_' + final_rand_id + '.txt'
#         randId_filename_negative = 'coordinates_negative_' + final_rand_id + '.txt'
#         randId_filename_video = 'video' + final_rand_id + '.mp4'

#         destination_folder_positive = settings.base_path + \
#             'fitguide_backend/assets/trainingData/positiveData'
#         destination_folder_negative = settings.base_path + \
#             'fitguide_backend/assets/trainingData/negativeData'
#         destination_folder_video = settings.base_path + \
#             'fitguide_backend/assets/videoDemo'
#         destination_folder_image = settings.base_path + \
#             'fitguide_backend/media/images/exercises'
        
        

#         # destination_folder_positive = os.path.join(base_dir, 'assets', 'trainingData', 'positiveData')
#         # destination_folder_negative = os.path.join(base_dir, 'assets', 'trainingData', 'negativeData')
#         # destination_folder_video = os.path.join(base_dir, 'assets', 'videoDemo')
#         os.makedirs(destination_folder_positive, exist_ok=True)
#         os.makedirs(destination_folder_negative, exist_ok=True)
#         os.makedirs(destination_folder_video, exist_ok=True)
#         os.makedirs(destination_folder_image, exist_ok=True)

#         # file_name = uploaded_file.name
# # ===============================================================================

#         file_path_positive = os.path.join(
#             destination_folder_positive + '/', randId_filename_postive)

#         with open(file_path_positive, 'wb') as destination_folder_positive:
#             for chunk in uploaded_file.chunks():
#                 destination_folder_positive.write(chunk)

# # ===============================================================================
#         file_path_negative = os.path.join(
#             destination_folder_negative + '/', randId_filename_negative)

#         with open(file_path_negative, 'wb') as destination_folder_negative:
#             for chunk in uploaded_file2.chunks():
#                 destination_folder_negative.write(chunk)
# # ===============================================================================
#         file_path_video = os.path.join(
#             destination_folder_video + '/', randId_filename_video)

#         with open(file_path_video, 'wb') as destination_folder_video:
#             for chunk in uploaded_file3.chunks():
#                 destination_folder_video.write(chunk)
# # ===============================================================================
#         image_path = os.path.join(
#                 destination_folder_image + '/', randId_filename_video)
#         with open(image_path, 'wb') as destination_folder_image:
#             for chunk in uploaded_file4.chunks():
#                 destination_folder_image.write(chunk)

#         request.session.save()


# # ExerciseInfo===========================================================
#         exercise_name = request.POST.get('name')
#         ingore_coordinates = request.POST.get('ingoreCoordinates')
#         exercise_num_set = request.POST.get('sets')
#         exercise_num_execution = request.POST.get('repetitions')
#         exercise_difficulty = request.POST.get('difficulty')
#         exercise_description = request.POST.get('description')



#         # exercise_info = ExerciseInfo(
#         #     exerciseID=randId_exercise,
#         #     exerciseDemo=file_path_video,
#         #     exerciseName=exercise_name,
#         #     ignoreCoordinates=ingore_coordinates,
#         #     numExecution=exercise_num_set,
#         #     numSet=exercise_num_execution,
#         # )

#         exercise_info = Exercise(
#             video=file_path_video.replace(settings.base_path, ""),
#             name=exercise_name,
#             description=exercise_description,
#             ignoreCoordinates=ingore_coordinates,
#             repetitions=exercise_num_execution,
#             sets=exercise_num_set,
#             image = image_path,
#             difficulty = exercise_difficulty
#         )

#     exercise_info.save()

# # Dataset===========================================================
#     num_execution_positive = request.POST.get('numExecutionPositive')
#     avg_sequence_positive = request.POST.get('avgSequencePositive')
#     min_sequence_positive = request.POST.get('minSequencePositive')
#     max_sequence_positive = request.POST.get('maxSequencePositive')

#     num_execution_negative = request.POST.get('numExecutionNegative')
#     avg_sequence_negative = request.POST.get('avgSequenceNegative')
#     min_sequence_negative = request.POST.get('minSequenceNegative')
#     max_sequence_negative = request.POST.get('maxSequenceNegative')

#     session_key = request.POST.get('sessionKey')

#     dataset_info = Dataset(
#         # datasetID=randId_dataset,
#         exerciseID=exercise_info,
#         datasetURL=file_path_positive.replace(settings.base_path, ""),
#         numExecution=num_execution_positive,
#         avgSequence=avg_sequence_positive,
#         minSequence=min_sequence_positive,
#         maxSequence=max_sequence_positive,
#         isPositive=True
#     )
#     dataset_info.save()

#     dataset_info = Dataset(
#         # datasetID=randId_dataset,
#         exerciseID=exercise_info,
#         datasetURL=file_path_negative.replace(settings.base_path, ""),
#         numExecution=num_execution_negative,
#         avgSequence=avg_sequence_negative,
#         minSequence=min_sequence_negative,
#         maxSequence=max_sequence_negative,
#         isPositive=False
#     )
#     dataset_info.save()

#     model_info_instance = trainModel(
#         file_path_positive, file_path_negative, dataset_info, None)

#     return JsonResponse({'message': 'File uploaded successfully'}, status=200)
#     # else:
#     #     return JsonResponse({'error': 'Only POST requests are allowed'}, status=400)


# # def get_exercise(request, exercise_ID):
# #     try:
# #         if not exercise_ID:
# #             return HttpResponse('Exercise ID is required', status=400)

# #         try:
# #             exercise_info = Exercise.objects.get(id=exercise_ID)
# #         except Exercise.DoesNotExist:
# #             return HttpResponseNotFound('Exercise not found')
# #         print("settings.base_path --> ", settings.base_path)
# #         print("exercise_info.video --> ", str(exercise_info.video))

# #         video_path = settings.base_path + str(exercise_info.video)
# #         image_path = settings.base_path + str(exercise_info.image)


# #         print("demo vidoe path --> ", video_path)

# #         try:
# #             with open(video_path, 'rb') as video_file:
# #                 response = HttpResponse(
# #                     video_file.read(), content_type='video/mp4')
# #                 response['Content-Length'] = os.path.getsize(video_path)

# #             with open(image_path, 'rb') as video_file:
# #                 response = HttpResponse(
# #                     video_file.read(), content_type='video/mp4')
# #                 response['Content-Length'] = os.path.getsize(image_path)



# #             return response

# #         except Exception as error:
# #             print("get demo error -->", error)

# #             return response

# #     except Exception as e:
# #         return HttpResponse('An error occurred', status=500)





# # TESTING
# # =================================================================================
def get_exercise(request, exercise_ID):
    print("get exercise executed")
    try:
        if not exercise_ID:
            return HttpResponse('Exercise ID is required', status=400)

        try:
            exercise_info = Exercise.objects.get(id=exercise_ID)
        except Exercise.DoesNotExist:
            return HttpResponseNotFound('Exercise not found')

        video_path = settings.base_path + str(exercise_info.video)
        image_path = settings.base_path + str(exercise_info.image)

        try:
            # with open(video_path, 'rb') as video_file:
            #     video_data = video_file.read()

            # with open(image_path, 'rb') as image_file:
            #     image_data = image_file.read()

            response_data = {
                'exercise_info': {
                    'id': exercise_info.id,
                    'name': exercise_info.name,
                    'description': exercise_info.description,
                    'difficulty': exercise_info.difficulty,
                    'set': exercise_info.sets,
                    'repetitions': exercise_info.repetitions,
                    # 'video_path': video_path,
                    # 'image_path': image_path,
                },
                # 'video_data': video_data,
                # 'image_data': image_data,
            }

            response = HttpResponse(
                json.dumps(response_data), content_type='application/json')
            return response

        except Exception as error:
            print("get demo error -->", error)
            return HttpResponse('An error occurred', status=500)

    except Exception as e:
        return HttpResponse('An error occurred', status=500)

# TESTING
# =================================================================================
@csrf_exempt
def update_exercise(request):
    try:

        print("name got it -->",request.POST.get('id'))
        exercise_info = Exercise.objects.get(id=request.POST.get('id'))
        print("request.POST.get('name')--->",request.POST.get('name'))

        exercise_info.name=request.POST.get('name')
        print("request.POST.get('description')--->",request.POST.get('description'))

        exercise_info.description=request.POST.get('description')
        print("request.POST.get('ingoreCoordinates')--->",request.POST.get('ingoreCoordinates'))

        exercise_info.ignoreCoordinates=request.POST.get('ingoreCoordinates')
        print("request.POST.get('difficulty')--->",request.POST.get('difficulty'))

        exercise_info.difficulty=request.POST.get('difficulty')
        print("request.POST.get('sets')--->",request.POST.get('sets'))

        exercise_info.sets=request.POST.get('sets')
        print("request.POST.get('repetitions')--->",request.POST.get('repetitions'))

        exercise_info.repetitions=request.POST.get('repetitions')
        exercise_info.save()

        return HttpResponse('Exercise updated successfully', status=200)
    except Exception as e:
        error_message = f'An error occurred: {str(e)}'
        return HttpResponse(error_message, status=500)
    
@api_view(['POST'])
def addDataset(request):
    if request.method == 'POST':
        serializer = DatasetSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def trainModelRequest(request, exercise_id):
    if request.method == 'POST':
        dataset = Dataset.objects.filter(exercise_id=exercise_id).values()
        exercise = Exercise.objects.get(id=exercise_id)

        for data in dataset:
            if data['isPositive']==True:  
                positive_dataset = os.path.join('media', data["dataset"])
            else:
                negative_dataset = os.path.join('media', data["dataset"])
                print("negative_dataset----->",negative_dataset)
                

        trained_model = trainModel(positive_dataset,negative_dataset)


        serializer = ModelSerializer(data={"exercise" : exercise.id,
            "model" : trained_model,
            "valLoss" : 0,
            "valAccuracy" : 0,
            })

        if serializer.is_valid():
                try:
                    serializer.save()
                    return Response(serializer.data, status=status.HTTP_201_CREATED)
                except Exception as e:
                    return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({"error": "Bad request"}, status=status.HTTP_400_BAD_REQUEST)