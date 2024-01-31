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

https://github.com/leondz/garak
https://garak.ai/
https://docs.garak.ai/garak/
https://reference.garak.ai/en/latest/

https://newsletter.threatprompt.com/p/tp22-uncovering-model-weaknesses
https://balavenkatesh.medium.com/securing-tomorrows-ai-world-today-llama-guard-defensive-strategies-for-llm-application-c29a87ba607f

https://www.techrxiv.org/doi/full/10.36227/techrxiv.170629758.87975697/v1

https://twitter.com/AvidMldb

https://www.amazon.com/Practicing-Trustworthy-Machine-Learning-Transparent/dp/1098120272


https://www.gov.uk/government/news/tech-entrepreneur-ian-hogarth-to-lead-uks-ai-foundation-model-taskforce
https://www.gov.uk/government/news/initial-100-million-for-expert-taskforce-to-help-uk-build-and-adopt-next-generation-of-safe-ai

https://static.scale.com/uploads/6019a18f03a4ae003acb1113/test-and-evaluation.pdf

https://www.vijil.ai/

https://www.kaggle.com/competitions/ai-village-capture-the-flag-defcon31/overview