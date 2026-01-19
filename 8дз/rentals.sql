CREATE TABLE rentals (
    id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    vehicle_class TEXT NOT NULL,
    pickup_city TEXT NOT NULL,
    daily_rate NUMERIC(10,2) NOT NULL CHECK (daily_rate > 0),
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    status TEXT NOT NULL,
    CHECK (return_date >= pickup_date),
    CHECK (status IN ('Booked', 'Confirmed', 'Completed', 'Cancelled'))
);

INSERT INTO rentals (customer_name, vehicle_class, pickup_city, daily_rate, pickup_date, return_date, status) VALUES
('John Smith', 'SUV', 'New York', 75.00, '2022-05-15', '2022-05-20', 'Completed'),
('Maria Petrova', 'SUV Premium', 'New Haven', 90.00, '2022-06-10', '2022-06-15', 'Confirmed'),
('Alex Sidorov', 'SUV', 'New Orleans', 65.00, '2023-10-20', '2023-10-25', 'Completed'),
('Kate Volkova', 'suv compact', 'Newark', 55.00, '2023-12-31', '2024-01-05', 'Booked'),
('Dmitry Kozlov', 'SUV Luxury', 'New York', 120.00, '2022-01-01', '2022-01-07', 'Completed'),
('Olga Smirnova', 'Economy', 'New York', 40.00, '2022-08-15', '2022-08-20', 'Completed'),
('Pavel Morozov', 'SUV', 'Los Angeles', 70.00, '2022-09-10', '2022-09-15', 'Completed'),
('Tatiana Orlova', 'Compact', 'New Haven', 50.00, '2024-01-15', '2024-01-20', 'Booked'),
('Sergey Nikolaev', 'SUV', 'Boston', 80.00, '2021-12-31', '2022-01-05', 'Completed'),
('Test User1', 'Compact', 'Chicago', 45.00, '2023-03-10', '2023-03-15', 'Booked'),
('Anna Kuznetsova', 'Economy', 'Miami', 40.00, '2023-04-20', '2023-04-25', 'Booked'),
('Igor Belov', 'Premium', 'Seattle', 70.00, '2023-05-05', '2023-05-10', 'Booked'),
('Natalia Sokolova', 'Compact', 'Denver', 55.00, '2023-06-15', '2023-06-20', 'Booked'),
('Test User2', 'SUV', 'Testville', 50.00, '2023-07-01', '2023-07-06', 'Booked'),
('Test User3', 'Compact', 'testcity', 60.00, '2023-07-10', '2023-07-15', 'Booked'),
('Maxim Popov', 'Economy', 'Phoenix', 39.99, '2023-08-01', '2023-08-06', 'Booked'),
('Elena Novikova', 'Premium', 'Dallas', 70.01, '2023-08-10', '2023-08-15', 'Booked'),
('Alexander Fedorov', 'Compact', 'Austin', 65.00, '2023-09-01', '2023-09-06', 'Confirmed'),
('Test User4', 'Economy', 'Houston', 30.00, '2018-05-10', '2018-05-15', 'Cancelled'),
('Test User5', 'Compact', 'Atlanta', 35.00, '2018-10-20', '2018-10-25', 'Cancelled'),
('test user6', 'SUV', 'Detroit', 45.00, '2017-12-01', '2017-12-10', 'Cancelled'),
('Ivan Testov', 'Premium', 'Philadelphia', 50.00, '2018-11-15', '2018-11-20', 'Cancelled'),
('Test User7', 'Economy', 'San Diego', 40.00, '2019-01-01', '2019-01-05', 'Cancelled'),
('Test User8', 'Compact', 'Portland', 42.00, '2018-12-28', '2019-01-02', 'Completed'),
('Olga Ivanova', 'Premium', 'Orlando', 85.00, '2023-11-01', '2023-11-07', 'Confirmed');

SELECT id, customer_name, vehicle_class, pickup_city, daily_rate, pickup_date, return_date, status
FROM rentals
WHERE LOWER(pickup_city) LIKE '%new%'
    AND LOWER(vehicle_class) LIKE 'suv%'
    AND pickup_date BETWEEN '2022-01-01' AND '2023-12-31'
ORDER BY pickup_date, customer_name;

UPDATE rentals
SET daily_rate = daily_rate * 1.08
WHERE status = 'Booked'
    AND daily_rate BETWEEN 40 AND 70
    AND LOWER(pickup_city) NOT LIKE '%test%';

DELETE FROM rentals
WHERE status = 'Cancelled'
    AND return_date < '2019-01-01'
    AND LOWER(customer_name) LIKE '%test%';
