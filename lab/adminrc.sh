[[ -d ~/venv ]] || virtualenv ~/venv
source ~/venv/bin/activate
pip install -qr ~/requirements.txt
source ~/kayobe/config/src/kayobe-config/etc/kolla/public-openrc.sh
