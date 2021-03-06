SHELL = /usr/bin/env bash

.DEFAULT_GOAL := help
.PHONY: help
.PHONY: clean clean-build clean-pyc clean-test
.PHONY: lint test test-all test-coverage test-coverage-report-console test-coverage-report-html
.PHONY: docs dist upload-release

help:
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

clean: clean-build clean-pyc clean-test ## remove all build, test, lint, coverage and Python artifacts

clean-build: ## remove build artifacts (dist, docs, etc)
	rm -rf .eggs/
	rm -rf build/
	rm -rf docs/_build/
	rm -f docs/fd_dj_accounts.rst
	rm -f docs/modules.rst
	rm -rf dist/
	find . -name '*.egg-info' -exec rm -rf {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -rf {} +

clean-test: ## remove test, lint and coverage artifacts
	rm -rf .cache/
	rm -rf .tox/
	rm -f .coverage
	rm -rf htmlcov/
	rm -rf test-reports/
	rm -rf .mypy_cache/

lint: ## run tools for code style analysis, static type check, etc
	flake8  --config=setup.cfg  fd_dj_accounts  tests
	mypy  --config-file setup.cfg  fd_dj_accounts

test: ## run tests quickly with the default Python
	python runtests.py tests

test-all: ## run tests on every Python version with tox
	tox

test-coverage: ## run tests and record test coverage
	coverage run --rcfile=setup.cfg runtests.py tests

test-coverage-report-console: ## print test coverage summary
	coverage report --rcfile=setup.cfg -m

test-coverage-report-html: ## generate test coverage HTML report
	coverage html --rcfile=setup.cfg

docs: ## generate Sphinx HTML documentation, including API docs
	rm -f docs/fd_dj_accounts.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ fd_dj_accounts
	$(MAKE) -C docs clean
	$(MAKE) -C docs html

dist: clean ## builds source and wheel package
	python setup.py sdist
	python setup.py bdist_wheel
	twine check dist/*
	ls -l dist

upload-release: ## upload dist packages
	python -m twine upload 'dist/*'
