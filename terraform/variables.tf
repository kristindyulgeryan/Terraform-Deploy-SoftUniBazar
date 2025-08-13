variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created."

}

variable "dotnet_version" {
  description = "The version of .Net to be used in the Linux web app."
  type        = string

}

variable "mssql_server_name" {
  description = "The name of the MSSQL server."
  type        = string

}

variable "location" {
  description = "The Azure location for all resources"
  type        = string

}
