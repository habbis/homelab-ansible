#!/bin/bash
set -e
#TODO: Support python virtual environments for now global

COLOR_END='\e[0m'
COLOR_RED='\e[0;31m' # Red
COLOR_YEL='\e[0;33m' # Yellow
# This current directory.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(cd "$DIR/../../" && pwd)

PYTHON_REQUIREMNTS_FILE="$DIR/requirements.txt"

msg_exit() {
    printf "$COLOR_RED$@$COLOR_END"
    printf "\n"
    printf "Exiting...\n"
    exit 1
}

msg_warning() {
    printf "$COLOR_YEL$@$COLOR_END"
    printf "\n"
}

# Check if root
# Since we need to make sure paths are okay we need to run as normal user he will use ansible
[[ "$(whoami)" == "root" ]] && msg_exit "Please run as a normal user not root"

# Check python
[[ -z "$(which python3)" ]] && msg_exit "Opps python3 is not installed or not in your path."
# Check pip
[[ -z "$(which pip3)" ]] && msg_exit "pip3 is not installed!\nYou can try'install pip3'"
# Check python file
[[ ! -f "$PYTHON_REQUIREMNTS_FILE" ]]  && msg_exit "python_requirements '$PYTHON_REQUIREMNTS_FILE' does not exist or permssion issue.\nPlease check and rerun."

# Install 
# By default we upgrade all packges to latest. if we need to pin packages use the python_requirements
echo "This script install python packages defined in '$PYTHON_REQUIREMNTS_FILE' "
python3 -m venv ~/venv-ansible
source ~/venv-ansible/bin/activate
~/venv-ansible/bin/pip3 install --upgrade pip
~/venv-ansible/bin/pip3 install --no-cache-dir  --upgrade --requirement "$PYTHON_REQUIREMNTS_FILE"
~/venv-ansible/bin/ansible-galaxy collection install community.general


#Touch vpass
#echo "Touching vpass"
#if [ -w "$ROOT_DIR" ]
#then
#   touch "$ROOT_DIR/.vpass"
#else
#  sudo touch "$ROOT_DIR/.vpass"
#fi
#exit 0
