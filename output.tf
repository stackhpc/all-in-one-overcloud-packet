output "ips_all_in_one" {
  value = "${
    join("", formatlist(
      "\n    %s (password: %s) ssh lab@%s",
      packet_device.all_in_one.*.hostname,
      packet_device.all_in_one.*.id,
      packet_device.all_in_one.*.access_public_ipv4,
  ))}"
}

output "ips_monasca" {
  value = "${local.monasca_lab_count > 0 ?
    join("", formatlist(
      "\n    %s (password: %s) ssh lab@%s",
      packet_device.monasca.*.hostname,
      packet_device.all_in_one.*.id,
      packet_device.monasca.*.access_public_ipv4,
  )) : ""}"
}

output "ips_ssh_arg" {
  value = "You may need -o PreferredAuthentications=password argument."
}
output "inventory_all_in_one" {
  value = "${
    join("",
      formatlist("\n    %s ansible_host=%s ansible_user=lab",
        packet_device.all_in_one.*.hostname,
  packet_device.all_in_one.*.access_public_ipv4))}"
}

output "inventory_monasca" {
  value = "${
    join("",
      formatlist("\n    %s ansible_host=%s ansible_user=lab",
        packet_device.monasca.*.hostname,
  packet_device.monasca.*.access_public_ipv4))}"
}
