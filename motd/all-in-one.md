
Welcome to the Kayobe "all-in-one" Overcloud Lab!
=================================================

To bootstrap Kayobe all-in-one overcloud without Magnum, run:

    ./all-in-one.sh

To bootstrap Kayobe all-in-one overcloud with Magnum, run:

    ./all-in-one-with-magnum.sh

Once this is complete, use the OpenStack environment as follows:

    source ~/adminrc.sh
    openstack service list

If Magnum was deployed:

    openstack coe cluster list

