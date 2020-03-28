init:
	pipenv --python {{cookiecutter.python_version}}
	pipenv install --dev

# Command to run everytime you make changes to verify everything works
dev: flake lint test

# Verifications to run before sending a pull request
pr: init dev

ENV ?= ${USER}
STACKNAME = $(shell basename ${CURDIR})-$(ENV)
AWS_REGION ?= $(shell aws configure get region)

check_profile:
	# Make sure we have a user-scoped credentials profile set. We don't want to be accidentally using the default profile
	@aws configure --profile ${AWS_PROFILE} list 1>/dev/null 2>/dev/null || (echo '\nMissing AWS Credentials Profile called '${AWS_PROFILE}'. Run `aws configure --profile ${AWS_PROFILE}` to create a profile called '${AWS_PROFILE}' with creds to your personal AWS Account'; exit 1)

build:
	$(info Building application)
	sam build

deploy: build
	$(info Deploying to personal development stack)
	sam deploy --stack-name $(STACKNAME) --parameter-overrides Environment=$(ENV) --region ${AWS_REGION}

describe:
	$(info Describing stack)
	@aws cloudformation describe-stacks --stack-name $(STACKNAME) --output table --query 'Stacks[0]'

outputs:
	$(info Displaying stack outputs)
	@aws cloudformation describe-stacks --stack-name $(STACKNAME) --output table --query 'Stacks[0].Outputs'

parameters:
	$(info Displaying stack parameters)
	@aws cloudformation describe-stacks --stack-name $(STACKNAME) --output table --query 'Stacks[0].Parameters'

delete:
	$(info Delete stack)
	@aws cloudformation delete-stack --stack-name $(STACKNAME)

integ-test:
	# Integration tests don't need code coverage
	pipenv run pytest tests/integration --stack $(STACKNAME) --profile ${AWS_PROFILE} -s

test:
	# Run unit tests
	# Fail if coverage falls below 95%
	pipenv run test

flake:
	# Make sure code conforms to PEP8 standards
	pipenv run flake8 src
	pipenv run flake8 tests/unit tests/integration

lint:
	# Linter performs static analysis to catch latent bugs
	pipenv run lint --rcfile .pylintrc src


