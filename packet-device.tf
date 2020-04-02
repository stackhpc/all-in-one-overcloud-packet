provider "packet" {
  auth_token = "${var.packet_auth_token}"
}

resource "packet_ssh_key" "default" {
  name       = "default"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "packet_device" "lab" {

  depends_on       = ["packet_ssh_key.default"]

  count            = "${var.lab_count}"
  hostname         = "${format("%s-lab-%02d", var.deploy_prefix, count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.plan}"

  connection {
    user        = "root"
    private_key = tls_private_key.default.private_key_pem
    agent       = false
    timeout     = "30s"
    host        = self.access_public_ipv4
  }

  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"

  provisioner "remote-exec" {
    script = "setup-user.sh"
  }

  provisioner "file" {
    source      = "lab/"
    destination = "/home/lab/"
  }
}
