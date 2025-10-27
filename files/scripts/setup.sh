#!/bin/sh

ENV_SOURCE_FILE="../../.env"
export SEP_LINE="-------------------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Place your secrets in a '.env' file in project root for auto sourcing
# ---------------------------------------------------------------------

if [ -f "$ENV_SOURCE_FILE" ]; then
  echo "[INFO] Sourcing $ENV_SOURCE_FILE."
  source "$ENV_SOURCE_FILE"
else
  echo "[WARN] There is no environment file $ENV_SOURCE_FILE, please be\
  sure to configure script variables'USER' and 'HOST' in this script."
fi

# ---------------------------------------------------------------------
# Export environment variables
# ---------------------------------------------------------------------
export USER=${MY_USER:="ibmuser"}
export HOST=${MY_HOST:="hostname"}
export SRC_EMP_FILE_NAME="employee.source.seq"
export ADD_EMP_FILE_NAME="employee.added.seq"
export NEW_EMP_FILE_NAME="employee.all.seq"
export TMP_FILE=/tmp/tmp.txt

# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "[INFO] Copying data employee data to z/OS."
tail -n +3 ../data/${SRC_EMP_FILE_NAME} > ${TMP_FILE}
scp -O ${TMP_FILE} ${USER}@${HOST}:/tmp/${SRC_EMP_FILE_NAME}
rm -rf ${TMP_FILE}
tail -n +3 ../data/${ADD_EMP_FILE_NAME} > ${TMP_FILE}
scp -O ${TMP_FILE} ${USER}@${HOST}:/tmp/${ADD_EMP_FILE_NAME}
rm -rf ${TMP_FILE}

# ---------------------------------------------------------------------
# Copy a templated ssh '.profile' to be used by the script
# ---------------------------------------------------------------------
echo "[INFO] Copying profile to UNIX System Services."
scp -O ../data/profile ${USER}@${HOST}:/.profile

# ---------------------------------------------------------------------
# Create and populated z/OS datasets
# ---------------------------------------------------------------------
echo "[INFO] Create and populate z/OS datasets."
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
# Remove any pre-existing datasets
drm -f ${SRC_EMP_FILE_NAME} > /dev/null 2>&1; \
if [ \$? -eq 0 ]; then echo "[INFO] drm -f ${SRC_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] drm -f ${SRC_EMP_FILE_NAME} failed."; fi; \

# Remove any pre-existing datasets
drm -f ${ADD_EMP_FILE_NAME}> /dev/null 2>&1; \
if [ \$? -eq 0 ]; then echo "[INFO] drm -f ${ADD_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] drm -f ${ADD_EMP_FILE_NAME} failed."; fi; \

# Remove any pre-existing datasets
drm -f ${NEW_EMP_FILE_NAME}> /dev/null 2>&1; \
if [ \$? -eq 0 ]; then echo "[INFO] drm -f ${NEW_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] drm -f ${NEW_EMP_FILE_NAME} failed."; fi; \

# Create empty sequential dataset
dtouch -tseq ${SRC_EMP_FILE_NAME}; \
if [ \$? -eq 0 ]; then echo "[INFO] dtouch -tseq ${SRC_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] dtouch -tseq ${SRC_EMP_FILE_NAME} failed."; fi; \

# Create empty sequential dataset
dtouch -tseq ${ADD_EMP_FILE_NAME}; \
if [ \$? -eq 0 ]; then echo "[INFO] dtouch -tseq ${ADD_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] dtouch -tseq ${ADD_EMP_FILE_NAME} failed."; fi; \

# Create empty sequential dataset
dtouch -tseq ${NEW_EMP_FILE_NAME}; \
if [ \$? -eq 0 ]; then echo "[INFO] dtouch -tseq ${NEW_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] dtouch -tseq ${NEW_EMP_FILE_NAME} failed."; fi; \

# Copy text source into dataset
dcp /tmp/${SRC_EMP_FILE_NAME} ${SRC_EMP_FILE_NAME}; \
if [ \$? -eq 0 ]; then echo "[INFO] dcp /tmp/${SRC_EMP_FILE_NAME} ${SRC_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] dcp /tmp/${SRC_EMP_FILE_NAME} ${SRC_EMP_FILE_NAME} failed."; fi; \

# Copy text source into dataset
dcp /tmp/${ADD_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME}; \
if [ \$? -eq 0 ]; then echo "[INFO] dcp /tmp/${ADD_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME} executed successfully."; else echo "[ERROR] dcp /tmp/${ADD_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME} failed."; fi; \

# Clean up text files
rm -rf /tmp/${SRC_EMP_FILE_NAME} /tmp/${ADD_EMP_FILE_NAME};")

echo "[INFO] Results ${SSH_OUTPUT}"

# ---------------------------------------------------------------------
# Copy and run python file dconcat.py
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Ignore entries from here down
# ---------------------------------------------------------------------
# Working heardoc example
# SSH_OUTPUT=`ssh -q ${USER}@${HOST} << EOF
# # Commands to execute on the remote host
# hostname;
# id;
# ls -l /tmp;
# EOF`
# echo "$SSH_OUTPUT"

# Failing heardoc examples with ZOAU
# OUT=`ssh ${USER}@${HOST} << 'EOF'
# #. ./.profile
# dtouch -tseq "EMPLOYEE.ONE";
# dtouch -tseq "EMPLOYEE.TWO";
# EOF`

# dtouch -tseq ${ADD_EMP_FILE_NAME};
# dcp /tmp/${SRC_EMP_FILE_NAME} ${SRC_EMP_FILE_NAME};
# dcp /tmp/${ADD_EMP_FILE_NAME} ${ADD_EMP_FILE_NAME};
# dls ${SRC_EMP_FILE_NAME};
# dls ${ADD_EMP_FILE_NAME};
# EOF`
