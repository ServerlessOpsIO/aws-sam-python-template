#!/usr/bin/env python

import io
import re
import os
from setuptools import setup, find_packages

setup(
    name='common',
    version='0.0.1',
    description='{{cookiecutter.service_name}} Service Common Code',
    author='{{cookiecutter.author_name}}',
    author_email='{{cookiecutter.author_email}}',
    license='Apache License 2.0',
    packages=find_packages(exclude=['tests.*', 'tests']),
    keywords="{{cookiecutter.service_name}} Service",
    python_requires='>={{cookiecutter.python_version}}.*',
    include_package_data=True,
    install_requires=[
        'aws_lambda_powertools',
        'boto3'
    ],
    classifiers=[
        'Environment :: Console',
        'Environment :: Other Environment',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: {{cookiecutter.python_version}}',
    ]
)

