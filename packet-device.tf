provider "packet" {
  auth_token = "${var.packet_auth_token}"
}

resource "packet_ssh_key" "default" {
  name       = "default"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "packet_device" "all_in_one" {

  depends_on = ["packet_ssh_key.default"]

  count            = "${var.lab_count}"
  hostname         = "${format("%s-all-in-one-%02d", var.deploy_prefix, count.index)}"
  operating_system = "${var.operating_system}"
  plan             = "${var.plan}"

  facilities    = ["${var.packet_facility}"]
  project_id    = "${var.packet_project_id}"
  billing_cycle = "hourly"
}

resource "packet_device" "monasca" {

  depends_on = ["packet_ssh_key.default"]

  count            = var.lab_count
  hostname         = "${format("%s-monasca-%02d", var.deploy_prefix, count.index)}"
  operating_system = var.operating_system
  plan             = var.plan

  facilities    = [var.packet_facility]
  project_id    = var.packet_project_id
  billing_cycle = "hourly"
}
