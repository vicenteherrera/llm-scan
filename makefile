
all: install run size

setup: install_libraries requirements install_python install validate_python_libs

code:
	poetry run code .

# run -------------------------------

run:
	poetry run ./src/run.sh ${TYPE} ${MODEL} | tee logs/$(subst /,_,$(MODEL)).log

run-llama2: TYPE="huggingface"
run-llama2: MODEL="meta-llama/Llama-2-7b-chat-hf"
run-llama2: run

run-mistral: TYPE="huggingface"
run-mistral: MODEL="mistralai/Mixtral-8x7B-Instruct-v0.1"
run-mistral: run

run-gpt2: TYPE="huggingface"
run-gpt2: MODEL="gpt2"
run-gpt2: run

run-gpt2-hallucination: TYPE="huggingface"
run-gpt2-hallucination: MODEL="gpt2"
run-gpt2-hallucination: PROBES="packagehallucination"
run-gpt2-hallucination: run

run-gpt2-encoding: TYPE="huggingface"
run-gpt2-encoding: MODEL="gpt2"
run-gpt2-encoding: PROBES="encoding"
run-gpt2-encoding: run

run-openapi-gpt-3.5-turbo: TYPE="openai"
run-openapi-gpt-3.5-turbo: MODEL="gpt-3.5-turbo"
run-openapi-gpt-3.5-turbo: run

run-openapi-gpt-4: TYPE="openai"
run-openapi-gpt-4: MODEL="gpt-4"
run-openapi-gpt-4: run

#	poetry run ./src/run-openapi-gpt-3.5-turbo.sh | tee logs/run-openapi-gpt-3.5-turbo.log
#	poetry run ./src/run-openapi-gpt-4.sh | tee logs/run-openapi-gpt-4.log

# Dependency utils -------------------------------

install_python:
	pyenv install $$(cat .python-version) -s

requirements:
	which pyenv
	which poetry

validate_python_libs:
	poetry run python3 -c "import tkinter"
	poetry run python3 -c "import bz2"
	poetry run python3 -c "import lzma"
	poetry run python3 -c "import tkinter"

install_libraries:
	sudo apt-get install liblzma-dev libbz2-dev tk-dev python3-tk libreadline-dev -y

delete_all: delete
	rm -r $$HOME/.cache/huggingface/
	rm -r run/*
	rm *.log

# Python libraries ----------------------------------------

update:
	poetry update

install:
	poetry install --no-root

show:
	poetry show

info:
	poetry run poetry env info -p

delete:
	poetry env remove python

size:
	@echo "Size of Python virtual environment"
	@du -sh $$(poetry run poetry env info --path 2>/dev/null)
	@echo "Size of Huggingface model directory"
	@du -sh $$HOME/.cache/huggingface/

# Container targets ------------------------------------------

CONTAINER_IMAGE=quay.io/vicenteherrera/llm-scan

# Check if sudo is required to run Docker
RUNSUDO := $(shell groups | grep ' docker ' 1>/dev/null || echo "sudo")

# https://docs.docker.com/engine/install/debian/#install-using-the-repository

.PHONY: container-build
# build the container image
container-build:
	@echo "Building container image"
	@${RUNSUDO} docker buildx build . -f containerfile -t ${CONTAINER_IMAGE} --build-arg YOUR_HOME="$$HOME" --build-context huggingface="$$HOME/.cache/huggingface"

container-run:
	@${RUNSUDO} docker run -i -t ${CONTAINER_IMAGE} poetry run python ./starter_ml/hugging-face.py