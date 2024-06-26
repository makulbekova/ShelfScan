# Generated by Django 5.0.4 on 2024-04-07 13:37

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='product',
            name='category',
        ),
        migrations.RemoveField(
            model_name='product',
            name='sub_category',
        ),
        migrations.RemoveField(
            model_name='product',
            name='description',
        ),
        migrations.RemoveField(
            model_name='product',
            name='scan',
        ),
        migrations.RemoveField(
            model_name='scan',
            name='remark',
        ),
        migrations.AddField(
            model_name='product',
            name='sku',
            field=models.CharField(default=1, max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='scan',
            name='product',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.RESTRICT, to='api.product'),
            preserve_default=False,
        ),
        migrations.CreateModel(
            name='Remark',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('remark', models.TextField()),
                ('scan', models.ForeignKey(on_delete=django.db.models.deletion.RESTRICT, to='api.scan')),
            ],
        ),
        migrations.DeleteModel(
            name='Category',
        ),
        migrations.DeleteModel(
            name='SubCategory',
        ),
    ]
