# Generated by Django 5.1 on 2024-09-26 05:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("exercises", "0019_remove_exercise_numexecution_remove_exercise_numset"),
    ]

    operations = [
        migrations.AddField(
            model_name="exercise",
            name="numExecution",
            field=models.IntegerField(default=5),
        ),
        migrations.AddField(
            model_name="exercise",
            name="numSet",
            field=models.IntegerField(default=5),
        ),
    ]
