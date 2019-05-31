init:
	# FIXME: MacOS bug - https://github.com/pyenv/pyenv/issues/1219#issuecomment-428793012
	pipenv install --dev
#	pipenv run install-lambda-functions
	pipenv shell

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

# Command to run everytime you make changes to verify everything works
dev: flake lint test

# Verifications to run before sending a pull request
pr: init dev

ENV = dev
STACKNAME = $$(basename ${CURDIR})-$(ENV)-${USER}-stack
BUCKET = ${USER}-${ENV}-package-bucket
PROFILE = ${USER}
PACKAGED_TEMPLATE = .aws-sam/packaged-template.yaml
deploy:
	$(info Deploying to personal development stack)

    # Make sure we have a user-scoped credentials profile set. We don't want to be accidentally using the default profile
	@aws configure --profile ${AWS_PROFILE} list 1>/dev/null 2>/dev/null || (echo '\nMissing AWS Credentials Profile called '${AWS_PROFILE}'. Run `aws configure --profile ${AWS_PROFILE}` to create a profile called '${AWS_PROFILE}' with creds to your personal AWS Account'; exit 1)

    # Create bucket if it does not exist
	@aws --profile ${AWS_PROFILE} s3api head-bucket --bucket ${BUCKET} 2>/dev/null 1>/dev/null || aws --profile ${AWS_PROFILE} s3 mb s3://${BUCKET}

	sam build
	sam package --profile ${AWS_PROFILE} --s3-bucket $(BUCKET) --output-template-file $(PACKAGED_TEMPLATE)
	sam deploy --profile ${AWS_PROFILE} --template-file $(PACKAGED_TEMPLATE) --stack-name $(STACKNAME) --capabilities CAPABILITY_IAM

integ-test:
	# Integration tests don't need code coverage
	pipenv run pytest tests/integration --stack $(STACKNAME) --profile ${AWS_PROFILE} -s
