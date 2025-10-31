#!/bin/sh

SETUP_SOURCE_FILE="setup.sh"
ENV_SOURCE_FILE="../../.env"
export SEP_LINE="-------------------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Sourcing the setup file to setup and teardown the demo script
# ---------------------------------------------------------------------

setup() {
if [ -f "$SETUP_SOURCE_FILE" ]; then
  echo "[INFO] Sourcing $SETUP_SOURCE_FILE."
  source "$SETUP_SOURCE_FILE"
else
  echo "The setup file $SETUP_SOURCE_FILE must exist and be run."
  exit
fi
}

env_setup() {
if [ -f "$ENV_SOURCE_FILE" ]; then
  echo "[INFO] Sourcing $ENV_SOURCE_FILE."
  source "$ENV_SOURCE_FILE"
else
  echo "[WARN]: There is no environment file $ENV_SOURCE_FILE, please be\
  sure to configure script variables'USER' and 'HOST' in this script."
fi
}
# ---------------------------------------------------------------------
# Export environment variables
# ---------------------------------------------------------------------
env_setup
export USER=${MY_USER:="ibmuser"}
export HOST=${MY_HOST:="hostname"}
export DCONCAT="module_example.py"
export WHEEL_DIR="wheel"

# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "Copying python source file dconcat.py to USS"
scp -O ../../python/${DCONCAT} ${USER}@${HOST}:/tmp/${DCONCAT}
scp -O -r ../../python/${WHEEL_DIR} ${USER}@${HOST}:/tmp/${WHEEL_DIR}

# ---------------------------------------------------------------------
# Running dconcat
# ---------------------------------------------------------------------
setup
echo
echo "${SEP_LINE}"
echo "Perform 'dconcat' with module demo on two datasets."
echo "${SEP_LINE}"
echo "[INFO] DS1: Source dataset ${SRC_EMP_FILE_NAME}"
echo "[INFO] DS2: Changes dataset ${ADD_EMP_FILE_NAME}"
echo "[INFO] DS3: Merged dataset ${NEW_EMP_FILE_NAME}"
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
mkdir -p /tmp/lib; \
python3 -m pip install --no-input --upgrade build --target /tmp/lib; \
cd /tmp/wheel; \
python3 -m build; \
pip install /tmp/wheel/dist/dconcat_module-0.0.1-py3-none-any.whl --target /tmp/lib; \
cd /tmp; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
python3 /tmp/${DCONCAT}; \
rm -rf /tmp/*")
echo "[INFO] Results \n${SSH_OUTPUT}"
echo