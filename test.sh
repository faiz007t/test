function MediaUnlockTest_PrimeVideo() {
    echo -n -e " PrimeVideo:\t\t\t\t->\c";
	local result=$(curl --user-agent "${UA_Browser}" -${1} -sL "https://www.primevideo.com/")
    
    if [[ "$result" == "curl"* ]];then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}Failed (Network Connection)${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tFailed (Network Connection)" >> ${LOG_FILE};
        return;
    fi
    
	local result=`curl --user-agent "${UA_Browser}" -${1} -sL "https://www.primevideo.com/" | grep "currentTerritory" | cut -d '"' -f4`;
	
    if [ -n "$result" ]; then
        echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Green}${result}${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\t${result}" >> ${LOG_FILE};
        return;
    fi
    
    echo -n -e "\r PrimeVideo:\t\t\t\t${Font_Red}No${Font_Suffix}\n" && echo -e " PrimeVideo:\t\t\t\tNo" >> ${LOG_FILE};
    return;
} 
