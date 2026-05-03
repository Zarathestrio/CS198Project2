#!/usr/bin/env python3
"""
Final integrated program placeholder.

The course submission expects `database_llm.py` to be the full interactive pipeline:
  NL question -> local LLM -> extract SELECT -> SSH to iLab -> run `ilab_script.py` -> print results

That integration is not implemented in this file yet. Use `generate_sql_from_question.py` to validate
the local model + prompt + schema subset.
"""

from __future__ import annotations

import sys


def main() -> int:
    print(
        "database_llm.py is not implemented yet.\n"
        "For now, run: python3 generate_sql_from_question.py \"<your question>\"\n"
        "(requires LLM_MODEL pointing at your .gguf file)",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
