
# Custom VPC


resource "google_compute_network" "custom_vpc" {

  name                    = var.vpc_name

  auto_create_subnetworks = false

  routing_mode            = var.routing_mode

  project                 = var.project_id
}


# Public Subnet


resource "google_compute_subnetwork" "public_subnet" {

  name          = var.public_subnet_name

  ip_cidr_range = var.public_subnet_cidr

  region         = var.region

  network        = google_compute_network.custom_vpc.id

  project         = var.project_id

  private_ip_google_access = false

  dynamic "log_config" {

    for_each = var.enable_flow_logs ? [1] : []

    content {

      aggregation_interval = "INTERVAL_5_SEC"

      flow_sampling = 0.5

      metadata = "INCLUDE_ALL_METADATA"

    }

  }

}


# Private Subnet


resource "google_compute_subnetwork" "private_subnet" {

  name = var.private_subnet_name

  ip_cidr_range = var.private_subnet_cidr

  region = var.region

  network = google_compute_network.custom_vpc.id

  project = var.project_id

  private_ip_google_access = true

  dynamic "log_config" {

    for_each = var.enable_flow_logs ? [1] : []

    content {

      aggregation_interval = "INTERVAL_5_SEC"

      flow_sampling = 0.5

      metadata = "INCLUDE_ALL_METADATA"

    }

  }

}
