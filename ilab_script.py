#!/usr/bin/env python3

import sys
import os
import psycopg2
import pandas as pd
import getpass


def get_query():
    if len(sys.argv) > 1:
        return sys.argv[1]
    else:
        return sys.stdin.read().strip()


def validate_query(query):
    if not query.lower().strip().startswith("select"):
        raise ValueError("Only SELECT queries are allowed.")


def run_query(query):
    host = os.environ.get("PGHOST") or input("Postgres host (e.g. postgres.cs.rutgers.edu): ").strip()
    dbname = os.environ.get("PGDATABASE") or input("Postgres dbname: ").strip()
    user = os.environ.get("PGUSER") or input("Postgres user: ").strip()
    password = os.environ.get("PGPASSWORD") or getpass.getpass("Postgres password: ")

    conn = psycopg2.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host,
        port="5432"
    )

    df = pd.read_sql_query(query, conn)
    conn.close()
    return df


def main():
    try:
        query = get_query()
        validate_query(query)

        df = run_query(query)

        if df.empty:
            print("No results found.")
        else:
            print(df.to_string(index=False))

    except Exception as e:
        print(f"ERROR: {str(e)}")


if __name__ == "__main__":
    main()