'''{{cookiecutter.function_description}}'''
import json
from dataclasses import dataclass

from aws_lambda_powertools.logging import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext

from common.util.dataclasses import lambda_dataclass_response


LOGGER = Logger(utc=True)


@dataclass
class Response:
    '''Function response'''
{% if cookiecutter.event_source == "apigateway" %}
    statusCode: int
    body: str
{% else %}
    pass
{% endif %}


@LOGGER.inject_lambda_context
@lambda_dataclass_response
def handler(event: Dict[str, Any], context: LambdaContext) -> Response:
    '''Function entry'''
    LOGGER.debug('Event', extra={"message_object": event})

{% if cookiecutter.event_source == "apigateway" %}
    response = Response(
        **{
            "statusCode": 200,
            "body": json.dumps(
                {
                    "message": "hello world",
                }
            ),
        }
    )
{% else %}
    response = Response(**{})
{% endif %}

    LOGGER.debug('Response', extra={"message_object": resp})
    return response

