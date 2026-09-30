# Лабораторная работа №4

## Задание

<https://ex-itmo-ict-faculty.github.io/network-programming/education/labs2023_2024/lab4/lab4/>

### Подготовка среды

Были установлены все необходимые утилиты:

![Downloads](images/Screenshot_3.png)

Был склонирован репозиторий с упражнениями:

```bash
git clone https://github.com/p4lang/tutorials.git
cd tutorials/vm-ubuntu-24.04
vagrant up
```

Далее на самой виртуалке подготовил систему:

```bash
cd
git clone https://github.com/p4lang/tutorials
./tutorials/vm-ubuntu-24.04/install.sh |& tee log.txt
source ~/p4setup.bash
```

### Basic Forwarding

Перешел в папку первого упражнения:

```bash
cd ~/tutorials/exercises/basic
```

В файл `basic.p4` была добавлена логика разбора Ethernet/IPv4, таблица `ipv4_lpm`, действие `ipv4_forward` и deparser. Исправленный файл также сохранен в репозитории лабораторной: [basic.p4](./basic.p4).

Сначала добавил логику для парсера:

![MyParser](images/Screenshot_5.png)

Далее добавил ip forward:

![IpForward](images/Screenshot_6.png)

А также изменил deparser:

![Deparser](images/Screenshot_7.png)

Запуск:

```bash
make run
```

Проверка связности в Mininet:

![pingall](images/Screenshot_8.png)

После проверки Mininet был остановлен:

```bash
make stop
make clean
```

### Basic Tunneling

Перешел в папку второго упражнения:

```bash
cd ~/tutorials/exercises/basic_tunnel
```

В `basic_tunnel.p4` была добавлена поддержка собственного заголовка `myTunnel`, разбор `etherType = 0x1212`, таблица точного совпадения `myTunnel_exact` и deparser, который выпускает заголовки в порядке `ethernet`, `myTunnel`, `ipv4`. Исправленный файл сохранен в репозитории лабораторной: [basic_tunnel.p4](./basic_tunnel.p4).

Сначала изменил парсер:

![MyParser](images/Screenshot_13.png)

Далее основная логика:

![TunnelForward](images/Screenshot_14.png)

Добавил строчку в Deparser:

![Downloads](images/Screenshot_15.png)

Статические правила управления из `s1-runtime.json`, `s2-runtime.json`, `s3-runtime.json` используют таблицу `MyIngress.myTunnel_exact` и сопоставляют `dst_id` с выходным портом. Например:

![Downloads](images/Screenshot_16.png)

Запуск:

```bash
make run
```

P4-программа успешно скомпилировалась:

```bash
p4c-bm2-ss --p4v 16 --p4runtime-file build/basic_tunnel.p4info --p4runtime-format text -o build/basic_tunnel.json basic_tunnel.p4
```

Проверка обычной IP-маршрутизации без туннеля:

```bash
mininet> xterm h1 h2
```

В терминале `h2`:

```bash
./receive.py
```

В терминале `h1`:

```bash
./send.py 10.0.2.2 plain-ip
```

Результат на `h2`:

![Recieve H2](./images/Screenshot_10.png)

Проверка туннелирования:

```bash
./send.py 10.0.2.2 tunnel-to-h2 --dst_id 2
```

Результат на `h2`:

![Tunnel H2](./images/Screenshot_11.png)

Проверка того, что при наличии `myTunnel` маршрутизация выполняется по `dst_id`, а не по IP-адресу назначения:

```bash
./send.py 10.0.3.3 tunnel-ip-h3-dstid2 --dst_id 2
```

Результат на `h2`:

![Tunnel H2 with H3 IP](./images/Screenshot_12.png.png)

Пакет пришел на `h2`, хотя IP-адрес `10.0.3.3` принадлежит `h3`. Это подтверждает, что для инкапсулированных пакетов коммутатор использует поле `dst_id` из заголовка `myTunnel`.

После проверки Mininet был остановлен:

```bash
make stop
make clean
```

## Заключение

В ходе лабораторной работы была подготовлена среда для запуска P4-упражнений. В первом упражнении реализована базовая IPv4-коммутация: парсинг Ethernet/IPv4, LPM-таблица, изменение MAC-адресов, уменьшение TTL и выпуск пакета через нужный порт. Во втором упражнении реализовано туннелирование с собственным заголовком `myTunnel` и отдельной таблицей forwarding по `dst_id`. Проверки `pingall` и отправки сообщений через `send.py`/`receive.py` подтвердили локальную связность и корректную обработку туннелированных пакетов. Цель работы достигнута.
