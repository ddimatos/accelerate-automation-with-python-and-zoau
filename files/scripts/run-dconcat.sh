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
# Run dconcat on remote system
# ---------------------------------------------------------------------
echo "Run dconcat on two data sets and display results."
SSH_OUTPUT=$(ssh -q ${USER}@${HOST} ". ./.profile; \
chtag -tc IBM-1047 /tmp/${DCONCAT}; \
chmod 755 /tmp/${DCONCAT}; \
/tmp/./${DCONCAT} "employee.source.seq" "employee.added.seq" "employee.all.seq";")

#/tmp/./${DCONCAT} -r "employee.source.seq" "employee.added.seq";")
#/tmp/./${DCONCAT} "employee.source.seq" "employee.added.seq";")

echo "$SSH_OUTPUT"
