terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    linode = {
      source = "linode/linode"
      version = "2.31.1"
    }
   
  }
}

resource "random_string" "workspace_id" {
  length           = 5
  min_numeric      = 1
  special          = false
  upper            = false
}
resource "linode_nodebalancer" "talos" {
    label = "${var.name}_${random_string.workspace_id.id}"
    region = var.region
    client_conn_throttle = 20
    tags = ["talos"]
    }

resource "linode_nodebalancer_config" https-traffic {
    nodebalancer_id = linode_nodebalancer.talos.id

    port = 443
    protocol = "tcp"
    algorithm = "roundrobin"
    check = "connection"
    check_interval = 31
    check_timeout = 30
    check_attempts = 3
    check_passive = false
    stickiness = "none"
    
}

resource "linode_nodebalancer_node" "talosnode-https" {
    count = length(var.instances_ip) 
    nodebalancer_id = linode_nodebalancer.talos.id
    config_id = linode_nodebalancer_config.https-traffic.id
    address = "${var.instances_ip[count.index]}:6443"
    label = "talos"
    weight = 50
    mode = "accept"
}

resource "linode_nodebalancer_config" talos-50000 {
    nodebalancer_id = linode_nodebalancer.talos.id
    port = 50000
    protocol = "tcp"
    algorithm = "roundrobin"
    check = "connection" 
    check_interval = 31
    check_timeout = 30
    check_attempts = 3
    check_passive = false

    stickiness = "none"
    
}
resource "linode_nodebalancer_node" "talosnode-50000" {
    count = length(var.instances_ip) 
    nodebalancer_id = linode_nodebalancer.talos.id
    config_id = linode_nodebalancer_config.talos-50000.id
    address = "${var.instances_ip[count.index]}:50000"
    label = "talos"
    weight = 50
 
}


