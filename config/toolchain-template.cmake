# http://www.cmake.org/Wiki/CmakeEldk

# this one is important
SET(CMAKE_SYSTEM_NAME			@SYSTEM_NAME@)

#this one not so much
SET(CMAKE_SYSTEM_VERSION		@SYSTEM_VERSION@)

# specify the cross compiler
SET(CMAKE_C_COMPILER			@CC@)
SET(CMAKE_CXX_COMPILER			@CXX@)

# where is the target environment
SET(CMAKE_FIND_ROOT_PATH		@SYSROOT_TOOLCHAIN@ @SYSROOT_TARGET@)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM	NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY	ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE	ONLY)
