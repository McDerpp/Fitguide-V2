from django.db import models
from accounts.models import Account



class Exercise(models.Model):
    name = models.CharField(max_length=100,default="THIS IS THE NAME")
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)
    description = models.TextField(blank=True, default="BLAH BLAH BLAH?!")
    intensity = models.CharField(max_length=35, default="EZ AF")
    estimated_time = models.IntegerField(default=69,null=True,)
    image = models.ImageField(upload_to='images/', null=True, blank=True) 
    video = models.FileField(upload_to='videos/', null=True, blank=True)  
    ignoreCoordinates = models.CharField(max_length=300, default=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33])
    numExecution = models.IntegerField(default=69)
    numSet = models.IntegerField(default=69)
    uploaded_at = models.DateTimeField(auto_now_add=True, null=True)
    is_active = models.BooleanField(default=True,)
    is_custom = models.BooleanField(default=True,)
    parts = models.CharField(max_length=100,default="THIS IS A PART")



class ExerciseFavorite(models.Model):
    exercise = models.ForeignKey(Exercise,default=1, on_delete=models.CASCADE)
    account = models.ForeignKey(Account,default=1, on_delete=models.CASCADE)
