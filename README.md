# Домашнее задание к занятию "`Disaster recovery и Keepalived`" - `Одинаев Джиеншах`

### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.
![Задание_1_screen](./img/Disaster_recovery_Keepalived_ex1.png)

[Схема](./upload/hsrp_advanced_done.pkt)
------


### Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

**MASTER (ubuntu)**

```
global_defs {
  script_user root
  enable_script_security
}

vrrp_script check_status {
  script "/etc/keepalived/check_status.sh"
  interval 3
}

vrrp_instance VI_1 {
  state MASTER
  interface enp0s3
  virtual_router_id 15
  priority 255
  advert_int 1

  virtual_ipaddress {
    192.168.0.15
  }

  track_script {
    check_status
  }
}

```

**BACKUP (centos)**

```
global_defs {
  script_user root
  enable_script_security
}

vrrp_script check_status {
  script "/etc/keepalived/check_status.sh"
  interval 3
}

vrrp_instance VI_1 {
  state BACKUP
  interface enp0s3
  virtual_router_id 15
  priority 250
  advert_int 1

  virtual_ipaddress {
    192.168.0.15
  }

  track_script {
    check_status
  }
}

```

**Скрипт (ubuntu)**
```
#!/bin/bash

test -f /var/www/html/index.html
PAGE=$?

bash -c "</dev/tcp/localhost/80" >/dev/null 2>&1
PORT=$?

if [ "$PAGE" -eq 0 ] && [ "$PORT" -eq 0 ]; then
    exit 0
else
    exit 1
fi
```

**Скрипт (centos)**
```
#!/bin/bash

test -f /usr/share/nginx/html/index.html
PAGE=$?

bash -c "</dev/tcp/localhost/80" >/dev/null 2>&1
PORT=$?

if [ "$PAGE" -eq 0 ] && [ "$PORT" -eq 0 ]; then
    exit 0
else
    exit 1
fi

```

![Задание_2_screen](./img/Disaster_recovery_Keepalived_ex2.png)
------