NAME := ./src/
TEST := ./tests/
INSTALL_STAMP := .install.stamp
POETRY := $(shell command -v poetry 2> /dev/null)

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo ""
	@echo "  install     install packages and prepare environment"
	@echo "  clean       remove all temporary files"
	@echo "  lint        run the code linters"
	@echo "  format      reformat code"
	@echo "  test        run all the tests"
	@echo ""
	@echo "Check the Makefile to know exactly what each target is doing."

install: $(INSTALL_STAMP)
$(INSTALL_STAMP): pyproject.toml poetry.lock
	@if [ -z $(POETRY) ]; then echo "$(POETRY) Poetry could not be found. See https://python-poetry.org/docs/"; exit 2; fi;
	$(POETRY) install
	touch $(INSTALL_STAMP)

.PHONY: clean
clean:
	find -type d -name "__pychache__" | xargs rm -rf {};
	rm -rf $(INSTALL_STAMP) .coverage .mypy_cache

.PHONY: lint
lint:
	$(POETRY) run isort --profile=black --lines-after-imports=2 --check-only $(TEST) $(NAME) 
	$(POETRY) run black --check $(TEST) $(NAME) --diff

.PHONY: format
format: $(INSTALL_STAMP)
	$(POETRY) run isort --profile=black --lines-after-imports=2 $(TEST) $(NAME)
	$(POETRY) run black $(TEST) $(NAME)

.PHONY: test
test: $(INSTALL_STAMP)
	$(POETRY) run pytest $(TEST) --cov-report term-missing --cov-fail-under 100 --cov $(NAME)