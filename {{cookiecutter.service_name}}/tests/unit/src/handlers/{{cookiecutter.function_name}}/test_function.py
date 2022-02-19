# pylint: disable=redefined-outer-name
# pylint: disable=protected-access
'''Test {{cookiecutter.function_name}}'''

import json
import os
import pytest

from common.test.aws import create_lambda_function_context
#from aws_lambda_powertools.utilities.data_classes import <AWS_EVENT>

# NOTE: Don't break all of pytest because of a single problem function
try:
    import src.handlers.{{cookiecutter.function_name}}.function as func
except:
    pytestmark = pytest.mark.skip

FUNCTION_NAME = '{{cookiecutter.function_name}}'

DATA_DIR = './data'
FUNC_DATA_DIR = os.path.join(DATA_DIR, FUNCTION_NAME)
DATA = os.path.join(FUNC_DATA_DIR, 'data.json')
DATA_SCHEMA = os.path.join(FUNC_DATA_DIR, 'data.schema.json')
EVENT = os.path.join(FUNC_DATA_DIR, 'event.json')
EVENT_SCHEMA = os.path.join(FUNC_DATA_DIR, 'event.schema.json')
OUTPUT = os.path.join(FUNC_DATA_DIR, 'output.json')
OUTPUT_SCHEMA = os.path.join(FUNC_DATA_DIR, 'output.schema.json')


### Fixtures
@pytest.fixture()
def context(function_name=FUNCTION_NAME):
    '''context object'''
    return create_lambda_function_context(function_name)

@pytest.fixture()
def data(data=DATA):
    '''Return function event data'''
    with open(data) as f:
        return json.load(f)

@pytest.fixture()
def data_schema(data_schema=DATA_SCHEMA):
    '''Return a data schema'''
    with open(data_schema) as f:
        return json.load(f)

@pytest.fixture()
def event(e=EVENT):
    '''Return a function event'''
    with open(e) as f:
        return json.load(f)

@pytest.fixture()
def event_schema(schema=EVENT_SCHEMA):
    '''Return an event schema'''
    with open(schema) as f:
        return json.load(f)

@pytest.fixture()
def expected_output(output=OUTPUT):
    '''Return a function output'''
    with open(output) as f:
        return json.load(f)

@pytest.fixture()
def expected_output_schema(output_schema=OUTPUT_SCHEMA):
    '''Return an output schema'''
    with open(output_schema) as f:
        return json.load(f)


### Tests
def test_handler(event, context, expected_output, mocker):
    '''Call handler'''
    response = func.handler(event, context)

    assert response == expected_output
