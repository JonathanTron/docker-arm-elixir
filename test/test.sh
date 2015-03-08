#!/bin/bash
set -o pipefail

function ok()
{
	echo "$1  OK"
}

function fail()
{
	echo "$1  FAIL"
}

echo "Checking if various commands can run"
failed=""

cmd="iex -v"
test_res=$($cmd)
test_expected="Elixir"
test_res_status=$?
if [[ "$test_res_status" != 0 || ! "$test_res" =~ $test_expected ]]; then
  failed="$failed x"
  fail "$cmd"
else
  ok "$cmd"
fi

if [[ "$failed" = "" ]]; then
  exit 1
fi
