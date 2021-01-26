variable "vsphere_server" {
  description   = "Hostname or IP of vCenter"
  default       = ""
}

variable "vsphere_username" {
  description   = "Username for vCenter, remember SSO domain"
  default       = ""
}

variable "vsphere_password" {
  description   = "Password for vCenter"
  default       = ""
}

variable "esxi_server" {
  description   = "Hostname or IP of ESXI"
  default       = ""
}

variable "esxi_username" {
  description   = "Username for ESXI"
  default       = ""
}

variable "esxi_password" {
  description   = "Password for ESXI"
  default       = ""
}

variable "esxi_thumbprint" {
  description   = "Certificate thumbprint for ESXI host, only needed if unsecure"
  default       = ""
}

variable "datastore_hdd_id" {
  description   = "ID physical harddrive"
  default       = ""
}

variable "public_key" {
  description   = "Public key"
  default       = ""
}
