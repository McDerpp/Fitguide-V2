# Generated by Django 4.1 on 2024-07-16 08:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("exercises", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="exercise",
            name="description",
            field=models.TextField(blank=True, default="BLAH BLAH BLAH?!"),
        ),
        migrations.AlterField(
            model_name="exercise",
            name="estimated_time",
            field=models.IntegerField(default=69, max_length=100, unique=True),
        ),
        migrations.AlterField(
            model_name="exercise",
            name="intensity",
            field=models.CharField(default="EZ AF", max_length=100, unique=True),
        ),
        migrations.AlterField(
            model_name="exercise",
            name="name",
            field=models.CharField(
                default="THIS IS THE NAME", max_length=100, unique=True
            ),
        ),
    ]
