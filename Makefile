.PHONY: all tools

PYTHON = /usr/local/bin/python3

FIREFOX = /Applications/Firefox.app
GECKODRIVER = /usr/local/bin/geckodriver

TOOLS = $(FIREFOX) $(GECKODRIVER)

all: virtualenv tools

tools: $(TOOLS)

virtualenv:
	$(PYTHON) -mvenv $@

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver
