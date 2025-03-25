# Internal variable to signal a problem of, some sort, then we can run through them
# all, then break
# We will make use of the push-pop of check-states
set(error_omb FALSE)

macro(CHECK_START msg)
  message(CHECK_START "${msg}")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
endmacro()

# Simple wrapper for checking variables
macro(CHECK_PASS_FAIL)
  cmake_parse_arguments(_cf "REQUIRED;EXIT_CODE" "PASS;FAIL" "" ${ARGN})
  if( NOT DEFINED _cf_PASS )
    set(_cf_PASS "found")
  endif()
  if( NOT DEFINED _cf_FAIL )
    set(_cf_FAIL "not found")
  endif()
  list(POP_FRONT _cf_UNPARSED_ARGUMENTS _cpf_VARIABLE)

  list(POP_BACK CMAKE_MESSAGE_INDENT)

  # If the variable is an EXIT_CODE, then 0 is true, and anything
  # else is false
  if( _cf_EXIT_CODE )
    if( ${${_cpf_VARIABLE}} EQUAL 0 )
      message(CHECK_PASS "${_cf_PASS}")
    else()
      if( _cf_REQUIRED )
        message(CHECK_FAIL "${_cf_FAIL} {${${_cpf_VARIABLE}}} [required]")
        set(error_omb TRUE)
      else()
        message(CHECK_FAIL "${_cf_FAIL} {${${_cpf_VARIABLE}}}")
      endif()
    endif()
  else()
    if( ${${_cpf_VARIABLE}} )
      message(CHECK_PASS "${_cf_PASS}")
    else()
      if( _cf_REQUIRED )
        message(CHECK_FAIL "${_cf_FAIL} [required]")
        set(error_omb TRUE)
      else()
        message(CHECK_FAIL "${_cf_FAIL}")
      endif()
    endif()
  endif()
endmacro()
