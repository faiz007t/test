#!/bin/bash
shell_version="1.4.1";
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36";
UA_Dalvik="Dalvik/2.1.0 (Linux; U; Android 9; ALP-AL00 Build/HUAWEIALP-AL00)";
DisneyAuth="grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Atoken-exchange&latitude=0&longitude=0&platform=browser&subject_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiNDAzMjU0NS0yYmE2LTRiZGMtOGFlOS04ZWI3YTY2NzBjMTIiLCJhdWQiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOnRva2VuIiwibmJmIjoxNjIyNjM3OTE2LCJpc3MiOiJ1cm46YmFtdGVjaDpzZXJ2aWNlOmRldmljZSIsImV4cCI6MjQ4NjYzNzkxNiwiaWF0IjoxNjIyNjM3OTE2LCJqdGkiOiI0ZDUzMTIxMS0zMDJmLTQyNDctOWQ0ZC1lNDQ3MTFmMzNlZjkifQ.g-QUcXNzMJ8DwC9JqZbbkYUSKkB1p4JGW77OON5IwNUcTGTNRLyVIiR8mO6HFyShovsR38HRQGVa51b15iAmXg&subject_token_type=urn%3Abamtech%3Aparams%3Aoauth%3Atoken-type%3Adevice"
DisneyHeader="authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84"
Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";
LOG_FILE="check.log";

clear;
echo -e "${Font_SkyBlue} **Media Streaming Unlocker Test By faisal971** ${Font_Suffix}" && echo -e " **Media Streaming Unlocker Test By faisal971** " > ${LOG_FILE};
echo -e " ----------------------------------------------\n" && echo -e " ----------------------------------------------\n" > ${LOG_FILE};

export LANG="en_US";
export LANGUAGE="en_US";
export LC_ALL="en_US";

function PharseJSON() {
    # Instructions: PharseJSON "raw JSON text to parse" "key value to parse"
    # Example: PharseJSON ""Value":"123456"" "Value" [return result: 123456]
    echo -n $1 | jq -r .$2;
}

function ISP(){
    local result=$(curl --user-agent "${UA_Browser}" -${1} -sL "https://api.ip.sb/geoip")
    local result1=$(echo $result | python -m json.tool 2>/dev/null | grep 'ip' | cut -f4 -d'"')
    local result2=$(echo $result | python -m json.tool 2>/dev/null | grep 'country_code' | cut -f4 -d'"')
    local result3=$(echo $result | python -m json.tool 2>/dev/null | grep 'region' | cut -f4 -d'"')
    local result4=$(echo $result | python -m json.tool 2>/dev/null | grep 'city' | cut -f4 -d'"')
    local result5=$(echo $result | python -m json.tool 2>/dev/null | grep 'isp' | cut -f4 -d'"')
}

function InstallJQ() {
    #InstallJQ
    if [ -e "/etc/redhat-release" ];then
        echo -e "${Font_Green}installing dependencies: epel-release${Font_Suffix}";
        yum install epel-release -y -q > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        yum install jq -y -q > /dev/null;
        elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${Font_Green}Updating package list...${Font_Suffix}";
        apt-get update -y > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        apt-get install jq -y > /dev/null;
        elif [[ $(cat /etc/issue | grep '^ID=') =~ alpine ]];then
        apk update > /dev/null;
        echo -e "${Font_Green}installing dependencies: jq${Font_Suffix}";
        apk add jq > /dev/null;
    else
        echo -e "${Font_Red}Please install jq manually${Font_Suffix}";
        exit;
    fi
}

# Streaming Unlock Test - PrimeVideo
function MediaUnlockTest_PrimeVideo() {
    echo -n -e " PrimeVideo:\t\t\t\t->\c";
	local result=$(curl --user-agent "${UA_Browser}" -${1} -sL "https://www.primevideo.com/")
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=(curl --user-agent "${UA_Browser}" -${1} -sL "https://www.primevideo.com/" | sed 's/,/\n/g' | grep "currentTerritory" | cut -d '"' -f4);
	
    if [ -n "$result" ]; then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tNo" >> ${LOG_FILE};
    return;
}

# Media Unlock Test Sites
function MediaUnlockTest() {
    ISP ${1};
    MediaUnlockTest_PrimeVideo ${1};
}

curl -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    echo -e "${Font_Red}Please install curl${Font_Suffix}";
    exit;
fi

jq -V > /dev/null 2>&1;
if [ $? -ne 0 ];then
    InstallJQ;
fi
check4=`ping 1.1.1.1 -c 1 2>&1`;
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    MediaUnlockTest 4;
else
    echo -e "${Font_SkyBlue}The current host does not support IPv4, skip...${Font_Suffix}" && echo "The current host does not support IPv4, skip..." >> ${LOG_FILE};
fi
echo -e "\n${Font_Yellow} ==================[ Finish ]===================${Font_Suffix}\n" && echo -e "\n ==================[ Finish ]===================$\n" >> ${LOG_FILE};
