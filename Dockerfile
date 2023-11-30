FROM python:3.11 as python-base

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.5.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Create stage for Poetry installation
FROM python-base as poetry-base

# TODO: test for snappy (not working. Will remove later.)
# RUN apt-get update && apt-get install libsnappy-dev libtool automake autoconf -y

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Create a new stage from the base python image
FROM python-base as main_image



# Copy Poetry to app image
COPY --from=poetry-base ${POETRY_VENV} ${POETRY_VENV}

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

# Allow statements and log messages to immediately appear in the logs
ENV PYTHONUNBUFFERED True

ENV APP_HOME /root
WORKDIR $APP_HOME

# Copy Dependencies
COPY poetry.lock pyproject.toml ./

# [OPTIONAL] Validate the project is properly configured
RUN poetry check

# Install Dependencies
RUN poetry install --no-root --no-dev

COPY /app $APP_HOME/app
COPY /models/llama-2-7b-chat.Q5_K_M.gguf $APP_HOME/models/llama-2-7b-chat.Q5_K_M.gguf

ENV PORT 8080

CMD exec poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port ${PORT} --workers 1 --proxy-headers --forwarded-allow-ips '*'