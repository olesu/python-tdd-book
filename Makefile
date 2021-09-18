PY = /usr/local/bin/python3

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
	source ./virtualenv/bin/activate && python functional_tests.py

.PHONY: run
run:
	source ./virtualenv/bin/activate && python manage.py runserver

virtualenv:
	$(PY) -mvenv $@
	source ./virtualenv/bin/activate && pip install "django<1.12" "selenium<4"

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver

superlists: virtualenv
	source ./virtualenv/bin/activate && django-admin.py startproject superlists .