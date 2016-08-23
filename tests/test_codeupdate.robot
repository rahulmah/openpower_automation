*** Settings ***
Documentation     This module is for code update

Resource          ../lib/ipmi_client.robot
Resource          ../lib/utils.robot

*** Variables ***
${SUFFIX}         component 1 -z 30000 force <<< y

*** Test Cases ***

Code Update Using IPMItool
   [Documentation]   Code Update using IPMITool

   Should not be empty    ${HPM_IMG_PATH}

   # Preserve network and applies fix to BMC
   ${prefix}=   Catenate  SEPARATOR=    ${BMC_HPM_UPDATE}${SPACE}
   ${hpm_cmd}=  Catenate  SEPARATOR=   ${prefix}${HPM_IMG_PATH}${SPACE}${SUFFIX}
   Log To Console      ${hpm_cmd}
   check if image exist  ${HPM_IMG_PATH}

   Preserve Network Settings
   ${status}=  Run IPMI Standard Command    ${hpm_cmd}
   Should Contain    ${status}   Firmware upgrade procedure successful

   Sleep   30sec
   log to console    Waiting for system to pingable
   Wait For Host To Ping   ${OPENPOWER_HOST}
   log to console    System pinging now


*** Keywords ***

check if image exist
   [Documentation]   Check if the given image exist
   [Arguments]       ${arg}
   OperatingSystem.File Should Exist    ${arg}   msg=File ${arg} doesn't exist..


ipmi cold reset
   [Documentation]   cold reset BMC
   Log To Console   \n Cold reset to proceed code update
   ${status}=  Run IPMI Standard Command   ${BMC_COLD_RESET}
   Should be equal   ${status}   Sent cold reset command to MC

Preserve Network Settings
   [Documentation]  Network setting is preserved
   Log To Console   \n Preserve Network Settings
   ${status}=    Run IPMI Standard Command    ${BMC_PRESRV_LAN}
   Should not contain   ${status}   Unable to establish LAN session

