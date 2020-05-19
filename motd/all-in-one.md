
Welcome to the Kayobe "all-in-one" Overcloud Lab!
=================================================

To bootstrap Kayobe all-in-one overcloud without Magnum manually, run:

    ./all-in-one.sh

To bootstrap Kayobe all-in-one overcloud with Magnum manually, run:

    ./all-in-one-with-magnum.sh

There is a good chance one of these scripts is already running. To view progress:

    tmux attach    # or tail -f ~/stack.out

Once this is complete, use the OpenStack environment as follows:

    source ~/adminrc.sh
    openstack service list

If Magnum was deployed:

    source ~/labrc.sh
    openstack coe cluster list

