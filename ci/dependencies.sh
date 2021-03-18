#!/usr/bin/env bash
set -eu

echo2() {
  echo "$@" >&2
}

run() {
  (
    set -x
    "$@"
  )
}

usage() {
  echo2 "${BASH_SOURCE[0]} [options] {command}

  OPTIONS

  -h --help
    Display this message.

  COMMANDS

  deps
    Installs dependencies

  build-deps
    Install build dependencies

  ENVIRONMENT

  LOGLEVEL
    Set to one of DEBUG, INFO, WARN or ERROR to influence the loglevel. Default is WARN.

  LOGLVL
    Numerical equivalent of LOGLEVEL. 1 is ERROR, 2 is WARN, 3 is INFO and 4 is DEBUG.
  "
}

cmd_deps() {
  run sudo apt-get install \
    binutils \
    build-essential \
    gcc \
    gdb \
    libgmp10 \
    libgmp-dev \
    libmpc3 \
    libmpc-dev \
    libmpfr6 \
    libmpfr-dev
}

cmd_build-deps() {
  run sudo apt-get build-dep \
    binutils \
    gdb
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  : "${LOGLEVEL:=WARN}"
  : "${LOGLVL:=2}"
  case "${1:-}" in
    -h | --h*)
      usage
      ;;
    deps)
      cmd_deps "$@"
      ;;
    build-deps)
      cmd_build-deps "$@"
      ;;
    "" | *)
      usage
      exit 1
      ;;
  esac
fi
