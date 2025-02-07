# Generated by Django 4.1 on 2024-07-16 11:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("exercises", "0003_remove_exercisefavorite_description_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="exercise",
            name="ignoreCoordinates",
            field=models.CharField(
                default=[
                    [
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
                    ]
                ],
                max_length=300,
            ),
        ),
        migrations.AddField(
            model_name="exercise",
            name="is_custom",
            field=models.BooleanField(default=True, null=True),
        ),
        migrations.AddField(
            model_name="exercise",
            name="numExecution",
            field=models.IntegerField(default=69),
        ),
        migrations.AddField(
            model_name="exercise",
            name="numSet",
            field=models.IntegerField(default=69),
        ),
    ]
