*** Settings ***
Documentation           This module is for executing ipmitool commands.

Resource        ../lib/resource.txt

Library                SSHLibrary
Library           OperatingSystem

*** Variables ***

${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Keywords ***

Open Connection And Log In
    Open connection     ${OPENPOWER_HOST}
    Login   ${OPENPOWER_USERNAME}    ${OPENPOWER_PASSWORD}

Open Connection for scp
    Import Library      SCPLibrary      WITH NAME       scp
    scp.Open connection   ${OPENPOWER_HOST}   username=${OPENPOWER_USERNAME}  password=${OPENPOWER_PASSWORD}


Run IPMI Raw Command
    [arguments]    ${args}
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD} raw ${args}
    Log To Console     \n Execute: ${ipmi_cmd}
    ${rc}    ${output}=    Run and Return RC and Output   ${ipmi_cmd}
    Sleep   5sec
    [return]    ${output}

Run IPMI Standard Command
    [arguments]    ${args}
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${args}
    Log To Console     \n Execute: ${ipmi_cmd}
    ${rc}    ${output}=    Run and Return RC and Output   ${ipmi_cmd}
    Log To Console     ${rc}
    Sleep   5sec
    [return]   ${output}
