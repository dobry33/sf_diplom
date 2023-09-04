output "internal_ip_address_k8s-master" {
  value = yandex_compute_instance.k8s-master.network_interface.0.ip_address
}
output "internal_ip_address_k8s-app" {
  value = yandex_compute_instance.k8s-app.network_interface.0.ip_address
}
output "internal_ip_address_srv" {
  value = yandex_compute_instance.srv.network_interface.0.ip_address
}

output "external_ip_address_k8s-master" {
  value = yandex_compute_instance.k8s-master.network_interface.0.nat_ip_address
}
output "external_ip_address_k8s-app" {
  value = yandex_compute_instance.k8s-app.network_interface.0.nat_ip_address
}
output "external_ip_address_srv" {
  value = yandex_compute_instance.srv.network_interface.0.nat_ip_address
}
