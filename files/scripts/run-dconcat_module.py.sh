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
export DCONCAT_MODULE="dconcat_module.py"

# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "Copying python source file dconcat.py to USS"
scp -O ../../python/${DCONCAT} ${USER}@${HOST}:/tmp/${DCONCAT}
scp -O ../../python/module/${DCONCAT_MODULE} ${USER}@${HOST}:/tmp/${DCONCAT_MODULE}
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
rm -rf /tmp/module; \
mkdir /tmp/module; \
mv /tmp/${DCONCAT_MODULE} /tmp/module; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
python3 /tmp/${DCONCAT};")
echo "[INFO] Results \n${SSH_OUTPUT}"
echo