# sf_diplom
<h1 align="center">Terraform</h1>
                           
## Перед тем, как начать применять конфигурацию terraform вам понадобится:

-  **создать пару ssh-ключей для каждой виртуальной машины с названиями k8s-master, k8s-app, srv, сохраните их в директории .ssh проекта**
-  **узнать свой OAuth-токен яндекса**
-  **cloud_id,  folder_id в yandex cloud**
  
## Укажите путь до ssh ключей в соответствующих параметрах вм в файле main.tf

## Создайте файл с переменными token, cloud_id,  folder_id

## Примените конфигурацию из директории terraform:

`terraform apply`

<h1 align="center">Ansible</h1>

## Впишите ip-адреса созданных вм в файл hosts.ini

## Проверьте подключение по ssh до каждой вм

## Примените плейбуки в следующем порядке

`ansible-playbook kube-dependencies.yml `

`ansible-playbook master.yml `

`ansible-playbook workers.yml` 

`ansible-playbook srv.yml`