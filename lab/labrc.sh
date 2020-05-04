pushd `dirname ${BASH_SOURCE[0]}` > /dev/null

source adminrc.sh
export OS_USERNAME=lab
export OS_PROJECT_NAME=lab
export OS_TENANT_NAME=$OS_PROJECT_NAME

popd > /dev/null
