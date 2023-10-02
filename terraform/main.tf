terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  backend "local" {
    path = "infrastructure.tfstate"
  }
}
provider "yandex" {
  token                    = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "diplom"{
    name = "diplom"
}

resource "yandex_vpc_subnet" "subnet-1"{
    name            = "subnet1"
    zone            = "ru-central1-a"
    network_id      = yandex_vpc_network.diplom.id
    v4_cidr_blocks  = ["10.10.10.0/24"]
}
resource "yandex_compute_instance" "k8s-master" {
  name = "k8s-master"
  hostname = "k8s-master"
  resources {
    cores = 2
    memory = 4
  }
  boot_disk {
     initialize_params {
      image_id = "fd8fco5lpqbhanbfg2du" # ubuntu 22.04 LTS
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("../.ssh/k8s-master.pub")}"
  }
}

resource "yandex_compute_instance" "k8s-app" {
  name = "k8s-app"
  hostname = "k8s-app"
  resources {
    cores = 2
    memory = 2
  }
  boot_disk {
     initialize_params {
      image_id = "fd8fco5lpqbhanbfg2du" # ubuntu 22.04 LTS
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("../.ssh/k8s-app.pub")}"
  }
}

resource "yandex_compute_instance" "srv" {
  name = "srv"
  hostname = "srv"
  resources {
    cores = 2
    memory = 4
  }
  boot_disk {
     initialize_params {
      image_id = "fd8fco5lpqbhanbfg2du" # ubuntu 22.04 LTS
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("../.ssh/srv.pub")}"
  }
}
