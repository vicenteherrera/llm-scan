
FROM python:3.11.6

ARG YOUR_ENV
ARG YOUR_HOME

ENV YOUR_ENV=${YOUR_ENV} \
  YOUR_HOME=${YOUR_HOME} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.8.3

# System deps:
RUN pip install "poetry==$POETRY_VERSION"

# Copy only requirements to cache them in docker layer
WORKDIR /code
COPY poetry.lock pyproject.toml /code/

# Project initialization:
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

# Creating folders, and files for a project:
COPY ./src /code/src


# Copy existing huggingface cache of models and datasets

ENV HF_HOME="/code/.cache/huggingface/"
COPY --from=huggingface ./ /code/.cache/huggingface/
