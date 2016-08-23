*** Settings ***
Resource                ../lib/resource.txt
Resource                ../lib/ipmi_client.robot

Library           SSHLibrary
Library           OperatingSystem

*** Variables ***


*** Keywords ***

Wait Wait For Host To Ping
    [Arguments]     ${host}
    Wait Until Keyword Succeeds     ${OPENPOWER_REBOOT_TIMEOUT}min    5 sec   Ping Host   ${host}

Wait For Host To Ping
    [Arguments]     ${host}     ${timeout}=10min
    Log To Console  Waiting for ${timeout}
    Wait Until Keyword Succeeds     ${timeout}  5 sec   Ping Host   ${host}

Ping Host
    [Arguments]     ${host}
    ${RC}   ${output} =     Run and return RC and Output    ping -c 4 ${host}
    Log     RC: ${RC}\nOutput:\n${output}
    Should be equal     ${RC}   ${0}

chassis power status
    [Documentation]  Chassis power status
    ${status}=    Run IPMI Command   ${POWER_STATUS}
    Log To Console   \n ${status}
    [return]   ${status}

chassis power IPL status
    [Documentation]  Chassis power IPL status
    ${status}=    Run IPMI Command   ${HOST_STATUS}
    Log To Console   \n ${status}
    Should contain   ${status}     S0/G0: working
    [return]   ${status}

chassis SEL check
    ${status}=    Run IPMI Command   ${SEL_ELIST}
    Log To Console   ${status}
    Should be equal   ${status}    SEL has no entries

chassis SEL clear
    ${status}=    Run IPMI Command   ${SEL_CLEAR}
    Log To Console   ${status}
    Should Contain   ${status}    Clearing SEL

power off
    [Documentation]  Chassis power off
    ${status}=    Run IPMI Command   ${POWER_OFF}
    Log To Console   ${status}
    ${status}=  chassis power status
    Should be equal   ${status}    Chassis Power is off


power on
    [Documentation]  Chassis power on
    ${status}=    Run IPMI Command   ${POWER_ON}
    Log To Console   ${status}
    ${status}=  chassis power status
    Should be equal   ${status}    Chassis Power is on
