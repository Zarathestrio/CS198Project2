# Project 2 — Local LLM + schema prompting (what I did + how to run it)

what I did + whats left

## what I did

I implemented the **local “prompt construction + model inference” part** so far, aka: the part that turns *(schema + question + rules)* into **model-generated SQL text** on your end.

I also updated ilab_script.py from the original stub with PLACEHOLDER connection settings to a runnable iLab version: it prompts for Postgres host/db/user (or reads PGHOST/PGDATABASE/PGUSER), uses getpass for the password, validates SELECT-only queries, and prints results as a table. I verified it against our populated database with SELECT COUNT(*) FROM lar_record;.

this is what the pipeline looks like as of now:

1. Read `llm_schema_subset.sql` (table/column definitions + a few example rows).
2. Read `prompt_template.txt` and substitute:
   - `{{SCHEMA_SQL}}` → the full schema file contents
   - `{{USER_QUESTION}}` → the user’s natural-language question
3. Load a local GGUF model via `llama-cpp-python` and run the combined prompt.
4. Print the model’s **raw output** to the terminal (ideally a single `SELECT`).

What this **does not** do yet (intentionally): it does **not** connect to Postgres, does **not** SSH to iLab, and does **not** execute the SQL—those steps come later in `database_llm.py`.

Files involved:

- **`llm_schema_subset.sql`**: schema text for the LLM (DDL + a few tiny example `INSERT`s). This is meant to be **embedded in prompts**, not used as the full Project 1 database build pipeline.
- **`prompt_template.txt`**: prompt skeleton with placeholders:
  - `{{SCHEMA_SQL}}` → contents of `llm_schema_subset.sql`
  - `{{USER_QUESTION}}` → the user’s natural language question
- **`generate_sql_from_question.py`**: a small **helper script** that performs steps (1)–(4): load files → build prompt → call the model → print output.
- **`requirements-local.txt`**: laptop dependency pin for `llama-cpp-python` (the model weights file is downloaded separately).

### Model I used

- **GGUF file**: `qwen2.5-3b-instruct-q4_k_m.gguf` (**Qwen2.5 3B Instruct**, **Q4_K_M** quant)

## How to run the local helper (`generate_sql_from_question.py`)

Note: `database_llm.py` is the **final integrated program name** for the assignment, but it is **not the smoke test**.
Right now, use `generate_sql_from_question.py` to validate local inference + prompting.

### Prereqs

- Python 3
- The GGUF file on disk
- Network for installing Python packages / downloading the model (model download is not done via `pip`)

### Setup (macOS/Linux)

From the project root:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements-local.txt
```

### Configure model path + context

Set the absolute path to your GGUF:

```bash
export LLM_MODEL="/absolute/path/to/qwen2.5-3b-instruct-q4_k_m.gguf"
```

If you hit context-size errors (prompt too large), increase context **only if your machine has RAM**:

```bash
export LLM_N_CTX=8192
```

Notes:

- A log line like `n_ctx_seq (8192) < n_ctx_train (32768)` is **informational**: you allocated a smaller context than the model’s theoretical max.

### Run

```bash
python3 generate_sql_from_question.py "How many mortgages have loan_amount_000s greater than applicant_income_000s?"
```

Expected:

- The program prints **raw LLM text**, ideally a single `SELECT` statement.

## What still needs to be done (remaining Project 2 work)

This is the remaining work to reach the full “interactive NL → SQL → execute on iLab → show table” product:

### 1) SQL extraction + safety checks

Treat the LLM output as **untrusted text** and implement parsing like:

- `extract_select(raw_llm_text) -> str` returning **exactly one** `SELECT`
- reject non-`SELECT`, multiple statements, etc.
- handle occasional markdown fences / extra prose

### 2) Final integrated program: `database_llm.py`

`database_llm.py` should:

- loop reading questions until the user types exactly `exit`
- build the prompt using `prompt_template.txt` + `llm_schema_subset.sql`
- call the local LLM
- SSH to iLab using `paramiko` and prompt for SSH password with `getpass` (**not visible**)
- remotely execute `ilab_script.py` with the extracted `SELECT`
- print results (for demos, it helps to also show the question / extracted SQL / raw LLM output)

### 3) iLab runner: `ilab_script.py`

Ensure `ilab_script.py` is deployed on iLab and can execute arbitrary `SELECT` queries passed in as argv (per spec).

### 4) Submission requirements (everyone)

- short demo video
- README writeup + citations
- **full transcripts** of any LLM chats used (course requirement)