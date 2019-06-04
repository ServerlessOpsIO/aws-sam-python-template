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
    python_requires='>=3.7.*',
    include_package_data=True,
    classifiers=[
        'Environment :: Console',
        'Environment :: Other Environment',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.7',
    ]
)

