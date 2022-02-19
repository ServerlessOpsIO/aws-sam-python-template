'''
Resources for testing in AWS.
'''
from collections import namedtuple
from typing import Any, Dict, List, Tuple, Union

import boto3

def create_lambda_function_context(function_name: str, object_name: str = 'LambdaContext') -> Tuple:
    '''Return a named tuple representing a context object'''
    context_info = {
        'aws_request_id': '00000000-0000-0000-0000-000000000000',
        'function_name': function_name,
        'invoked_function_arn': 'arn:aws:lambda:us-east-1:012345678910:function:{}'.format(function_name),
        'memory_limit_in_mb': 128
    }

    Context = namedtuple(object_name, context_info.keys())
    return Context(*context_info.values())