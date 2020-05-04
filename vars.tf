
# set via environment variable TF_VAR_packet_project_id
variable "packet_project_id" {
  description = "Packet Project ID"
}

# set via environment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet API Token"
}

variable "packet_facility" {
  description = "Packet facility. Default: ewr1"
  default     = "ewr1"
}

variable "plan" {
  description = "Instance type"
  default     = "c1.small.x86"
}

variable "lab_count" {
  description = "Number of labs"
  default     = 0
}

variable "standalone_monasca" {
  description = "Whether to enable standalone monasca or not"
  default     = false
}

variable "operating_system" {
  description = "Operating System to install across nodes"
  default     = "centos_8"
}

variable "deploy_prefix" {
  description = "prefix to add to all hosts created under this deployment"
  default     = "kayobe"
}

variable "lab_repo_url" {
  description = "URL of this Git repository to clone on remote machines"
  default     = "https://github.com/stackhpc/all-in-one-overcloud-packet"
}

variable "lab_repo_branch" {
  description = "Branch of this Git repository to clone on remote machines"
  default     = "master"
}
