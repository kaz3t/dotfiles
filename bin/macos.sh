#!/usr/bin/env bash

declare -r PROJECTS_DIR=~/projects

if [[ ! -d ${PROJECTS_DIR} ]]; then
    mkdir ${PROJECTS_DIR};
fi;
