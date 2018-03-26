usage () {
    echo "Usage: bash userstore-generator.sh -u {username} -p {password} -g {comma separated groups} " 1>&2;
    exit 1;
}
generateUid () {
    echo -n ${1} | shasum -a 1 | awk '{print $1}'
}
generateHash () {
    echo -n ${1} | shasum -a 256 | awk '{print toupper($1)}'
}
writeToFile () {
    echo "# start of a user section" >> ${1}
    echo "[${2}]" >> ${1}
    echo "userid=\"${3}\"" >> ${1}
    echo "[${3}]" >> ${1}
    echo "password=\"${4}\"" >> ${1}
    if [[ ! -z ${5} ]]; then
        echo "groups=\"${5}\"" >> ${1}
    fi
    echo "# end of a user section" >> ${1}
    echo "" >> ${1}
    echo "userstore updated successfully with details of user: ${2}"
}
while getopts "u:p:g:" input; do
    case "${input}" in
        u)
            username=${OPTARG}
            ;;
        p)
            password=${OPTARG}
            ;;
        g)
            groups=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
if [ -z "${username}" ] || [ -z "${password}" ]; then
    usage
fi
writeToFile "ballerina.conf" "${username}" "$(generateUid ${username})" "$(generateHash ${password})" "${groups}"

