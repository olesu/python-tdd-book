PY = /usr/local/bin/python3
VENV = virtualenv
PYTHON = ./$(VENV)/bin/python
PIP = ./$(VENV)/bin/pip
DJANGO_ADMIN = ./$(VENV)/bin/django_admin.py

FIREFOX = /Applications/Firefox.app
GECKODRIVER = /usr/local/bin/geckodriver

TOOLS = $(FIREFOX) $(GECKODRIVER)

.PHONY: all
all: $(VENV) tools

.PHONY: tools
tools: $(TOOLS)

.PHONY: clean
clean:
	rm -rf ./$(VENV)
	rm db.sqlite3

.PHONY: unit-test
unit-test:
	$(PYTHON) manage.py test lists

.PHONY: functional-test
functional-test:
	$(PYTHON) manage.py test functional_tests

.PHONY: test
test: $(VENV) unit-test functional-test

.PHONY: run
run:
	$(PYTHON) manage.py runserver

.PHONY: watch
watch: $(VENV)
	source ./$(VENV)/bin/activate; ptw --runner "make unit-test" --onfail "terminal-notifier -message 'tests failed'"

.PHONY: migrations
migrations: $(VENV)
	$(PYTHON) manage.py makemigrations

.PHONY: migrate
migrate: $(VENV)
	$(PYTHON) manage.py migrate

.PHONY: collectstatic
collectstatic: $(VENV)
	$(PYTHON) manage.py $@

$(VENV):
	$(PY) -mvenv $@
	$(PIP) install "django<1.12" "selenium<4"
	$(PIP) install "pytest-watch"

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver

superlists: $(VENV)
	$(DJANGO_ADMIN) startproject superlists .

lists: superlists
	$(DJANGO_ADMIN) startapp lists
