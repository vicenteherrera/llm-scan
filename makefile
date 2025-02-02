
all: install run size

setup: install_libraries requirements install_python install validate_python_libs

code:
	poetry run code .

# run -------------------------------

run: run-mistral

run-garak:
	poetry run ./src/run.sh ${TYPE} ${MODEL} "${PROBES}" | tee logs/$(subst /,_,$(MODEL)).log

run-llama2: TYPE="huggingface"
run-llama2: MODEL="meta-llama/Llama-2-7b-chat-hf"
run-llama2: run-garak

run-mistral: TYPE="huggingface"
run-mistral: MODEL="mistralai/Mixtral-8x7B-Instruct-v0.1"
run-mistral: run-garak

run-gpt2: TYPE="huggingface"
run-gpt2: MODEL="gpt2"
run-gpt2: run-garak

run-gpt2-profanity: TYPE="huggingface"
run-gpt2-profanity: MODEL="gpt2"
run-gpt2-profanity: PROBES="lmrc.Profanity"
run-gpt2-profanity: run-garak

run-gpt2-encoding: TYPE="huggingface"
run-gpt2-encoding: MODEL="gpt2"
run-gpt2-encoding: PROBES="encoding"
run-gpt2-encoding: run-garak

run-openapi-gpt-3.5-turbo: TYPE="openai"
run-openapi-gpt-3.5-turbo: MODEL="gpt-3.5-turbo"
run-openapi-gpt-3.5-turbo: run-garak

run-openapi-gpt-4: TYPE="openai"
run-openapi-gpt-4: MODEL="gpt-4"
run-openapi-gpt-4: run-garak

# o3-mini-2025-01-31

# o1-2024-12-17
# o1-mini-2024-09-12
# o1-preview-2024-09-12

# gpt-4o-2024-11-20
# gpt-4o-2024-08-06
# gpt-4o-2024-05-13

# gpt-4o-mini-2024-07-18

# gpt-4-turbo-2024-04-09
# gpt-4-0125-preview
# gpt-4-1106-preview
# gpt-4-0613

# gpt-3.5-turbo-instruct
# gpt-3.5-turbo-1106
# gpt-3.5-turbo-0125

# Dependency utils -------------------------------

install_python: upgrade_pyenv
	pyenv install $$(cat .python-version) -s

requirements:
	which pyenv
	which poetry

config_exists:
	@[ ! -z "${CONFIG_FILE}" ] || ( echo "Error: Config file env.txt not found" && exit 1 )
	@echo "Config file found at ${CONFIG_FILE}"

validate_python_libs:
	poetry run python3 -c "import tkinter"
	poetry run python3 -c "import bz2"
	poetry run python3 -c "import lzma"
	poetry run python3 -c "import tkinter"

install_libraries:
	sudo apt-get install liblzma-dev libbz2-dev tk-dev python3-tk libreadline-dev -y

delete_all: delete
	rm -r run/*
	rm *.log

upgrade_pyenv:
	cd $$HOME/.pyenv && git pull

required_python:
	@PVPOETRY="$$(poetry run python --version)" && \
	PVPOETRY=$${PVPOETRY#"Python "} && \
	PV="$$(cat .python-version)" && \
	if [ "$$PVPOETRY" != "$$PV" ]; then \
		echo "**Error, Python version mismatch" && \
		echo ".python-version file: $$PV" && \
		echo "poetry run python --version: $$PVPOETRY" && \
		echo "Run make refresh and check your pyenv path configuration" && \
		exit 1; \
	fi

refresh: delete_venv
	pyenv uninstall -f $$(cat .python-version)
	pyenv install $$(cat .python-version)
	rm poetry.lock
	poetry install --no-root

# Python libraries ----------------------------------------

update:
	poetry update

install:
	poetry install --no-root

show:
	poetry show

info:
	poetry run poetry env info -p

delete: delete_venv delete_huggingface_home

delete_venv:
	poetry env remove --all ||:

delete_huggingface_home:
	rm -r $$HOME/.cache/huggingface/ ||:

delete_huggingface_local:
	rm -r ./.cache/huggingface/ ||:

size:
	@echo "Size of libraries"
	@du -sh $$(poetry env info --path 2>/dev/null)
	@echo "Size of models"
	@du -sh $$HOME/.cache/huggingface/ ||:
	@echo "Size of devpi cache"
	@du -sh $$HOME/.devpi/server ||:

# Container targets ------------------------------------------

CONTAINER_IMAGE=quay.io/vicenteherrera/llm-scan

# Check if sudo is required to run Docker
RUNSUDO := $(shell groups | grep ' docker \|com\.apple' 1>/dev/null || echo "sudo")

# https://docs.docker.com/engine/install/debian/#install-using-the-repository

.PHONY: container-build
# build the container image
container-build:
	@echo "Building container image"
	@${RUNSUDO} docker buildx build . -f containerfile -t ${CONTAINER_IMAGE} --build-arg YOUR_HOME="$$HOME" --build-context huggingface="$$HOME/.cache/huggingface"

container-run:
	@${RUNSUDO} docker run -i -t ${CONTAINER_IMAGE} make run