CREATE TABLE temperatures (
    id INTEGER PRIMARY KEY,
    city TEXT NOT NULL,
    date DATE NOT NULL,
    temperature INTEGER NOT NULL CHECK (temperature >= -60 AND temperature <= 60)
);

INSERT INTO temperatures (id, city, date, temperature) VALUES
(1, 'Москва', '2024-01-15', -10),
(2, 'Сочи', '2024-01-15', 5),
(3, 'Якутск', '2024-01-10', -35),
(4, 'Краснодар', '2024-01-12', 2),
(5, 'Владивосток', '2024-01-14', -8);