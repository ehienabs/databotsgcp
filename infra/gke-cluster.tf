# GKE cluster

resource "google_container_cluster" "databots-gke" {
  name     = "${var.project_id}-gke"
  location = var.region
  
  # Tempoary noodepool to bootstrap cluster

  remove_default_node_pool = true
  initial_node_count       = 1

  # Network from our previously create network and subnet

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool

resource "google_container_node_pool" "databots-gke-nodes" {
  name       = "${google_container_cluster.databots-gke.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.databots-gke.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    labels = {
      env = var.project_id
    }

    
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
  }
}
