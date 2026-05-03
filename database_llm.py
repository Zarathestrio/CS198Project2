#!/usr/bin/env python3

import os
import sys
import getpass
import paramiko
from llama_cpp import Llama


# ---------- CONFIG ----------
MODEL_PATH = os.environ.get("LLM_MODEL")
SCHEMA_FILE = "llm_schema_subset.sql"
PROMPT_FILE = "prompt_template.txt"

ILAB_HOST = "ilab.cs.rutgers.edu"
ILAB_USER = input("Enter your ilab username: ")
# ----------------------------


def load_prompt(question):
    schema = open(SCHEMA_FILE, "r", encoding="utf-8").read()
    template = open(PROMPT_FILE, "r", encoding="utf-8").read()

    return template.replace("{{SCHEMA_SQL}}", schema).replace(
        "{{USER_QUESTION}}", question
    )


def run_llm(prompt):
    llm = Llama(model_path=MODEL_PATH, n_ctx=8192, verbose=False)
    out = llm(prompt, max_tokens=200, stop=["```"])
    return out["choices"][0]["text"]


def extract_sql(text):
    text = text.strip()

    # remove markdown
    if "```" in text:
        parts = text.split("```")
        text = parts[1] if len(parts) > 1 else parts[0]

    # flatten
    text = " ".join(text.split())

    # enforce SELECT
    if not text.lower().startswith("select"):
        text = "SELECT " + text

    # remove trailing semicolon
    if text.endswith(";"):
        text = text[:-1]

    return text


def run_ssh(query, db_password):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    ssh.connect(ILAB_HOST, username=ILAB_USER)

    cmd = f'''
    PGHOST=postgres.cs.rutgers.edu \
    PGDATABASE=PLACEHOLDER \
    PGUSER=PLACEHOLDER \
    PGPASSWORD={db_password} \
    python3 ilab_script.py "{query}"
    '''

    stdin, stdout, stderr = ssh.exec_command(cmd)

    output = stdout.read().decode()
    error = stderr.read().decode()

    ssh.close()

    return output if output else error


def main():
    if not MODEL_PATH:
        print("ERROR: Set LLM_MODEL environment variable")
        return

    db_password = getpass.getpass("Enter Postgres password: ")

    while True:
        question = input("\nAsk a question (or type 'exit'): ")

        if question.strip() == "exit":
            break

        prompt = load_prompt(question)

        raw = run_llm(prompt)
        sql = extract_sql(raw)

        print("\n--- Generated SQL ---")
        print(sql)

        result = run_ssh(sql, db_password)

        print("\n--- Query Result ---")
        print(result)


if __name__ == "__main__":
    main()