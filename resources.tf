resource "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

resource "vsphere_host" "host" {
  hostname    = var.esxi_server
  username    = var.esxi_username
  password    = var.esxi_password
  datacenter  = vsphere_datacenter.datacenter.moid
  thumbprint  = "30:CB:1D:7B:25:A9:9E:62:8D:EE:6E:2B:4B:9B:84:7A:89:C6:49:19"
}

data "vsphere_resource_pool" "pool" {
  # Resources is the invisible pool of the ESXI host
  name          = "Resources"
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.host]
}

data "vsphere_vmfs_disks" "hdd" {
  host_system_id  = vsphere_host.host.id
  filter          = "(t10.ATA_____WDC_WD40EFRX2D68WT0N0_________________________WD2DWCC4E0206479)"
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
  name           		= "NAS"
  host_system_id 		= vsphere_host.host.id
  network_adapters 	= ["vmnic3"]
  active_nics       = []
  standby_nics      = []
}

data "vsphere_network" "vm_services" {
  name          = "VM-Services"
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.host]
}

resource "vsphere_virtual_machine" "services_docker1" {
  name                = "service-docker1"
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  datastore_id        = data.vsphere_datastore.datastore1.id
  num_cpus            = 2
  memory              = 2048
  guest_id            = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.vm_services.id
  }
  disk {
    label = "disk0"
    size  = 50
  }
  cdrom {
    datastore_id = data.vsphere_datastore.datastore1.id
    path         = "ISO/ubuntu-20.04-live-server-amd64.iso"
  }
}
