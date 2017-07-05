# Process this file with autoconf to produce a configure script.
AC_INIT([QuantLib-SWIG], [1.10],
        [quantlib-dev@lists.sourceforge.net],
        [QuantLib-SWIG])
AC_PREREQ(2.50)
AC_CONFIG_AUX_DIR([config])
AM_INIT_AUTOMAKE([foreign])

AC_COPYRIGHT([Copyright (C) 2005, 2006, 2007, 2008 StatPro Italia srl

This file is part of QuantLib, a free-software/open-source library
for financial quantitative analysts and developers - http://quantlib.org/

QuantLib is free software: you can redistribute it and/or modify it
under the terms of the QuantLib license.  You should have received a
copy of the license along with this program; if not, please email
<quantlib-dev@lists.sf.net>. The license is also available online at
<http://quantlib.org/license.shtml>.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.])

# check target
AC_MSG_CHECKING([system])
target=`uname`
AC_MSG_RESULT([$target])

# check compiler
AC_LANG([C++])

QL_CHECK_CXXFLAGS

# check for QuantLib
AC_MSG_CHECKING([for QuantLib])
ql_version=1.10
AC_MSG_RESULT([$ql_version])

# check for tools
AC_PATH_PROG([SWIG], [swig])

AC_PATH_PROG([PYTHON], [python])
AM_CONDITIONAL(HAVE_PYTHON, test "x${PYTHON}" != "x")
AC_ARG_ENABLE([python],
              AC_HELP_STRING([--disable-python],
                             [If disabled, the Python module
                              will not be built]),
              [build_python=$enableval],
              [build_python=yes])
AM_CONDITIONAL(BUILD_PYTHON, test "$build_python" != "no")

# flags

case "$target" in
Darwin)
    AC_SUBST([SHARED_LIB],[${SHARED_LIB='-dynamiclib'}])
	AC_SUBST([JNILIB_EXTENSION],[${JNILIB_EXTENSION='jnilib'}]) ;;
*)
    AC_SUBST([SHARED_LIB],[${SHARED_LIB='-shared'}])
	AC_SUBST([JNILIB_EXTENSION],[${JNILIB_EXTENSION='so'}]) ;;
esac


# done, output the configured files
AC_CONFIG_FILES([
    Makefile
    Python/Makefile
    Python/setup.py])
AC_OUTPUT

