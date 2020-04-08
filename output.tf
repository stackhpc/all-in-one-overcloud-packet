output "all_in_one_ips" {
  value = "${
    join("", formatlist(
      "\n    ssh -o PreferredAuthentications=password lab@%s",
      packet_device.all_in_one.*.access_public_ipv4
  ))}"
}

output "monasca_ips" {
  value = "${
    join("", formatlist(
      "\n    ssh -o PreferredAuthentications=password lab@%s",
      packet_device.monasca.*.access_public_ipv4
  ))}"
}

output "all_in_one_ansible_inventory" {
  value = "${
    join("", formatlist(
      "\n    %s ansible_host=%s ansible_user=lab",
      packet_device.all_in_one.*.hostname,
      packet_device.all_in_one.*.access_public_ipv4
  ))}"
}

output "monasca_ansible_inventory" {
  value = "${
    join("", formatlist(
      "\n    %s ansible_host=%s ansible_user=lab",
      packet_device.monasca.*.hostname,
      packet_device.monasca.*.access_public_ipv4
  ))}"
}
