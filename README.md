# llm-scan
Scan local or online LLMs for vulnerabilities using Garak.

## Requirements

* pyenv (for Python 3.11.6), poetry, make
* Debian: liblzma-dev, libbz2-dev, libreadline-dev
* Debian: possibly also tk-dev, python3-tk for Python installation not to complain

## Execute

```bash
# setup for the first time
make setup

# Execute vulnerability scan downloading local gpt-2 LLM model
# You need to create .env file from sample.env with Huggingface token
make run-gpt2

# Execute vulnerability scan with online gpt-4 LLM model on OpenAI
# On .env file you need to also add your OpenAI token
make run-openapi-gpt4
```

## References

* https://github.com/leondz/garak
* https://garak.ai/
* https://docs.garak.ai/garak/
* https://reference.garak.ai/en/latest/

