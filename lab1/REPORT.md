# Лабораторная работа №1

## Задание

<https://itmo-ict-faculty.github.io/network-programming/education/labs2023_2024/lab1/lab1/>


### VM

![VM](images/vm.png)

![ansible](images/ansible.png)

### VPN-сервер

Установка пакетов:

```bash
sudo apt update
sudo apt install wireguard
sudo apt install iptables-persistent
```

Генерация ключей:

```bash
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee client_private.key | wg pubkey > client_public.key
```

Настройка /etc/wireguard/wg0.conf

![/etc/wireguard/wg0.conf](images/Screenshot_8.png)


Запуск сервера:

![Server_wg0_start](images/Screenshot_9.png)

### VPN-клиент

![Server_wg0_start](images/Screenshot_10.png)

### Тест

Ping с сервера на роутер и наоборот:

![Ping](images/server-router-ping.png)

## Заключение

В результате выполнения лабораторной работы была проведена установка CHR и Ansible, настройка VPN Wireguard.
