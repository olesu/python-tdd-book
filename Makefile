PY = /usr/local/bin/python3
VENV = virtualenv
PYTHON = ./$(VENV)/bin/python
PIP = ./$(VENV)/bin/pip
DJANGO_ADMIN = ./$(VENV)/bin/django_admin.py

FIREFOX = /Applications/Firefox.app
GECKODRIVER = /usr/local/bin/geckodriver

TOOLS = $(FIREFOX) $(GECKODRIVER)
TESTS ?= lists

FT_OPTS =
FAIL_FAST ?= 0
ifeq ($(FAIL_FAST), 1)
	FT_OPTS += --failfast
endif

.PHONY: all
all: $(VENV) tools

.PHONY: tools
tools: $(TOOLS)

.PHONY: clean
clean:
	rm -rf ./$(VENV)
	rm -f db.sqlite3
	find . -type f -name '*.pyc' -delete
	find . -type d -name __pycache__ -delete

.PHONY: unit-test
unit-test: $(VENV)
	$(PYTHON) manage.py test $(TESTS)

.PHONY: functional-test
functional-test: $(VENV)
	$(PYTHON) manage.py test functional_tests $(FT_OPTS)

.PHONY: test
test: unit-test functional-test

.PHONY: run
run: $(VENV)
	$(PYTHON) manage.py runserver

.PHONY: watch
watch: $(VENV)
	./$(VENV)/bin/ptw --runner "echo ./$(VENV)/bin/python3 manage.py test" --onfail "terminal-notifier -message 'tests failed'"

.PHONY: migrations
migrations: $(VENV)
	$(PYTHON) manage.py makemigrations

.PHONY: migrate
migrate: $(VENV)
	$(PYTHON) manage.py migrate

.PHONY: collectstatic
collectstatic: $(VENV)
	$(PYTHON) manage.py $@

$(VENV): requirements.txt requirements-dev.txt
	$(PY) -mvenv $@
	$(PIP) install --upgrade -r requirements.txt
	$(PIP) install --upgrade -r requirements-dev.txt
	touch $(VENV)

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver

superlists: $(VENV)
	$(DJANGO_ADMIN) startproject superlists .

lists: superlists
	$(DJANGO_ADMIN) startapp lists
