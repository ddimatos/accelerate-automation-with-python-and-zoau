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
export DCONCAT="dconcat"

# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "[INFO] Copying 'dconcat' shell utlity to UNIX System Services."
scp -O ../../shell/${DCONCAT} ${USER}@${HOST}:/tmp/${DCONCAT}

# ---------------------------------------------------------------------
# Running dconcat
# ---------------------------------------------------------------------
setup
echo
echo "${SEP_LINE}"
echo "Perform 'dconcat' on two datasets and merge into new dataset."
echo "DS1 and DS2 are diffed and inserted into DS3"
echo "${SEP_LINE}"
echo "[INFO] DS1: Source dataset ${SRC_EMP_FILE_NAME}"
echo "[INFO] DS2: Changes dataset ${ADD_EMP_FILE_NAME}"
echo "[INFO] DS3: Merged dataset ${NEW_EMP_FILE_NAME}"
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
/tmp/./${DCONCAT} ${SRC_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME} ${NEW_EMP_FILE_NAME}; \
dcat ${NEW_EMP_FILE_NAME}")
echo "[INFO] Results \n${SSH_OUTPUT}"
echo

setup
echo
echo "${SEP_LINE}"
echo "Perform 'dconcat' on two datasets and merge changed into source dataset."
echo "DS1 and DS2 are diffed and inserted into DS1"
echo "${SEP_LINE}"
echo "[INFO] DS1: Source dataset ${SRC_EMP_FILE_NAME}"
echo "[INFO] DS2: Changes dataset ${ADD_EMP_FILE_NAME}"
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
/tmp/./${DCONCAT} ${SRC_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME}; \
dcat ${SRC_EMP_FILE_NAME}")
echo "[INFO] Results \n${SSH_OUTPUT}"
echo

setup
echo
echo "${SEP_LINE}"
echo "Perform 'dconcat' on two datasets and merge source into changed dataset."
echo "DS1 and DS2 are diffed and inserted into DS2"
echo "${SEP_LINE}"
echo "[INFO] DS1: Source dataset ${SRC_EMP_FILE_NAME}"
echo "[INFO] DS2: Changes dataset ${ADD_EMP_FILE_NAME}"
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
/tmp/./${DCONCAT} -r ${SRC_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME}; \
dcat ${ADD_EMP_FILE_NAME}")
echo "[INFO] Results \n${SSH_OUTPUT}"
echo

# ---------------------------------------------------------------------
# Run dconcat
# ---------------------------------------------------------------------
# echo "Run dconcat on two data sets and display results."
# SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
# chtag -tc IBM-1047 /tmp/${DCONCAT}; \
# chmod 755 /tmp/${DCONCAT}; \
# /tmp/./${DCONCAT} "employee.source.seq" "employee.added.seq" "employee.all.seq";")
#/tmp/./${DCONCAT} -r "employee.source.seq" "employee.added.seq";")
#/tmp/./${DCONCAT} "employee.source.seq" "employee.added.seq";")
# echo "$SSH_OUTPUT"
