.PHONY: tools

FIREFOX = /Applications/Firefox.app
GECKODRIVER = /usr/local/bin/geckodriver

TOOLS = $(FIREFOX) $(GECKODRIVER)

$(FIREFOX):
	brew install --cask firefox

$(GECKODRIVER):
	brew install geckodriver
	
tools: $(TOOLS)