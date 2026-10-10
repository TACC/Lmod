#!/usr/bin/env bash
# Programmable-completion check for init/lmod_bash_completions.
# Candidate strings that look like command substitution must stay literal.
# This drives the completion functions directly. It does not press Tab.

set -u

src=${1:?usage: check_compgen.sh /path/to/lmod_bash_completions}
# shellcheck disable=SC1090
. "$src"

# Stub discovery so this test does not run Lmod or need @PKG@ substituted.
_module_avail() {
  printf '%s\n' 'safe' '$(:)' 'other'
}
_module_loaded_modules() { :; }
_module_not_yet_loaded() { _module_avail; }
_module_spider() { :; }
_module_savelist() { :; }
_module_mcc() { :; }
_module_loaded_modules_negated() { :; }

has_word() {
  local want=$1
  shift
  local w
  for w in "$@"; do
    if [[ "$w" == "$want" ]]; then
      return 0
    fi
  done
  return 1
}

report() {
  local label=$1
  shift
  if has_word '$(:)' "$@"; then
    echo "${label}_literal=yes"
  else
    echo "${label}_literal=no"
  fi
  if has_word 'safe' "$@"; then
    echo "${label}_safe=yes"
  else
    echo "${label}_safe=no"
  fi
}

COMPREPLY=()
_module_comgen_words 'safe $(:) other' ''
report helper "${COMPREPLY[@]}"

COMPREPLY=()
_module_comgen_words 'safe $(printf %s INJECTED) other' ''
if has_word 'INJECTED' "${COMPREPLY[@]}"; then
  echo helper_expanded=yes
else
  echo helper_expanded=no
fi

COMPREPLY=()
_module_comgen_words 'safe $(:) other' 'saf'
if [[ ${#COMPREPLY[@]} -eq 1 && ${COMPREPLY[0]} == safe ]]; then
  echo prefix_safe=yes
else
  echo prefix_safe=no
fi

COMPREPLY=()
COMP_WORDS=(module load)
COMP_CWORD=2
_module module '' load
report load "${COMPREPLY[@]}"

COMPREPLY=()
COMP_WORDS=(ml)
COMP_CWORD=1
_ml ml '' ml
report ml "${COMPREPLY[@]}"
