
CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT, address TEXT) TABLESPACE dvm64;
CREATE TABLE shops (id SERIAL PRIMARY KEY, name TEXT, address TEXT) TABLESPACE hmd60;
CREATE TABLE orders (id SERIAL PRIMARY KEY, user_id INT, status TEXT) TABLESPACE iqp71;


INSERT INTO users (name,address) VALUES ('Ray', 'The Jupiter');
INSERT INTO shops (name, address) VALUES ('Spar', 'The Moon');
INSERT INTO orders (user_id, status) VALUES (1, 'CANCELED');


SELECT spcname FROM pg_tablespace;


SELECT tablename, tablespace FROM pg_tables WHERE tablespace IN ('dvm64', 'hmd60', 'iqp71');