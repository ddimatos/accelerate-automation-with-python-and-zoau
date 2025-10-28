#!/bin/sh

# ---------------------------------------------------------------------
# Export environment variables
# ---------------------------------------------------------------------
export USER=${MY_USER:="ibmuser"}
export HOST=${MY_HOST:="hostname"}
export DCONCAT="dconcat.py"


# ---------------------------------------------------------------------
# Copy local file content to UNIX System Services files
# ---------------------------------------------------------------------
echo "Copying python source file dconcat.py to USS"
scp -O ../../python/${DCONCAT} ${USER}@${HOST}:/tmp/${DCONCAT}

# ---------------------------------------------------------------------
# Create and populated z/OS datasets
# ---------------------------------------------------------------------
echo "Run dconcat.py on two data sets and display results."
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
python3 /tmp/${DCONCAT};")

echo "$SSH_OUTPUT"
