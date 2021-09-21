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

.PHONY: test
test: $(VENV)
	$(PYTHON) manage.py test
	$(PYTHON) functional_tests.py

.PHONY: run
run:
	$(PYTHON) manage.py runserver

$(VENV):
	$(PY) -mvenv $@
	$(PIP) install "django<1.12" "selenium<4"

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver

superlists: $(VENV)
	$(DJANGO_ADMIN) startproject superlists .

lists: superlists
	$(DJANGO_ADMIN) startapp lists