#!/usr/bin/env python3
"""
Local helper script using llama-cpp-python (GGUF models).

Example:
  export LLM_MODEL=/path/to/model.gguf
  python3 generate_sql_from_question.py "How many rows are in lar_record?"

This file is intentionally standalone for early testing (before SSH/iLab wiring).
"""

from __future__ import annotations

import argparse
import os
import sys


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("question", nargs="?", default="How many rows are in lar_record?")
    parser.add_argument(
        "--model",
        default=os.environ.get("LLM_MODEL", ""),
        help="Path to a GGUF model file (or set env var LLM_MODEL).",
    )
    parser.add_argument(
        "--schema-file",
        default=os.path.join(os.path.dirname(__file__), "llm_schema_subset.sql"),
        help="Path to llm_schema_subset.sql",
    )
    parser.add_argument(
        "--prompt-template",
        default=os.path.join(os.path.dirname(__file__), "prompt_template.txt"),
        help="Path to prompt_template.txt",
    )
    parser.add_argument(
        "--n-ctx",
        type=int,
        default=int(os.environ.get("LLM_N_CTX", "8192")),
        help="Context size passed to llama.cpp (or set env var LLM_N_CTX).",
    )
    parser.add_argument("--max-tokens", type=int, default=200)
    args = parser.parse_args()

    if not args.model:
        print("ERROR: missing --model / LLM_MODEL", file=sys.stderr)
        return 2

    try:
        from llama_cpp import Llama  # type: ignore
    except Exception as e:
        print("ERROR: llama_cpp_python is not installed in this environment.", file=sys.stderr)
        print(str(e), file=sys.stderr)
        return 2

    schema_sql = open(args.schema_file, "r", encoding="utf-8").read()
    template = open(args.prompt_template, "r", encoding="utf-8").read()
    prompt = template.replace("{{SCHEMA_SQL}}", schema_sql).replace(
        "{{USER_QUESTION}}", args.question
    )

    llm = Llama(model_path=args.model, n_ctx=args.n_ctx, verbose=False)
    out = llm(prompt, max_tokens=args.max_tokens, stop=["```"])
    text = out["choices"][0]["text"]
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
