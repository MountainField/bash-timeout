#!/usr/bin/env bats

# =================================================================
# bash-timeout
#
# Copyright (c) 2018 Takahide Nogayama
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
# =================================================================

@test "${CONTEXT} / Status / timeout 2 sleep 1 #=> success" {
	run bash -c "\
		${TIMEOUT} 2 sleep 1 \
			2> ${BATS_TMPDIR}/stderr"
    (( ${status} == 0 ))
}

@test "${CONTEXT} / Status / timeout 1 sleep 2 #=> error" {
	run bash -c "\
		${TIMEOUT} 1 sleep 2 \
			2> ${BATS_TMPDIR}/stderr"
    [[ "${status}" > 0 ]]
}

@test "${CONTEXT} / Status / timeout 1 ls /FOOBAAR #=> error and status was retained" {
	run bash -c "ls /FOOBAAR &> /dev/null"
	local expected_status=$status
    [[ "${expected_status}" > 0 ]]
	
	run bash -c "\
		${TIMEOUT} 1 ls /FOOBAAR \
			2> ${BATS_TMPDIR}/stderr"
    [[ "${status}" == "${expected_status}" ]]
}

@test "${CONTEXT} / Output / timeout 1 echo abc #=> abc" {
	run bash -c	"\
		${TIMEOUT} 1 echo abc \
			1>  ${BATS_TMPDIR}/output \
			2> ${BATS_TMPDIR}/stderr"
    (( ${status} == 0 ))
    echo abc > ${BATS_TMPDIR}/expected
    diff ${BATS_TMPDIR}/output ${BATS_TMPDIR}/expected
}

@test "${CONTEXT} / Input pipe / echo abc | timeout 1 cat #=> abc" {
	run bash -c "\
		echo abc | ${TIMEOUT} 1 cat \
			1>  ${BATS_TMPDIR}/output \
			2> ${BATS_TMPDIR}/stderr"
    (( ${status} == 0 ))
    echo abc > ${BATS_TMPDIR}/expected
    diff ${BATS_TMPDIR}/output ${BATS_TMPDIR}/expected
}

@test "${CONTEXT} / Input redirect / < abc.txt timeout 1 cat #=> abc" {
	echo abc > ${BATS_TMPDIR}/abc.txt
	run bash -c "\
		< ${BATS_TMPDIR}/abc.txt  ${TIMEOUT} 1 cat \
			1>  ${BATS_TMPDIR}/output \
			2> ${BATS_TMPDIR}/stderr"
    (( ${status} == 0 ))
    echo abc > ${BATS_TMPDIR}/expected
    diff ${BATS_TMPDIR}/output ${BATS_TMPDIR}/expected
}

@test "${CONTEXT} / In script / timeout 1 myfunc #=> success" {
	
	if source ${TIMEOUT} ; then
		run bash -c "\
			function myfunc0() { echo a; } ; \
			function myfunc() { myfunc0; } ; \
			source ${TIMEOUT} ; \
			timeout 2 myfunc \
				2> ${BATS_TMPDIR}/stderr"
	    (( ${status} == 0 ))
	    [[ "${output}" == "a" ]]
	else
		skip
	fi
}

