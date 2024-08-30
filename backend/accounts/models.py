from django.contrib.auth.models import AbstractUser
from django.db import models
from decimal import Decimal

class Account(AbstractUser):
    userType = models.CharField(max_length=15)
    height = models.DecimalField(
        default=Decimal('69.00'), 
        decimal_places=2,
        max_digits=5 
    )
    
    weight = models.DecimalField(
        default=Decimal('69.00'),  
        decimal_places=2,
        max_digits=5  
    )


    groups = None
    user_permissions = None

    def __str__(self):
        return self.username
