PY = /usr/local/bin/python3
PYTHON = ./virtualenv/bin/python
PIP = ./virtualenv/bin/pip
DJANGO_ADMIN = ./virtualenv/bin/django_admin.py

FIREFOX = /Applications/Firefox.app
GECKODRIVER = /usr/local/bin/geckodriver

TOOLS = $(FIREFOX) $(GECKODRIVER)

.PHONY: all
all: virtualenv tools

.PHONY: tools
tools: $(TOOLS)

.PHONY: clean
clean:
	rm -rf virtualenv

.PHONY: test
test: virtualenv
	$(PYTHON) manage.py test
	$(PYTHON) functional_tests.py

.PHONY: run
run:
	$(PYTHON) manage.py runserver

virtualenv:
	$(PY) -mvenv $@
	$(PIP) install "django<1.12" "selenium<4"

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver

superlists: virtualenv
	$(DJANGO_ADMIN) startproject superlists .

lists: superlists
	$(DJANGO_ADMIN) startapp lists