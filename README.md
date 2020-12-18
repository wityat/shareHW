# shareHW



Запуск

Чтобы собрать и запустить контейнер с моим решением, достаточно выполнить следующие команды:

### Запуск
Чтобы собрать и запустить контейнер с моим решением, достаточно выполнить следующие команды:
```shell
docker build --tag sharehw .
docker run -p 80:80 -p 445:445 sharehw
```
В Docker-контейнерах нет systemd или другой полноценно работающей системы инициализации и управления службами, поэтому сервисы при старте контейнера приходится запускать вручную. 
За это отвечает файл [start.sh](scripts/start.sh), содержащий в себе команды для старта cron, NGINX и SMB серверов.

[Dockerfile](Dockerfile) содержит скрипт, который в готового образ с NGINX копирует директорию scripts, устанавливает Samba, перемещает конфигруационные файлы в соответствующие директории, удаляет конфигурационный файл для NGINX, по умолчанию, копирует наш в папку scripts.
При запуске же стартует скрипт [start.sh](scripts/start.sh).


### 1. Установка Samba
Samba в дистрибутивы с пакетным менеджером apt обычно можно установить из репозиториев следующим образом:
```shell
apt-get update && apt-get install -y samba
```
Далее я создал довольно простой [конфигурационный файл](scripts/smb.conf), в котором, по большому счету, нечего и прокомментировать.

Конфигурационный файл я поместил в `/etc/samba/smb.conf`

### 2. Веб-сервер

В качестве веб-сервера был выбран nginx, как самый простой в настройке и применяемый повсеместно.
в файле [service.template](scripts/service.template) я описал найстроку nginx на шаренье папки /usr/files.


### 3. start.sh

Здесь содаётся файл на 100мб, в нём файловая система и он монтируеся в /usr/files/

```
dd if=/dev/zero of=/home/file count=1 bs=100M
mkfs.ext4 /home/file
mount -o loop /home/file /usr/files
```

ну а дальше происходит запуск самбы, нджинкса и крона

### 4. Бекап
Чтобы делать бекап кода веб страниц каждый новый год и пятницу 13-е, я написал [специальный скрипт](scripts/backup.sh).

Скрипт использует tar для создания бекапов. Бекапы именуются с учетом текущей даты.

Чтобы избежать проблем с перезаписью файлов во время бекапа, я отправляю SIGTSTP процессу сервера Samba, что приостанавливает его, предотвращая запись. После выполнения бекапа я отправляю процессу SIGCONT, что, соответственно, возобновляет его работу.

Далее этот скрипт был [добавлен в cron](scripts/crontab):
```
0 0 13 * * sh /usr/scripts/backup.sh
0 0 1 1 * sh /usr/scripts/backup.sh
```

![Скриншот HTTP-клиента](https://ibb.co/GRg0gmd "Скриншот HTTP-клиента")
