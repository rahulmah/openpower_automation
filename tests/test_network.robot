*** Settings ***
Documentation		This suite will verifiy network and MAC configurations
...                     of OpenPower

Resource                ../lib/ipmi_client.robot
Resource                ../lib/utils.robot

*** Variables ***
${IP_ADDREDD_INVALID}      9.3.181
${IP_ADDREDD_STRING}       aa.bb.cc.dd
${MAC_ADDREDD_VALID}       0x00 0x1a 0x3b 0x4e 0x5c 0x0a
${MAC_ADDREDD_ZERO}        0x00 0x00 0x00 0x00 0x00 0x00
${MAC_ADDREDD_INVALID}     0xFF 0xFF 0xFF 0xFF 0xFF 0xFF
${MAC_ADDREDD_SHORT}       0x00 0x1a 0x3b
${MAC_ADDREDD_LONG}        0x00 0x1a 0x3b 0x4e 0x5c 0x0a 0x0a

*** Test Cases ***                                

Set Invalid IP Address
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting invalid
    ...               ip address.

    ${set_resp}=    Set IP Address     ${IP_ADDREDD_INVALID}
    Should Start With    ${set_resp}    Invalid IP address


Set Invalid IP Address using string
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting ip
    ...               address using string.

    ${set_resp}=    Set IP Address     ${IP_ADDREDD_STRING}
    Should Start With    ${set_resp}    Invalid IP address


Set Zero MAC Address
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting
    ...               zero MAC address.

    ${set_resp}=    Set MAC Address    ${MAC_ADDREDD_ZERO}
    Should End With    ${set_resp}    Invalid data field in request


Set Invalid MAC Address
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting
    ...               invalid MAC address.

    ${set_resp}=    Set MAC Address    ${MAC_ADDREDD_INVALID}
    Should End With    ${set_resp}    Invalid data field in request


Set Short MAC Address
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting
    ...               short length MAC address.

    ${set_resp}=    Set MAC Address    ${MAC_ADDREDD_SHORT}
    Should End With    ${set_resp}    Request data length invalid


Set Long MAC Address
    [Documentation]   ***BAD PATH***
    ...               This test is to verify error while setting
    ...               long length MAC address.

    ${set_resp}=    Set MAC Address    ${MAC_ADDREDD_LONG}
    Should End With    ${set_resp}    Request data length invalid


Set Valid MAC Address
    [Documentation]   ***GOOD PATH***
    ...               This test case tries to set MAC address of BMC.
    ...               Later revert back its old MAC address.

    ${get_resp}=    Get MAC Address

    ${set_resp}=    Set MAC Address    ${MAC_ADDREDD_VALID}
    Should Be Empty    ${set_resp}

    log to console    Waiting for system to pingable
    Wait For Host To Ping   ${OPENPOWER_HOST}
    log to console    System pinging now

    Get MAC Address

    ${set_resp1}=    Set MAC Address    0x70 0xe2 0x84 0x14 0x00 0xd9
    Should Be Empty    ${set_resp}

    log to console    Waiting for system to pingable
    Wait For Host To Ping   ${OPENPOWER_HOST}
    log to console    System pinging now

    Get MAC Address


***keywords***

Set IP Address
    [Documentation]   This keyword set IP address of BMC to given address
    ...               using ipmitool.
    [Arguments]       ${address}

    ${set_address}=    Run IPMI Standard Command    lan set 1 ipaddr ${address}

    [return]    ${set_address}

Get MAC Address
    [Documentation]   This keyword return MAC address of BMC using ipmitool

    ${resp}=    Run IPMI Standard Command    lan print
    ${address_line} =   Get Lines Matching Pattern    ${resp}    MAC Address*
    ${mac_address_list} =   Get Regexp Matches   ${address_line}   ([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])
    ${mac_address} =   Get From List   ${mac_address_list}   0
    log to console    ${mac_address}

    [return]    ${mac_address}

Set MAC Address
    [Documentation]   This keyword set MAC address of BMC to given address
    ...               using ipmitool
    [Arguments]       ${address}

    ${enable_eth}=    Run IPMI Raw Command    0x0c 0x01 0x01 0xc2 0x00
    ${set_address}=    Run IPMI Raw Command    0x0c 0x01 0x01 0x05 ${address}

    [return]    ${set_address}
