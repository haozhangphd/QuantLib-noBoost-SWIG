AC_DEFUN([QL_CHECK_CXXFLAGS],
[AC_MSG_CHECKING([whether $CXX accepts warning flags])
 AC_REQUIRE([AC_PROG_CC])
 ql_original_CXXFLAGS=$CXXFLAGS
 ql_more_CXXFLAGS="-fno-strict-aliasing -Wno-unused -Wno-uninitialized -Wno-sign-compare -Wno-write-strings -std=c++17 -march=native -O3 -pipe -fstack-protector-strong"
 CXXFLAGS="$ql_original_CXXFLAGS $ql_more_CXXFLAGS"
 AC_TRY_COMPILE(
    [],
    [],
    [AC_MSG_RESULT([yes])
     AC_SUBST([CXXWARNINGFLAGS], [$ql_more_CXXFLAGS])],
    [AC_MSG_RESULT([no])
    ])
 CXXFLAGS="$ql_original_CXXFLAGS"
])
