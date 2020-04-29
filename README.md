# Kayobe all-in-one overcloud on Packet

This Terraform deployment reproduces the instructions for [all-in-one
overcloud](https://docs.openstack.org/kayobe/latest/development/automated.html#overcloud)
workshop on Packet using Kayobe configuration in this
[repository](https://github.com/stackhpc/kayobe-config-dev).

## Software Components

[Kayobe](https://kayobe.readthedocs.io/) enables deployment of containerised
OpenStack to bare metal.

# Instructions for deployment

After cloning this repo,

    cd all-in-one-overcloud-packet    
    cp terraform.tfvars{.sample,}

Edit `terraform.tfvars` with desired options. Note that the `packet_auth_token`
needs to be the user auth token, not the project auth token, otherwise you will
hit strange errors. This can be obtained by clicking the user icon on the top
right hand corner on https://app.packet.net and choose API Keys in the menu.

Additionally, to enable standalone Monasca, set `standalone_monasca = true`
(false by default). This deploys a second VM for each lab machine which
authenticates against Keystone service running in the all-in-one deployment.

Next up is the `terraform` bit assuming it is already installed:

    terraform init
    terraform plan
    terraform apply -auto-approve

To reprovision an `all_in_one` machine:

    terraform taint "packet_device.all_in_one[0]"
    terraform taint "null_resource.all_in_one_provisioner[0]"
    terraform apply -auto-approve

Similarly, to reprovision a `monasca` machine:

    terraform taint "packet_device.monasca[0]"
    terraform taint "null_resource.monasca_provisioner[0]"
    terraform apply -auto-approve

To destroy the machines:

    terraform destroy

# Instructions for lab users

## Logging in

SSH in to your lab instance by running and entering the provided password:

    ssh lab@<lab-ip-address> -o PreferredAuthentications=password

## Nested virtualisation

Make sure that nested virtualisation is enabled on the host:

    egrep --color 'vmx|svm' /proc/cpuinfo

Look for **vmx** or **svm** coloured red in the output.

## Instructions for deployment

You will see instruction to complete the all-in-one or standalone monasca setup
when you log into the machines. Alternatively, look inside the [lab](lab/)
folder for deployment scripts and the [motd](motd/) folder for instructions.

# Wrapping up

Join the discussion at `#openstack-kolla` channel on IRC.

