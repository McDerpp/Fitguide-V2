from django.urls import path
# from .views import datasetSubmit, generate_session_key, get_exercise, get_model, get_retrain_info, get_session_variable, retrain_model, set_session_variable,  get_demo, update_exercise
from . import views


urlpatterns = [
#     path('datasetSubmit/', datasetSubmit, name='datasetSubmit'),
#     path('set_session_variable/', set_session_variable,
#          name='set_session_variable'),
#     path('get_session_variable/', get_session_variable,
#          name='get_session_variable'),
#     path('generate_session_key/', generate_session_key,
#          name='generate_session_key'),
#     #     path('collect_exercise_info/', collect_exercise_info,
#     #          name='collect_exercise_info'),
#     path('get_retrain_info/', get_retrain_info,
#          name='get_retrain_info'),
#     path('get_model/<int:exercise_ID>/', get_model,
#          name='get_model'),
#     path('get_demo/<int:exercise_ID>/', get_demo,
#          name='get_demo'),
#     path('retrain_model/', retrain_model,
#          name='retrain_model'),
#      path('get_exercise/<int:exercise_ID>/', get_exercise,
#          name='get_exercise'),
#      path('update_exercise/', update_exercise,
#          name='update_exercise'),
         
# =======================================================================
     path('addDataset/', views.addDataset,name='addDataset'),   
     path('get_all_training/<int:account_id>/', views.get_all_training,name='get_all_training'),   
     path('delete_individual_training/<int:id>/', views.delete_individual_training,name='delete_individual_training'),   
     path('delete_all_training/', views.delete_all_training,name='delete_all_training'),   



     
     # path('trainModelRequest/<int:exercise_id>/', views.trainModelRequest,name='trainModelRequest')






]
