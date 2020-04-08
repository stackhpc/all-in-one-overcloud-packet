/* THE FOLLOWING IS REQUIRED IN ORDER TO AVOID CIRCULAR
   DEPENDENCY AND ENABLE CONCURRENT MACHINE PROVISIONING */

resource "null_resource" "all_in_one_provisioner" {

  count = var.lab_count

  triggers = {
    local = packet_device.all_in_one[count.index].id
    remote = packet_device.monasca[count.index].id
  }

  connection {
    user        = "root"
    private_key = tls_private_key.default.private_key_pem
    agent       = false
    timeout     = "30s"
    host        = packet_device.all_in_one[count.index].access_public_ipv4
  }

  provisioner "remote-exec" {
    script = "setup-user.sh"
  }

  provisioner "file" {
    source      = "motd/all-in-one"
    destination = "/etc/motd"
  }

  provisioner "file" {
    source      = "lab/"
    destination = "/home/lab/"
  }

  provisioner "remote-exec" {
    inline = [
      "echo export LOCAL_IP=${packet_device.all_in_one[count.index].access_public_ipv4} > /home/lab/labip.sh",
      "echo export REMOTE_IP=${packet_device.monasca[count.index].access_public_ipv4} >> /home/lab/labip.sh",
      "chmod +x /home/lab/*.sh",
      "chown lab:lab /home/lab/*.sh",
    ]
  }
}

resource "null_resource" "monasca_provisioner" {

  count = var.lab_count

  triggers = {
    local = packet_device.monasca[count.index].id
    remote = packet_device.all_in_one[count.index].id
  }

  connection {
    user        = "root"
    private_key = tls_private_key.default.private_key_pem
    agent       = false
    timeout     = "30s"
    host        = packet_device.monasca[count.index].access_public_ipv4
  }

  provisioner "remote-exec" {
    script = "setup-user.sh"
  }

  provisioner "file" {
    source      = "motd/monasca"
    destination = "/etc/motd"
  }

  provisioner "file" {
    source      = "lab/"
    destination = "/home/lab/"
  }

  provisioner "remote-exec" {
    inline = [
      "echo export LOCAL_IP=${packet_device.monasca[count.index].access_public_ipv4} > /home/lab/labip.sh",
      "echo export REMOTE_IP=${packet_device.all_in_one[count.index].access_public_ipv4} >> /home/lab/labip.sh",
      "chmod +x /home/lab/*.sh",
      "chown lab:lab /home/lab/*.sh",
    ]
  }
}
