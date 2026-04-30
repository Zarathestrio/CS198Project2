# Database LLM Interface (Natural Language to SQL)

This project implements an end-to-end system that allows users to query a relational database using natural language. By leveraging a lightweight local large language model (LLM), the program translates user questions into SQL queries, executes them on a remote PostgreSQL database via an SSH tunnel, and returns formatted results interactively.

## Overview

The system bridges natural language input and structured database querying by combining prompt engineering, local LLM inference, and secure remote execution. It is designed to work with the database schema developed in Project 1 and emphasizes transparency, reproducibility, and responsible AI usage.

## Key Features

* **Natural Language to SQL Translation**
  Converts user questions into valid SQL `SELECT` queries using a local LLM (≤4B parameters).

* **Local LLM Integration**
  Runs efficient instruction-tuned models (e.g., Phi-4-mini or Qwen2.5-3B) using libraries such as `llama_cpp_python`.

* **Prompt Engineering Pipeline**
  Dynamically constructs prompts using:

  * User query
  * Database schema (subset SQL file)
  * Instruction templates

* **Response Parsing & Validation**
  Extracts clean SQL queries from LLM output through iterative text processing.

* **Secure Remote Query Execution**
  Uses an SSH tunnel (via `paramiko`) to execute SQL queries on the ILAB PostgreSQL server. Passwords are handled securely using `getpass`.

* **Interactive CLI Loop**
  Continuous query interface that runs until the user enters `"exit"`.

* **Formatted Output Display**
  Query results are printed in readable table format (optionally using `pandas`).

## System Architecture

```
User Input (Natural Language)
        ↓
Prompt Construction (Schema + Instructions)
        ↓
Local LLM
        ↓
Text Processing → SQL Query Extraction
        ↓
SSH Tunnel (Secure Execution)
        ↓
ILAB Python Script → PostgreSQL Database
        ↓
Formatted Results واپس to User
```

## Project Structure

* `database_llm.py` — Main local script handling LLM interaction and user loop
* `ilab_script.py` — Remote script for executing SQL queries
* `schema.sql` — Full database schema (Project 1)
* `llm_schema_subset.sql` — Reduced schema used in prompt context
* `README.md` — Project documentation
* `transcripts/` — Required LLM interaction logs

## Extra Credit (Optional Frontend)

* Web-based UI for submitting queries
* Interactive, sortable tables for results
* Display panels for:

  * User query
  * Generated SQL
  * LLM raw output
  * Query results

## Requirements

* Python 3.x
* `llama_cpp_python` or equivalent LLM runtime
* `paramiko` (SSH connection)
* `pandas` (optional, for formatting)
* Access to ILAB PostgreSQL server

## Usage

1. Run the local script:

   ```
   python database_llm.py
   ```
2. Enter natural language queries
3. View generated SQL and results
4. Type `"exit"` to quit

## Notes

* The system is evaluated on its ability to correctly answer database queries via natural language.
* Prompt quality significantly impacts performance; iterative tuning is encouraged.
* All LLM usage must be documented with full transcripts.

## Academic Integrity

All external code and AI assistance must be properly cited. Failure to include transcripts or attribution may result in penalties in accordance with academic integrity policies.

## Deliverables

* Fully functional scripts (local + ILAB)
* SQL schema files
* Demonstration video
* README with team contributions and reflections
* Complete LLM chat transcripts

---

This project demonstrates how modern language models can be integrated with traditional database systems to create intuitive, user-friendly data access tools.
