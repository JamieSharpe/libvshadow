#!/bin/bash
#
# Library seek testing script
#
# Copyright (c) 2011-2013, Joachim Metz <joachim.metz@gmail.com>
#
# Refer to AUTHORS for acknowledgements.
#
# This software is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this software.  If not, see <http://www.gnu.org/licenses/>.
#

EXIT_SUCCESS=0;
EXIT_FAILURE=1;
EXIT_IGNORE=77;

test_seek()
{ 
	echo "Testing seek offset of input:" $*;

	./${VSHADOW_TEST_SEEK} $*;

	RESULT=$?;

	echo "";

	return ${RESULT};
}

VSHADOW_TEST_SEEK="vshadow_test_seek";

if ! test -x ${VSHADOW_TEST_SEEK};
then
	VSHADOW_TEST_SEEK="vshadow_test_seek.exe";
fi

if ! test -x ${VSHADOW_TEST_SEEK};
then
	echo "Missing executable: ${VSHADOW_TEST_SEEK}";

	exit ${EXIT_FAILURE};
fi

if ! test -d "input";
then
	echo "No input directory found.";

	exit ${EXIT_IGNORE};
fi

OLDIFS=${IFS};
IFS="
";

RESULT=`ls input/* | tr ' ' '\n' | wc -l`;

if test ${RESULT} -eq 0;
then
	echo "No files or directories found in the input directory.";

	EXIT_RESULT=${EXIT_IGNORE};
else
	for TESTDIR in input/*;
	do
		if [ -d "${TESTDIR}" ];
		then
			DIRNAME=`basename ${TESTDIR}`;

			for TESTFILE in ${TESTDIR}/*;
			do
				if ! test_seek "${TESTFILE}";
				then
					exit ${EXIT_FAILURE};
				fi
			done
		fi
	done

	EXIT_RESULT=${EXIT_SUCCESS};
fi

IFS=${OLDIFS};

exit ${EXIT_RESULT};

