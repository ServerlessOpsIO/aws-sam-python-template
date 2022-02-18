build-CommonLayer:
	python{{ cookiecutter.python_version  }} ./setup.py build
	pip{{ cookiecutter.python_version   }} wheel -w tmp -e .
	mkdir $(ARTIFACTS_DIR)/python
	pip{{ cookiecutter.python_version   }} install tmp/common-* --target $(ARTIFACTS_DIR)/python/

