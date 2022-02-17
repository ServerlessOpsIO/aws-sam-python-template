init:
	pipenv --python {{cookiecutter.python_version}}
	pipenv install --dev

# Command to run everytime you make changes to verify everything works
dev: flake lint test

# Verifications to run before sending a pull request
pr: init dev

SAM_TEMPLATE ?= template.yaml
ENV ?= ${USER}
APPNAME ?= $(shell basename ${CURDIR})
STACKNAME = $(APPNAME)-$(ENV)
AWS_REGION ?= $(shell aws configure get region)
PIPELINE_STACKNAME = $(APPNAME)-pipeline-$(ENV)
PIPELINE_CONFIG_FILE ?= codepipeline-config-$(ENV).yaml
REPO_ID ?= ServerlessOpsIO/PhotoOps
BRANCH ?= 'master'

check_profile:
	# Make sure we have a user-scoped credentials profile set. We don't want to be accidentally using the default profile
	@aws configure --profile ${AWS_PROFILE} list 1>/dev/null 2>/dev/null || (echo '\nMissing AWS Credentials Profile called '${AWS_PROFILE}'. Run `aws configure --profile ${AWS_PROFILE}` to create a profile called '${AWS_PROFILE}' with creds to your personal AWS Account'; exit 1)

build:
	$(info Building application)
	sam build --use-container --parallel --template ${SAM_TEMPLATE}

validate:
	$(info linting SAM template)
	$(info linting CloudFormation)
	@cfn-lint template.yaml
	$(info validating SAM template)
	@sam validate

deploy: validate build
	$(info Deploying to personal development stack)
	sam deploy \
		--region ${AWS_REGION} \
		--resolve-s3 \
		--stack-name $(STACKNAME) \
		--tags \
			ServiceName=$(APPNAME) \
			ServiceEnv=$(ENV) \
			StackName=$(STACKNAME) \
		--parameter-overrides \
			ServiceName=$(APPNAME) \
			ServiceEnv=$(ENV)


# Requires usage of PipelineUser IAM user.
deploy-pipeline:
	$(info Deploying to personal development stack)
	sam deploy \
		--region ${AWS_REGION} \
		--resolve-s3 \
		--template codepipeline.yaml \
		--stack-name $(PIPELINE_STACKNAME) \
		--tags \
			ServiceName=$(APPNAME) \
			ServiceEnv=$(ENV) \
			StackName=$(PIPELINE_STACKNAME) \
			PipelineStack=true \
		--parameter-overrides \
			ServiceName=$(APPNAME) \
			FullRepositoryId=$(REPO_ID) \
			GitBranch=$(BRANCH)

generate-codepipeline-cfn-config:
	$(info generating configurations for CloudFormation deploy)
	echo '{ "Tags": {"ServiceName":"$(APPNAME)", "ServiceEnv":"$(ENV)", "StackName":"$(STACKNAME)"} }' > $(PIPELINE_CONFIG_FILE)

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
	@sam delete --stack-name $(STACKNAME)

function:
	$(info creating function: ${F})
	mkdir -p src/handlers/${F}
	touch src/handlers/${F}/__init__.py
	touch src/handlers/${F}/function.py
	mkdir -p tests/{unit,integration}/src/handlers/${F}
	touch tests/unit/src/handlers/${F}/__init__.py
	touch tests/unit/src/handlers/${F}/test_function.py
	touch tests/integration/src/handlers/${F}/__init__.py
	touch tests/integration/src/handlers/${F}/test_function.py
	echo "-e src/common/" > src/handlers/${F}/requirements.txt
	mkdir data/${F}
	echo "{}" | tee data/${F}/{event,data,output}.json
	echo "{}" | tee data/${F}/{event,data,output}.schema.json

unit-test:
	$(info running unit tests)
	# Integration tests don't need code coverage
	pipenv run pytest tests/unit

integ-test:
	$(info running integration tests)
	# Integration tests don't need code coverage
	pipenv run pytest tests/integration

test:
	$(info running tests)
	# Run unit tests
	# Fail if coverage falls below 95%
	pipenv run test

flake8:
	$(info running flake8 on code)
	# Make sure code conforms to PEP8 standards
	pipenv run flake8 src
	pipenv run flake8 tests/unit tests/integration

pylint:
	$(info running pylint on code)
	# Linter performs static analysis to catch latent bugs
	pipenv run lint --rcfile .pylintrc src

lint: pylint flake8

clean:
	$(info cleaning project)
	# remove sam cache
	rm -rf .aws-sam
