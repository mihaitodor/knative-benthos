#!/usr/bin/env bash

psql postgresql://postgres:password@localhost:5432/postgres -c 'CREATE TABLE SOURCE(ID SERIAL, TEXT VARCHAR)'
psql postgresql://postgres:password@localhost:5432/postgres -c 'CREATE TABLE SINK(COMPOUND DOUBLE PRECISION, NEGATIVE DOUBLE PRECISION, NEUTRAL DOUBLE PRECISION, POSITIVE DOUBLE PRECISION)'
# Populate SOURCE table
benthos -c ./benthos/benthos_populate_db.yaml
