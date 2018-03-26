usage () {
    echo "Usage: bash permissionstore-generator.sh -s {scope name} -g {comma separated groups} " 1>&2;
    exit 1;
}
writeToFile () {
    echo "# start of a permission section" >> ${1}
    echo "[${2}]" >> ${1}
    echo "groups=\"${3}\"" >> ${1}
    echo "# end of a permission section" >> ${1}
    echo "" >> ${1}
    echo "permissionstore updated successfully with details of scope: ${2}"
}
while getopts "s:g:" input; do
    case "${input}" in
        s)
            scope=${OPTARG}
            ;;
        g)
            groups=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
if [ -z "${scope}" ] || [ -z "${groups}" ]; then
    usage
fi
writeToFile "ballerina.conf" "${scope}" "${groups}"

