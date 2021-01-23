variable "vsphere_server" {
  description   = "Hostname or IP of vsphere or vcenter"
  default       = ""
}

variable "vsphere_username" {
  description   = "Username for vsphere or vcenter, remember SSO domain if vcenter"
  default       = ""
}

variable "vsphere_password" {
  description   = "Password for vsphere or vcenter"
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
