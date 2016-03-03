#! /bin/sh
##
## Copyright (c) Ericsson LMC, 2013.
##
## All Rights Reserved. Reproduction in whole or in part is prohibited
## without the written consent of the copyright owner.
##
## ERICSSON MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE
## SUITABILITY OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING
## BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. ERICSSON
## SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A
## RESULT OF USING, MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS
## DERIVATIVES.
##
##


# This script is executed as an installation campaign init action.
# sdp name is passed as first argument
SDP_NAME=$1
LOGFILE=/tmp/javaoam_model_install.log

#-----------------------------------------------------------------
# Function to execute any passed command
#-----------------------------------------------------------------
execute_cmd () {
    if [ $# -eq 0 ]
    then
        echo "Usage: $0 cmd [parameters list] "
        exit 1
    fi

    tmp=`$*`

    if [ $? -ne 0 ]
    then
        echo "Failed to execute: $*" >> $LOGFILE 2>&1
        exit 1
    fi
}

echo "Install IMM model $SDP_NAME " >> $LOGFILE 2>&1

cmw-immClassDelete DPN
immadm -o 1 -p opnsafImmNostdFlags:SA_UINT32_T:1 opensafImm=opensafImm,safApp=safImmService

# Update IMM model
execute_cmd cmw-model-modify ${SDP_NAME} --mt IMM_R1
# Update MP files model
execute_cmd cmw-model-modify ${SDP_NAME} --mt COM_R1
execute_cmd cmw-model-done
# Restart COM to get new configuration
execute_cmd comsa-mim-tool com_switchover

exit 0 
