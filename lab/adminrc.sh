pushd `dirname ${BASH_SOURCE[0]}`

[[ -d venv ]] || virtualenv venv
source venv/bin/activate
pip install -qr requirements.txt
source kayobe/config/src/kayobe-config/etc/kolla/admin-openrc.sh

popd
