# Generated by Django 5.1 on 2024-09-23 00:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("workouts", "0007_delete_workoutfavorite"),
    ]

    operations = [
        migrations.AddField(
            model_name="workoutexercise",
            name="reps",
            field=models.IntegerField(default=69),
        ),
        migrations.AddField(
            model_name="workoutexercise",
            name="sets",
            field=models.IntegerField(default=69),
        ),
    ]
