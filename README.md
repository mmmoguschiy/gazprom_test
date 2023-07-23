Создание БД mysql:

CREATE TABLE message (
created TIMESTAMP NOT NULL,
id VARCHAR(255) NOT NULL,
int_id CHAR(16) NOT NULL,
str VARCHAR(255) NOT NULL,
status BOOL,
PRIMARY KEY (id),
INDEX message_created_idx (created),
INDEX message_int_id_idx (int_id)
);
CREATE TABLE log (
created TIMESTAMP NOT NULL,
int_id CHAR(16) NOT NULL,
str VARCHAR(255),
address VARCHAR(1024)
);
CREATE INDEX log_address_idx ON log (address);




Описание файлов:

inst.pl - парсинг и добавление файла к базе данных

gazprom.pl - cgi-скрипт поиска по базе данных.
