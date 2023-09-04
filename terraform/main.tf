terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  backend "local" {
    path = "/home/alex/SkillFactory/Diplom_project/terraform/infrastructure.tfstate"
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
    ssh-keys = "ubuntu:${file("~/SkillFactory/Diplom_project/.ssh/k8s-master.pub")}"
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
    ssh-keys = "ubuntu:${file("~/SkillFactory/Diplom_project/.ssh/k8s-app.pub")}"
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
    ssh-keys = "ubuntu:${file("~/SkillFactory/Diplom_project/.ssh/srv.pub")}"
  }
}



## Генерируем шаблон
#data "template_file" "ansible_inventory" {
#  template = file("~/SkillFactory/Diplom_project/ansible/inventory.ini.tpl") # Путь до шаблона на локальном компьютере
#  vars = {
#    k8s-master_ip  = var.external_ip_address_k8s-master #external_ip_address_k8s-master
#    k8s-app_ip = var.external_ip_address_k8s-app
#    srv_ip = var.external_ip_address_srv
#  }
#  depends_on = [ yandex_compute_instance.k8s-app, yandex_compute_instance.k8s-master, yandex_compute_instance.srv ]
#}
#
## Записываем сгенерированный шаблон в файл
#resource "null_resource" "update_inventory" {
#  triggers = { # Код будет выполнен, когда inventory будет сгенерирован
#    template = data.template_file.ansible_inventory.rendered
#  }
#  provisioner "local-exec" { # выполняем команду на локальной машине
#    command = "echo '${data.template_file.ansible_inventory.rendered}' > inventory.ini"
#  }
#}