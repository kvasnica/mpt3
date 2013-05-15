#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

# to generate ./configure run:
# 	$ autoconf

# to clean up autoconf files, run:
#	$ make realclean

AC_INIT(mpt, 3.0, michal.kvasnica@stuba.sk)
# no config.log please
AC_RUN_LOG(:)

# check if the configuration is complete
AC_CONFIG_SRCDIR(configure.ac)

# Checks for programs.
AC_PROG_SED
AC_PROG_GREP
AC_PROG_MAKE_SET
AC_PROG_LN_S

# check if cygwin is used, and if yes, Microsoft Compiler (cl.exe) must be found,
# using "cl.exe" is much more versatile for compilation under windows than using GCC and linking via MinGW
IS_CYGWIN=`uname | grep -i cygwin`
if [[ "$IS_CYGWIN" ]];  then 
	AC_CHECK_PROG(CL, cl.exe, cl.exe, no)
	if test "$CL" = no ; then
	   	echo 'Cannot find Microsoft Windows Visual Studio compiler "cl.exe" on the path.'
		echo 'Did you set the path to Visual Studio binaries?.'
		echo 'Current value of the PATH variable is:'
		echo $PATH
		echo 'You can add the path to "cl.exe" at the cygwin prompt (assuming that you provide correct path) as follows'
		echo ' '
		echo 'export PATH=$PATH:"/cygdrive/c/Program Files/Microsoft Visual Studio/VC/bin"'
		echo ' '  
		AC_MSG_ERROR(Cannot find Microsoft Windows compiler "cl.exe".)
	
	fi
	AC_SUBST(CC,[$CL])
	AC_SUBST(CXX,[$CL])
else
	AC_PROG_CC
	AC_PROG_CXX
	#AC_PROG_CXX sets CXX to g++ if it cannot find a working C++ compiler
	#thus, we test here whether $CXX is actually working 
	AC_LANG_PUSH(C++)
	AC_MSG_CHECKING([whether C++ compiler $CXX works]);
	AC_COMPILE_IFELSE(
	  [AC_LANG_PROGRAM(, [int i=0;])],
	  [AC_MSG_RESULT(yes)],
	  [AC_MSG_RESULT(no)
	  AC_MSG_ERROR(failed to find a C++ compiler or C++ compiler $CXX does not work)]
	)
	AC_LANG_POP(C++)
fi

AC_CHECK_PROG(MATLAB, matlab, matlab, no)
if test "$MATLAB" = no ; then
	AC_MSG_ERROR(Cannot find matlab on the path.)
fi

AC_CHECK_PROG(WGET, wget, wget, no)
if test "$WGET" = no ; then
	AC_MSG_ERROR(Cannot find wget. Please, install "wget" program.)
fi

AC_CHECK_PROG(UNZIP, unzip, unzip, no)
if test "$UNZIP" = no ; then
	AC_MSG_ERROR(Cannot find unzip.)
fi

AC_CHECK_PROG(GUNZIP, gunzip, gunzip, no)
if test "$GUNZIP" = no ; then
	AC_MSG_ERROR(Cannot find gunzip.)
fi

AC_CHECK_PROG(GZIP, gzip, gzip, no)
if test "$GZIP" = no ; then
	AC_MSG_ERROR(Cannot find gzip.)
fi

AC_CHECK_PROG(SCP, scp, scp, no)
if test "$SCP" = no ; then
	AC_MSG_ERROR(Cannot find scp. Please, install "openssh" package.)
fi

AC_CHECK_PROG(MAXDOC, maxdoc, maxdoc, no)
if test "$MAXDOC" = no ; then
	AC_MSG_ERROR(Cannot find "maxdoc" on the path (needed to generate documentation).)
fi

AC_CHECK_PROG(RSYNC, rsync, rsync, no)
if test "$RSYNC" = no ; then
	AC_MSG_ERROR(Cannot find "rsync". Please, install "rsync" package.)
fi


# Once Matlab has been found, extract some data from it's environment
AC_CONFIG_COMMANDS_PRE("`which matlab`" -nosplash -nodisplay -nodesktop -r \
		"fid = fopen('matlab_info.tmp','w+'); \
		 fprintf(fid,'%s%s%s%s\n%s%s\n','MATLAB_ROOT:=',char(34),matlabroot,char(34), 'PLATFORM:=',computer); \
		 fprintf(fid,'%s%d\n','IS_WIN:=',ispc); \
		 fprintf(fid,'%s%d\n','IS_MAC:=',ismac); \
		 if strcmp(computer,'MACI64') \
		    disp('Testing whether -maci option works.'); \
		    if unix('`which matlab` -maci -nosplash -nodisplay -r ''computer; exit;'' ')==0 \
		       disp('... ok '); \
		       fprintf(fid,'%s%d\n','MACI_WORKS:=',1); \
		    else \
		       disp('... -maci does not work.'); \
		       fprintf(fid,'%s%d\n','MACI_WORKS:=',0); \
		    end ; \
		 else \
		       fprintf(fid,'%s%d\n','MACI_WORKS:=',0); \
		 end; \
		 fclose(fid); \
		 exit;" \
		 )
# we have to wait until the file "matlab_info.tmp" is generated and then
# we can substitute matlab variables in Makefile
# if "matlab_info.tmp" cannot be generated, quit after 15*5 seconds
AC_CONFIG_COMMANDS_PRE( \
		LOOP=0; \
		 while true; do \
			LOOP=$(expr $LOOP + 1); \
			test "$LOOP" -gt "15" \
			        && AC_MSG_ERROR(Something is wrong with matlab. Cannot create "matlab_info.tmp".); \
			test -f "matlab_info.tmp" \
					&& break \
					|| (echo 'Waiting for generation of "matlab_info.tmp" ...' && sleep 5); \
		 done; \
		 echo '... Done.'; \
		 AC_SUBST(MATLAB_INFO,$(cat matlab_info.tmp)) \
		 )

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile source/mpt/modules/geometry/sets/@Polyhedron/Makefile])
AC_OUTPUT
