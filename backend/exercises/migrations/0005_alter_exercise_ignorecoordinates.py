# Generated by Django 4.1 on 2024-07-16 11:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("exercises", "0004_exercise_ignorecoordinates_exercise_is_custom_and_more"),
    ]

    operations = [
        migrations.AlterField(
            model_name="exercise",
            name="ignoreCoordinates",
            field=models.CharField(
                default=[
                    0,
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7,
                    8,
                    9,
                    10,
                    11,
                    12,
                    13,
                    14,
                    15,
                    16,
                    17,
                    18,
                    19,
                    20,
                    21,
                    22,
                    23,
                    24,
                    25,
                    26,
                    27,
                    28,
                    29,
                    30,
                    31,
                    32,
                    33,
                ],
                max_length=300,
            ),
        ),
    ]
