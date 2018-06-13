#!/usr/bin/env bash
# HDX DB Manager
# ==============
if [[ "$1" == "-h" || "$1" == "--help" || ! ${1+x} ]]; then cat <<HELP
Manage Databases

Usage: $(basename "$0") [command]

    size [database]     Gets size of database

You are required to give your root password

Copyright (c) 2018 "FROSIT" Fabio Ros
Licensed under the MIT license.
http://frosit.nl
HELP
exit; fi

# Variables (@todo finalise variable names afterwards)
_source=${DEST_PATH:-/data/web/public}
_mversion=${MAGE_VER:-1} # autodetect?
_backupPath=/data/web/shared
_backupFile=${DB_FILE:-latest.sql}

# Set arg
arg=$1;shift


# Auto select right magerun version for import/export
# @todo needs more testing
_magerun(){
    if [ $_mversion == 1 ]; then
        local mr=n98-magerun
    else
        local mr=n98-magerun2
    fi

    ${mr} --root-dir="${_source}" $@
}

# Drop database if exists
_dropdb(){
    if [ -d "/data/mysql/${1}" ]; then
        mysql -e "drop database ${1};"
        echo -e "dropping database ${1};"
    fi
}

# Create database if not exists
_createdb(){
    if [ ! -d "/data/mysql/${1}" ]; then
        mysql -e "create database ${1};"
        echo -e "Created database ${1}"
    fi
}

# Import database
_importdb(){
    echo -e "Importing ${1}"
    if [[ ${1} =~ \.gz$ ]]; then
        pv ${1} | gunzip | mysql ${DB_NAME:-magento}
    else
        pv ${1} | mysql ${DB_NAME:-magento}
    fi
}


####
# Get database size
# ARG:
#   -  dbname
####
function size(){
    size=$(mysql -e "SELECT
    round(Sum(data_length + index_length) / 1024 / 1024, 1)  as \"Size in MB\"
    FROM information_schema.TABLES
    WHERE table_schema = '${1}'")
    echo -e ${size}
}


####
# Export database as latest
####
function export-latest(){

    # Create path if not exists
    if [ ! -d ${_backupPath} ]; then
        mkdir -p ${_backupPath}
    fi

    # If file exists
    local _absFilePath="${_backupPath}/${_backupFile}"
    if [[ -f "${_absFilePath}" ]]; then
        echo -e "Found file at ${_absFilePath}, moving it"
        local _timeSec=$(stat -c %Y ${_absFilePath})
        mv ${_absFilePath} "${_backupPath}/${_timeSec}-${_backupFile}"
        gzip "${_backupPath}/${_timeSec}-${_backupFile}"
    fi

    _magerun db:dump --strip=@stripped "${_absFilePath}"
}


####
# Import latest
####
function import-latest(){
    if [ -f ${_backupFile} ]; then
        _importdb ${_backupFile}
    else
        if [ -f "${_backupFile}.gz" ]; then
            _importdb "${_backupFile}.gz"
        else
            echo -e "Can't find dump at ${_backupFile}, aborting"
            exit
        fi
    fi
}

${arg%%/} $@