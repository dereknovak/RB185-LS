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
  email_address varchar(25) CHECK (email_address LIKE '%@%'),
  UNIQUE (first_name, last_name, phone_number),
  UNIQUE (first_name, last_name, email_address)
);

CREATE TABLE bicycles (
  id serial PRIMARY KEY,
  serial_number varchar(25) NOT NULL UNIQUE,
  make varchar(25) NOT NULL,
  model varchar(25) NOT NULL,
  color varchar(25) NOT NULL,
  customer_id int NOT NULL REFERENCES customers (id) ON DELETE CASCADE
);


CREATE TABLE workorders (
  id serial PRIMARY KEY,
  start_date date NOT NULL DEFAULT CURRENT_DATE,
  complete_date date,
  completed boolean NOT NULL DEFAULT false,
  bicycle_id int NOT NULL REFERENCES bicycles (id) ON DELETE CASCADE
);

CREATE TABLE workorder_services (
  id serial PRIMARY KEY,
  workorder_id int NOT NULL REFERENCES workorders (id) ON DELETE CASCADE,
  service_id int NOT NULL REFERENCES services (id) ON DELETE CASCADE
);


INSERT INTO services (name, price, description)
VALUES ('Flat Fix', 10, 'Replace tube for either front or rear tire'),
       ('Tune', 140, 'Full service package that includes adjustments and cleaning'),
       ('Frame and Wheel Clean', 20, 'Full detail of bicycle frame and wheels'),
       ('Adjust Derailleur', 20, 'Index and set limits for either front or rear derailleur'),
       ('Adjust Brake', 20, 'Retension and center either front or rear brake'),
       ('Install Chain', 20, 'Remove and install chain'),
       ('Overhaul Fork', 80, 'Disassemble, clean, and relubricate suspension fork'),
       ('Tubeless Conversion', 20, 'Converts a tubed-tire system into tubeless');


INSERT INTO customers (first_name, last_name, phone_number, email_address)
VALUES ('Derek', 'Novak', '2543718698', 'derek.novak1@gmail.com'),
       ('Derek', 'Jeter', '1234567890', 'derek.jeter@yahoo.com'),
       ('John', 'Doe', '8647953461', 'john_doe23@aol.com'),
       ('Jimmy', 'Neutron', '4693713578', 'james_neutron@msn.com');

INSERT INTO bicycles (serial_number, make, model, color, customer_id)
VALUES ('WTU123456', 'Cannondale', 'Synapse', 'Maroon', 1),
       ('WSBC234565', 'Trek', 'Madonne', 'Blue', 1),
       ('TR23432', 'Specialized', 'Roubaix', 'Orange', 2),
       ('LSC23421', 'Giant', 'Defy', 'Black', 3),
       ('WTU997347', 'Woom', '3', 'Red', 3);