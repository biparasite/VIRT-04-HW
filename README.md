# Домашнее задание к занятию " `Практическое применение Docker` " - `Сулименков Алексей`

---

## Задача 0

Убедитесь что у вас НЕ(!) установлен docker-compose, для этого получите следующую ошибку от команды `docker-compose --version`

### Ответ

<details> <summary>docker compose version</summary>

```bash
Docker Compose version v2.31.0-desktop.2
```

</details>

---

## Задача 1

1. Сделайте в своем github пространстве fork репозитория. Примечание: В связи с доработкой кода python приложения. Если вы уверены что задание выполнено вами верно, а код python приложения работает с ошибкой то используйте вместо main.py файл not_tested_main.py(просто измените CMD)
2. Создайте файл с именем Dockerfile.python для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ python:3.9-slim. Обязательно используйте конструкцию COPY . . в Dockerfile. Не забудьте исключить ненужные в имадже файлы с помощью dockerignore. Протестируйте корректность сборки.
3. (Необязательная часть, \*) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
4. (Необязательная часть, \*) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.

### Ответ

1.

<details> <summary>fork репозитория</summary>

https://github.com/biparasite/shvirtd-example-python

</details>

2.

```yaml
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY main.py .

CMD ["python", "main.py"]
```

<details> <summary>docker build</summary>

![task1](https://github.com/biparasite/VIRT-04-HW/blob/main/task_1.2.png "task1")

</details>

---

## Задача 2 (\*)

1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . Инструкция
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.

В качестве ответа приложите отчет сканирования.

### Ответ

<details> <summary>отчет сканирования</summary>

https://github.com/biparasite/VIRT-04-HW/blob/main/vulnerabilities.csv

![task2](https://github.com/biparasite/VIRT-04-HW/blob/main/task_2.png "task2")

</details>

---

## Задача 3

1.  Изучите файл "proxy.yaml"
2.  Создайте в репозитории с проектом файл compose.yaml. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3.  Опишите в файле compose.yaml следующие сервисы:

- web. Образ приложения должен ИЛИ собираться при запуске compose из файла Dockerfile.python ИЛИ скачиваться из yandex cloud container registry(из задание №2 со \*). Контейнер должен работать в bridge-сети с названием backend и иметь фиксированный ipv4-адрес 172.20.0.5. Сервис должен всегда перезапускаться в случае ошибок. Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса web

- db. image=mysql:8. Контейнер должен работать в bridge-сети с названием backend и иметь фиксированный ipv4-адрес 172.20.0.10. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда curl -L http://127.0.0.1:8090 должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: docker ps -a и docker logs <container_name> . Если вместо IP-адреса вы получаете NULL --убедитесь, что вы шлете запрос на порт 8090, а не 5000.

5. Подключитесь к БД mysql с помощью команды docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT \* from requests LIMIT 10;.

Остановите проект. В качестве ответа приложите скриншот sql-запроса.

### Ответ

---

![task3](https://github.com/biparasite/VIRT-04-HW/blob/main/task_3.1.png "task3")

---

## Задача 4

1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): https://check-host.net/check-http и запустите проверку вашего сервиса http://<внешний*IP-адрес*вашей_ВМ>:8090. Таким образом трафик будет направлен в ingress-proxy. ПРИМЕЧАНИЕ: приложение main.py( в отличие от not_tested_main.py) весьма вероятно упадет под нагрузкой, но успеет обработать часть запросов - этого достаточно. Обновленная версия (main.py) не прошла достаточного тестирования временем, но должна справиться с нагрузкой.
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения docker ps -a

   В качестве ответа повторите sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

---

### Ответ

![task4](https://github.com/biparasite/VIRT-04-HW/blob/main/task_4.1.png "task4")

<details> <summary>bash script</summary>

```bash
#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Pls, try run with sudo"
  exit
fi

echo "Install"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


REPO_URL="https://github.com/biparasite/VIRT-04-HW.git"
TARGET_DIR="/opt/shvirtd-example-python"

git clone "$REPO_URL" "$TARGET_DIR"

cd "$TARGET_DIR" || exit

docker compose up -d

```

</details>
