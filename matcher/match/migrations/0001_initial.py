# -*- coding: utf-8 -*-
# Generated by Django 1.10.1 on 2016-09-12 12:18
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Address',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('line1', models.CharField(max_length=200)),
                ('line2', models.CharField(max_length=200)),
                ('line3', models.CharField(max_length=200)),
                ('line4', models.CharField(max_length=200)),
                ('line5', models.CharField(max_length=200)),
                ('line6', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Match',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('uprn', models.CharField(max_length=20)),
                ('confidence', models.FloatField()),
                ('date', models.DateField()),
                ('test_address', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='match.Address')),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('matches', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='match.Match')),
            ],
        ),
    ]