#!/bin/bash
MINIMUM_PYTHON="3.9"
PYTHON_VERSIONS=$(compgen -c python3 |grep -Eo 'python3\.[0-9]+' | sort -V | uniq)
WORKING_PYTHON=""
WORKING_VERSION=""
virtualenvDir=~/ansible-virtual-env

if ! [[ "$0" != "$BASH_SOURCE" ]]; then
  echo 'script need to be sourced, use source scripts/setup.sh'
  exit 1
fi

echo "finding the latest python version to use will fail if it is below the minimum version, currently ${MINIMUM_PYTHON}"
for PYTHON in $PYTHON_VERSIONS; do
   VERSION=$($PYTHON -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null || echo "")
    if [[ -n "$VERSION" && "$(printf '%s\n' "$MINIMUM_PYTHON" "$VERSION" | sort -V | tail -n1)" == "$VERSION" ]]; then
      WORKING_PYTHON=$PYTHON
      WORKING_VERSION=$VERSION
    fi
done

if [[ -z "$WORKING_PYTHON" ]]; then
  echo "error no suitable python version (>= $MIN_PYTHON) found." >&2
  echo 'install it with your package manager, like apt install python${MIN_PYTHON}-venv' >&2
  return 1
fi
python_executable=$WORKING_PYTHON
echo "selected Python executable $python_executable"

${python_executable} --version >/dev/null
if [ $? != 0 ]; then
  echo "error Could not find ${python_executable} make sure it is installed with your package manager and is added to your PATH" >&2
  return 1
fi

venvCreated=false
echo "trying to determine whether to create a new virtual environment"
if [ ! -d ${virtualenvDir} ]; then
  echo "creating the virtual environment at ${virtualenvDir}"
  ${python_executable} -m venv ${virtualenvDir}
  venvCreated=true
else
  echo "virtual environment ${virtualenvDir} already exists."
fi

echo "entering the virtual environment ${virtualenvDir}"
source ${virtualenvDir}/bin/activate
echo "updating pip"
pip install --upgrade pip
echo "installing from requirements.txt"
pip install -r requirements.txt

if [[ "$venvCreated" == "true" ]]; then
  echo "Since virtual environment was not already added importing roles and collections from ansible-galaxy"
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo 'environment variable SSH_AUTH_SOCK not found set it up by running eval $(ssh-agent); ssh-add'
    eval "$(ssh-agent)"; ssh-add
  fi
  echo "importing roles and collections from ansible-galaxy since virtual env dont exist yet"
  echo "installing roles from roles/requirements.yml"
  ansible-galaxy role install -r roles/requirements.yml --force
  echo "installing collections from collections/requirements.yml"
  ansible-galaxy collection install -r collections/requirements.yml --force
fi

echo "ansible ready version info from ansible --version:"
ansible --version
