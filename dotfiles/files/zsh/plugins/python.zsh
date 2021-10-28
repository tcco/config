# get rid of __pycache__
export PYTHONDONTWRITEBYTECODE=1

# powerlevel10k shows the virtualenv already
export VIRTUAL_ENV_DISABLE_PROMPT=true

# allow square brackets without quotes in pip commands
alias pip="noglob pip"

# function cd() {
#   builtin cd "$@" || return 1
# 
#   if [[ -n "$VIRTUAL_ENV" ]] ; then
#     project_name="$(basename "$VIRTUAL_ENV")"
#     if [[ "$PWD" != *"$project_name"* ]] ; then
#       deactivate
#     else
#     fi
#   fi
# 
#   if [[ -z "$VIRTUAL_ENV" ]] && [[ $PWD != "/" ]]; then
#       venv_dir="$HOME/.venvs/$(basename $PWD)"
#       if [[ -d "$venv_dir" ]] ; then
#         source "$venv_dir/bin/activate"
#       fi
#   fi
# }

function revenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    deactivate || return 1
  fi

  # venv_dir="$HOME/.venvs/$(basename $PWD)"
  venv_dir=".venv"

  if [[ ! -d "$venv_dir" ]]; then
    # rm -rf "$venv_dir" || return 1
    python3 -m venv "$venv_dir" || return 1
  fi

  . "$venv_dir/bin/activate" || return 1

  pip install --upgrade pip
  pip install -e ".[dev]" || return 1
}

# function venv() {
#   if [[ -n "$VIRTUAL_ENV" ]]; then
#     deactivate || return 1
#   fi
# 
#   venv_dir="$HOME/.venvs/$(basename $PWD)"
# 
#   if [[ -d "$venv_dir" ]]; then
#     rm -rf "$venv_dir" || return 1
#   fi
# 
#   python3 -m venv "$venv_dir" || return 1
#   . "$venv_dir/bin/activate" || return 1
# }

function chal () {
  port=${1:-8000}
  original=$(pwd)
  cd $(dirname `find $original -type d -name ".chalice"`)
  chalice local --host 0.0.0.0 --port "$port"
  cd $original
}

function pyv() {
    pip install --use-deprecated=legacy-resolver "$1==" 2>&1 | grep -oP "(?<=from versions: ).*(?=\))"
}

function python-dotenv () {
    cmd=${1:-cat}
    original=$(pwd)
    $cmd $(find $original -type f -name ".env")
}
