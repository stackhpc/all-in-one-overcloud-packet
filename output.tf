output "ips_all_in_one" {
  value = "${
    join("", formatlist(
      "\n    ssh -o PreferredAuthentications=password lab@%s #password: %s",
      packet_device.all_in_one.*.access_public_ipv4,
      packet_device.all_in_one.*.id
  ))}"
}

output "ips_monasca" {
  value = "${
    join("", formatlist(
      "\n    ssh -o PreferredAuthentications=password lab@%s #password: %s",
      packet_device.monasca.*.access_public_ipv4,
      packet_device.all_in_one.*.id
  ))}"
}

output "ansible_inventory" {
  value = <<EOT
.
    [all_in_one]
${join("\n",
       formatlist("    %s ansible_host=%s ansible_user=lab",
                   packet_device.all_in_one.*.hostname,
                   packet_device.all_in_one.*.access_public_ipv4))}
    [monasca]
${join("\n",
       formatlist("    %s ansible_host=%s ansible_user=lab",
                  packet_device.monasca.*.hostname,
                  packet_device.monasca.*.access_public_ipv4))}
EOT
}
