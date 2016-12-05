# Select appropriate compiler version
set(DASHBOARD_GNU_COMPILER_SUFFIX "")
set(DASHBOARD_CLANG_COMPILER_SUFFIX "")
if(DASHBOARD_UNIX_DISTRIBUTION STREQUAL "Ubuntu")
  if(DASHBOARD_UNIX_DISTRIBUTION_VERSION VERSION_LESS 16.04)
    set(DASHBOARD_GNU_COMPILER_SUFFIX "-4.9")
  else()
    set(DASHBOARD_GNU_COMPILER_SUFFIX "-5")
    set(DASHBOARD_CLANG_COMPILER_SUFFIX "-3.9")
  endif()
endif()

# Select appropriate compiler(s)
set(ENV{F77} "gfortran${DASHBOARD_GNU_COMPILER_SUFFIX}")
set(ENV{FC} "gfortran${DASHBOARD_GNU_COMPILER_SUFFIX}")
if(COMPILER STREQUAL "gcc")
  set(ENV{CC} "gcc${DASHBOARD_GNU_COMPILER_SUFFIX}")
  set(ENV{CXX} "g++${DASHBOARD_GNU_COMPILER_SUFFIX}")
elseif(COMPILER MATCHES "^(clang|(include|link)-what-you-use|cpplint)$")
  set(ENV{CC} "clang${DASHBOARD_CLANG_COMPILER_SUFFIX}")
  set(ENV{CXX} "clang++${DASHBOARD_CLANG_COMPILER_SUFFIX}")
elseif(COMPILER STREQUAL "scan-build")
  find_program(DASHBOARD_CCC_ANALYZER_COMMAND NAMES "ccc-analyzer"
    PATHS "/usr/local/libexec" "/usr/libexec")
  find_program(DASHBOARD_CXX_ANALYZER_COMMAND NAMES "c++-analyzer"
    PATHS "/usr/local/libexec" "/usr/libexec")
  if(NOT DASHBOARD_CCC_ANALYZER_COMMAND OR NOT DASHBOARD_CXX_ANALYZER_COMMAND)
    fatal("scan-build was not found")
  endif()
  set(ENV{CC} "${DASHBOARD_CCC_ANALYZER_COMMAND}")
  set(ENV{CXX} "${DASHBOARD_CXX_ANALYZER_COMMAND}")
  set(ENV{CCC_CC} "clang${DASHBOARD_CLANG_COMPILER_SUFFIX}")
  set(ENV{CCC_CXX} "clang++${DASHBOARD_CLANG_COMPILER_SUFFIX}")
else()
  fatal("unknown compiler '${COMPILER}'")
endif()

# Set base compile options
set(DASHBOARD_C_FLAGS "")
set(DASHBOARD_CXX_FLAGS "")
set(DASHBOARD_CXX_STANDARD "")
set(DASHBOARD_FORTRAN_FLAGS "")
set(DASHBOARD_POSITION_INDEPENDENT_CODE OFF)
set(DASHBOARD_SHARED_LINKER_FLAGS "")
set(DASHBOARD_STATIC_LINKER_FLAGS "")
set(DASHBOARD_VERBOSE_MAKEFILE OFF)