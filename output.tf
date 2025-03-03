output "id" {
  value = "${linode_nodebalancer.talos.id}"
}

output "nb_ip_address" {
  value = "${linode_nodebalancer.talos.ipv4}"
}