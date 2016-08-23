*** Settings ***
Documentation		This suite will verifiy the Network Configuration Rest Interfaces
...					Details of valid interfaces can be found here...
...					https://github.com/openbmc/docs/blob/master/rest-api.md

Resource                ../lib/ipmi_client.robot
Resource                ../lib/utils.robot

*** Variables ***
${MAC_ADDREDD_LONG}        0x00 0x1a 0x3b 0x4e 0x5c 0x0a 0x0a

*** Test Cases ***                                


Restart using NMI
    [Documentation]   Restart using NMI

    ${resp}=    Run IPMI Standard Command    power off
    Should Be Equal    ${resp}    Chassis Power Control: Down/Off

    ${resp}=    Run IPMI Standard Command    power on
    Should Be Equal    ${resp}    Chassis Power Control: Up/On

    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n Partition now online

    Log To Console       \n Triigering NMI
    Run IPMI Standard Command    power diag

    Sleep   60sec
    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n Partition now online

Create Multiple SOL Sessions
    [Documentation]   Create Multiple SOL Sessions

    Run IPMI Standard Command    sol deactivate

    ${resp}=    Run IPMI Standard Command    sol activate &
    Log To Console    ${resp}
    Should Contain    ${resp}    SOL Session operational

    ${resp}=    Run IPMI Standard Command    sol activate > file.txt &
    Log To Console    ${resp}

Multiple times Activate and Deactivate SOL
    [Documentation]   Continous IPMItool command to BMC
    : FOR    ${count}    IN RANGE    0    2
    \    Log To Console  \n [ *** IPMItool command count: ${count} *** ]
    \    Run IPMI Standard Command    sol deactivate
    \
    \    ${resp}=    Run IPMI Standard Command    sol activate &
    \    Log To Console    ${resp}
    \    Should Contain    ${resp}    SOL Session operational

Continous IPMItool command to BMC
    [Documentation]   Continous IPMItool command to BMC
    : FOR    ${count}    IN RANGE    0    5
    \    Log To Console  \n [ *** IPMItool command count: ${count} *** ]
    \    ${resp}=    Run IPMI Standard Command    sol info
    \    Should Contain    ${resp}    Set in progress

Multiple Power OFF and ON
    [Documentation]   Multiple iteration of power off and on
    : FOR    ${count}    IN RANGE    0    2
    \    Log To Console  \n [ *** Power OFF and ON count: ${count} *** ]
    \    Log To Console       \n Powering OFF System
    \    ${resp}=    Run IPMI Standard Command    power off
    \    Should Be Equal    ${resp}    Chassis Power Control: Down/Off
    \
    \    Log To Console       \n Powering ON System
    \    ${resp}=    Run IPMI Standard Command    power on
    \    Should Be Equal    ${resp}    Chassis Power Control: Up/On
    \
    \    Log To Console       \n Wait for OS to come online
    \    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    \    Log To Console       \n Partition now online

Multiple CEC Reset
    [Documentation]   Multiple iteration of CEC reset

    ${resp}=    Run IPMI Standard Command    power off
    Should Be Equal    ${resp}    Chassis Power Control: Down/Off

    ${resp}=    Run IPMI Standard Command    power on
    Should Be Equal    ${resp}    Chassis Power Control: Up/On

    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n Partition now online

    : FOR    ${count}    IN RANGE    0    2
    \    Log To Console  \n [ *** CEC Reset count: ${count} *** ] \n
    \    CEC Reset

Multiple BMC Reset
    [Documentation]   Multiple iteration of BMC reset

    ${resp}=    Run IPMI Standard Command    power off
    Should Be Equal    ${resp}    Chassis Power Control: Down/Off

    ${resp}=    Run IPMI Standard Command    power on
    Should Be Equal    ${resp}    Chassis Power Control: Up/On

    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n Partition now online

    : FOR    ${count}    IN RANGE    0    2
    \    Log To Console  \n [ *** BMC Reset count: ${count} *** ] \n
    \    BMC Reset


***keywords***

BMC Reset
    [Documentation]   Reset BMC using ipmitool

    Log To Console       \n Reseting BMC....
    ${resp}=    Run IPMI Standard Command    power reset
    Should Be Equal    ${resp}    Chassis Power Control: Reset

    log to console    Waiting for system to pingable
    Wait For Host To Ping   ${OPENPOWER_HOST}
    log to console    System pinging now

    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n partition now online

CEC Reset
    [Documentation]   Reset CEC using ipmitool

    Log To Console       \n Reseting CEC....
    ${resp}=    Run IPMI Standard Command    power cycle
    Should Be Equal    ${resp}    Chassis Power Control: Cycle

    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}   15min
    Log To Console       \n partition now online
