function(TODAY YEAR MONTH DAY)
    
    IF (WIN32)
        EXECUTE_PROCESS(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE TODAY_RESULT)
    ELSEIF(UNIX)
        EXECUTE_PROCESS(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE TODAY_RESULT)
    ELSE (WIN32)
        MESSAGE(SEND_ERROR "date not implemented for this platform")
        SET(TODAY_RESULT "00/00/0000")
    ENDIF (WIN32)

    string(REGEX REPLACE "(..)/(..)/(....).*" "\\1" ${DAY}    ${TODAY_RESULT})
    string(REGEX REPLACE "(..)/(..)/(....).*" "\\2" ${MONTH}  ${TODAY_RESULT})
    string(REGEX REPLACE "(..)/(..)/(....).*" "\\3" ${YEAR}   ${TODAY_RESULT})

    set(${DAY} ${${DAY}} PARENT_SCOPE)
    set(${MONTH} ${${MONTH}} PARENT_SCOPE)
    set(${YEAR} ${${YEAR}} PARENT_SCOPE)

    # uncomment this line to debug
    #message(STATUS "TODAY_RESULT: ${TODAY_RESULT}  DAY:${DAY} ${DAY}:${${DAY}}  MONTH:${MONTH} ${MONTH}:${${MONTH}}  YEAR:${YEAR} ${YEAR}:${${YEAR}}")
endfunction(TODAY YEAR MONTH DAY)
