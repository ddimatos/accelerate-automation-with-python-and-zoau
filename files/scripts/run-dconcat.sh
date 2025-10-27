#!/bin/sh

# ---------------------------------------------------------------------
# Export environment variables
# ---------------------------------------------------------------------
export USER=${MY_USER:="ibmuser"}
export HOST=${MY_HOST:="hostname"}
export DCONCAT="dconcat"


# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "Copying shell source file dconcat to USS"
scp -O ../../shell/${DCONCAT} ${USER}@${HOST}:/tmp/${DCONCAT}

# ---------------------------------------------------------------------
# Create and populated z/OS datasets
# ---------------------------------------------------------------------
echo "Run dconcat on two data sets and display results."
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
/tmp/./${DCONCAT};")

echo "$SSH_OUTPUT"
