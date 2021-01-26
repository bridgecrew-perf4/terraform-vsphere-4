resource "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

resource "vsphere_host" "host" {
  hostname    = var.esxi_server
  username    = var.esxi_username
  password    = var.esxi_password
  datacenter  = vsphere_datacenter.datacenter.moid
  thumbprint  = var.esxi_thumbprint
}

data "vsphere_resource_pool" "pool" {
  # Resources is the invisible pool of the ESXI host
  name          = "Resources"
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.host]
}

data "vsphere_vmfs_disks" "hdd" {
  host_system_id  = vsphere_host.host.id
  filter          = var.datastore_hdd_id
  depends_on      = [vsphere_host.host]
}

data "vsphere_datastore" "datastore1" {
  name          = "datastore1"
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.host]
}

resource "vsphere_vmfs_datastore" "datastore2" {
  name            = "datastore2"
  host_system_id  = vsphere_host.host.id
  disks           = [data.vsphere_vmfs_disks.hdd.disks[0]]
}

resource "vsphere_host_virtual_switch" "nas" {
  name              = "NAS"
  host_system_id    = vsphere_host.host.id
  network_adapters  = ["vmnic3"]
  active_nics       = []
  standby_nics      = []
}

resource "vsphere_host_port_group" "vm_lab" {
  name                = "VM-Lab"
  host_system_id      = vsphere_host.host.id
  virtual_switch_name = "VM"
  vlan_id							= 50
}

data "vsphere_network" "vm_services" {
  name          = "VM-Services"
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.host]
}

resource "vsphere_virtual_machine" "services_docker1" {
  name                = "services-docker1"
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  datastore_id        = data.vsphere_datastore.datastore1.id
  datacenter_id       = vsphere_datacenter.datacenter.moid	
  host_system_id			= vsphere_host.host.id
#	wait_for_guest_net_timeout	= 0
#  wait_for_guest_ip_timeout		= 0
	network_interface {
    network_id = data.vsphere_network.vm_services.id
  }
  cdrom {
    client_device = true
  }
	ovf_deploy {
    remote_ovf_url    = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
    disk_provisioning = "thin"
  }
  vapp {
    properties = {
      hostname    = "services-docker1"
      password    = "test"
      public-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJa28VuIjJF74nsbxy5KsqxulbONGjdi4IwWrW8Rd/+BewVWSg8QD70ChaeS/IoAUzYqQ5GhcjRmiHeXVad2muTJOznQnEkR0qq4PRtSEgLUkwH1OAQWJ8CKWXVFX1ulnN+DawdLXbd5QMdDhzGAxD9TTNCDcgtZrdbySXRt+OvWijw5GAXR5wktqeopZ2IeOfUKDUlqBMWenNPx1cTQI28cEDGiRMTlHy6w9WAw/5YM0PG0r1xFxjGhye8vTBnnis5ANdtJADBg2ilOJ0miKIPqa8aOICfk6sj62aFUCrqVpZN2GqtB6+o+quEz2WhlFrVgc+fS+g+yqem0a3xDSH lheia@DESKTOP-BEKKPGR"
#      user-data = base64encode(file("cloud-init.yml"))
    }
  }
}
