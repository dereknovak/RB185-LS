CREATE TABLE services (
  id serial PRIMARY KEY,
  name varchar(25) NOT NULL UNIQUE,
  price int NOT NULL CHECK (price >= 0),
  description text
);

CREATE TABLE customers (
  id serial PRIMARY KEY,
  first_name varchar(25) NOT NULL,
  last_name varchar(25) NOT NULL,
  phone_number char(10) CHECK (length(phone_number) = 10),
  email_address varchar(25) CHECK (email_address LIKE '%@%')
);

CREATE TABLE bicycles (
  id serial PRIMARY KEY,
  serial_number varchar(25) NOT NULL UNIQUE,
  make varchar(25) NOT NULL,
  model varchar(25) NOT NULL,
  color varchar(25) NOT NULL,
  customer_id int NOT NULL REFERENCES customers (id)
);

CREATE TABLE work_orders (
  id serial PRIMARY KEY,
  number int NOT NULL,
  bicycle_id int NOT NULL REFERENCES bicycles (id),
  service_id int NOT NULL REFERENCES services (id),
  "date" date NOT NULL,
);

INSERT INTO services (name, price, description)
VALUES ('Flat Fix', 10, 'Replace tube for either front or rear tire')
       ('Tune', 140, 'Full service package that includes adjustments and cleaning'),
       ('Frame and Wheel Clean', 20, 'Full detail of bicycle frame and wheels'),
       ('Adjust Derailleur', 20, 'Index and set limits for either front or rear derailleur'),
       ('Adjust Brake', 20, 'Retension and center either front or rear brake'),
       ('Install Chain', 20, 'Remove and install chain'),
       ('Overhaul Fork', 80, 'Disassemble, clean, and relubricate suspension fork'),
       ('Tubeless Conversion', 20, 'Converts a tubed-tire system into tubeless');


INSERT INTO customers (first_name, last_name, phone_number, email_address)
VALUES ('Derek', 'Novak', '2543718698', 'derek.novak1@gmail.com');