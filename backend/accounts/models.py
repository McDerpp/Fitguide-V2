from django.contrib.auth.models import AbstractUser
from django.db import models

class Account(AbstractUser):
    userType = models.CharField(max_length=15)

    groups = None
    user_permissions = None

    def __str__(self):
        return self.username
