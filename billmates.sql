CREATE DATABASE billmates;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR (100) NOT NULL,
  email VARCHAR(300) NOT NULL,
  password_digest VARCHAR(400) NOT NULL
);


CREATE TABLE bills (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  img_url VARCHAR(400),
  open_closed BIT,
  user_id  INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
);

ALTER TABLE bills 
ADD COLUMN join_pin INTEGER;

ALTER TABLE bills
ADD COLUMN open BOOLEAN;


CREATE TABLE usersxbills (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER NOT NULL,
  bill_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE RESTRICT
);



CREATE TABLE items (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  amount MONEY,
  bill_id INTEGER,
  created_by_user_id INTEGER,
  paid_by_user_id INTEGER,
  FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE RESTRICT,
  FOREIGN KEY (created_by_user_id) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (paid_by_user_id) REFERENCES users (id) ON DELETE RESTRICT
);

CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  content VARCHAR(400),
  img_url VARCHAR(400),
  bill_id INTEGER,
  user_id INTEGER,
  FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
);

