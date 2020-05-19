
Welcome to the Kayobe standalone Monasca Lab!
=============================================

To bootstrap Kayobe with standalone Monasca, run:

    ./standalone-monasca.sh

There is a good chance this script is already running. To view progress:

    tmux attach    # or tail -f ~/stack.out

Once this is complete, use the OpenStack environment as follows:

    source ~/adminrc.sh
    openstack service list

