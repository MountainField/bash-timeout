#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# =================================================================
# bash-timeout
#
# Copyright (c) 2018 Takahide Nogayama
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
# =================================================================

THIS_DIR=$(cd $(dirname $BASH_SOURCE); pwd)

#######################
export CONTEXT="bash-timeout command"
export TIMEOUT=${THIS_DIR}/../bin/bash-timeout

bats ${THIS_DIR}/test_bash-timeout.bats

#######################
export CONTEXT="timeout function "
source ${THIS_DIR}/../bin/bash-timeout
export TIMEOUT=timeout

bats ${THIS_DIR}/test_bash-timeout.bats
