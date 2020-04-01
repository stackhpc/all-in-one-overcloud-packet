output "lab_ips" {
  value = "${
    join("", formatlist(
      "\n    ssh -o PreferredAuthentications=password lab@%s",
      packet_device.lab.*.access_public_ipv4
  ))}"
}

output "ansible_inventory" {
  value = "${
    join("", formatlist(
      "\n    %s ansible_host=%s ansible_user=lab",
      packet_device.lab.*.hostname,
      packet_device.lab.*.access_public_ipv4
  ))}"
}
