#!/usr/bin/env bash

request=""

## uses openssl aes 256 cbc encryption to encrypt file salting it with password designated by user
encrypt() {
    echo "Encrypting $1..."
    openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -a -in $1 -out $2 || { echo "File not found"; return 1; }
    echo "Successfully encrypted"
}

## uses openssl aes 256 cbc decryption to decrypt file
decrypt() {
    echo "Decrypting $1..."
    openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 -a -in $1 -out $2 || { echo "File not found"; return 1; }
    echo "Successfully decrypted"
}

checkOpenSSL() {
    if  ! command -v openssl &>/dev/null; then
        echo "Error: to use this tool openssl must be installed" >&2
        return 1
    else
        return 0
    fi
}

checkOpenSSL || exit 1

while getopts "e:d:" opt; do
    case $opt in
        e)  # Argument used for encryption
            if [[ $request != "decrypt" ]]; then
                state="encrypt"
            else
                echo "Error: the -d and -e options are mutally exclusive" >&2
                exit 1
            fi
            if [[ $# -ne 3 ]]; then
                echo "Option -e needs and only accepts two arguments [file to encrypt] [output file]" >&2
                exit 1
            fi
            ;;
        \?) echo "Invalid option: -$OPTARG" >&2 # For other invalid options
            exit 1
            ;;
        d)  # Argument used for decryption
            if [[ $request != "encrypt" ]]; then
                state="decrypt"
            else
                echo "Error: the -e and -d options are mutally exclusive" >&2
                exit 1
            fi
            if [[ $# -ne 3 ]]; then
                echo "Option -d needs and only accepts two arguments [file to decrypt] [output file]" >&2
                exit 1
            fi
            ;;
        :)  ## will run when no arguments are provided to to e or d options
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ $# == 0 ]]; then
    echo -e "You must use at least one argument! Try again."
    exit 1
elif [[ $request == "encrypt" ]]; then
    encrypt $2 $3 || exit 1
    exit 0
elif [[ $request == "decrypt" ]]; then
    decrypt $2 $3 || exit 1
    exit 0
fi
