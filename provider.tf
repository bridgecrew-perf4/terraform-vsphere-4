terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.24.3"
    }
  }
}

provider "vsphere" {
  vsphere_server        = var.vsphere_server
  user                  = var.vsphere_username
  password              = var.vsphere_password
  allow_unverified_ssl  = true	
}
