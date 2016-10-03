dnl $Id$
dnl config.m4 for extension cabocha

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

PHP_ARG_WITH(cabocha, for cabocha support,
Make sure that the comment is aligned:
[  --with-cabocha          Include cabocha support])

dnl Otherwise use enable:

dnl PHP_ARG_ENABLE(cabocha, whether to enable cabocha support,
dnl Make sure that the comment is aligned:
dnl [  --enable-cabocha           Enable cabocha support])

if test "$PHP_CABOCHA" != "no"; then
  dnl Write more examples of tests here...

  # --with-cabocha -> check with-path
  SEARCH_PATH="/usr/local /usr"     # you might want to change this
  SEARCH_FOR="/include/cabocha.h"  # you most likely want to change this
  if test -r $PHP_CABOCHA/$SEARCH_FOR; then # path given as parameter
    CABOCHA_DIR=$PHP_CABOCHA
  else # search default path list
    AC_MSG_CHECKING([for cabocha files in default path])
    for i in $SEARCH_PATH ; do
      if test -r $i/$SEARCH_FOR; then
        CABOCHA_DIR=$i
        AC_MSG_RESULT(found in $i)
      fi
    done
  fi

  if test -z "$CABOCHA_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Please reinstall the cabocha distribution])
  fi

  # --with-cabocha -> add include path
  PHP_ADD_INCLUDE($CABOCHA_DIR/include)

  # --with-cabocha -> check for lib and symbol presence
  LIBNAME=cabocha # you may want to change this
  LIBSYMBOL=cabocha_new # you most likely want to change this

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
    PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $CABOCHA_DIR/$PHP_LIBDIR, CABOCHA_SHARED_LIBADD)
    AC_DEFINE(HAVE_CABOCHALIB,1,[ ])
  ],[
    AC_MSG_ERROR([wrong cabocha lib version or lib not found])
  ],[
    -L$CABOCHA_DIR/$PHP_LIBDIR -lm
  ])

  PHP_SUBST(CABOCHA_SHARED_LIBADD)

  PHP_NEW_EXTENSION(cabocha, cabocha.c, $ext_shared,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
fi
