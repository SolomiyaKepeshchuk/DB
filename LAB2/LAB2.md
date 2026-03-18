# Лабораторна робота №2
## Виконала: Кепещук Соломія ІО-41

---

## Тема:
Проєктування та реалізація бази даних туристичної агенції в середовищі PostgreSQL.
## Мета роботи:
- Написати SQL DDL-інструкції для створення кожної таблиці з вашої ERD в PostgreSQL.
- Вказати відповідні типи даних для кожного стовпця, вибрати первинний ключ для кожної таблиці та визначити будь-які необхідні зовнішні ключі, обмеження UNIQUE, NOT NULL, CHECK або DEFAULT.
- Вставити зразки рядків (принаймні 3–5 рядків на таблицю) за допомогою INSERT INTO.
- Протестувати все в pgAdmin (або іншому клієнті PostgreSQL), щоб переконатися, що таблиці та дані завантажуються правильно.

## 1. Діаграма ER.
<p align="center">
  <img src="DB_ER.LAB1.png" width="900"><br>
  <i>Рисунок 1 – ER-діаграма бази даних туристичної агенції</i>
</p>

---

## 2. Реалізація у PostgreSQL.

### SQL-код створення таблиць:
...
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    passport_no VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Tour (
    tour_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    destination_country VARCHAR(50) NOT NULL,
    destination_city VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    base_price NUMERIC(10,2) NOT NULL CHECK (base_price > 0),
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    tour_type VARCHAR(50),
    CHECK (end_date >= start_date)
);

CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    tour_id INTEGER NOT NULL,
    booking_date DATE NOT NULL DEFAULT CURRENT_DATE,
    persons_count INTEGER NOT NULL CHECK (persons_count > 0),
    status VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER UNIQUE NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    method VARCHAR(50),
    status VARCHAR(20),
    
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Guide (
    guide_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    languages VARCHAR(100),
    experience_years INTEGER CHECK (experience_years >= 0)
);

CREATE TABLE Service (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    description TEXT
);

CREATE TABLE BookingService (
    booking_id INTEGER,
    service_id INTEGER,
    quantity INTEGER NOT NULL CHECK (quantity > 0),

    PRIMARY KEY (booking_id, service_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

CREATE TABLE TourGuide (
    tour_id INTEGER,
    guide_id INTEGER,
    role VARCHAR(50),

    PRIMARY KEY (tour_id, guide_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id),
    FOREIGN KEY (guide_id) REFERENCES Guide(guide_id)
);
...

### SQL-код заповнення таблиць даними:

INSERT INTO Customer (full_name, phone, email, passport_no) VALUES
('Кепещук Соломія', '+380671112233', 'solomiya.k@tour.com', 'ID450123'),
('Половко Анна', '+380931234567', 'anna.polovko@tour.com', 'ID450124'),
('Мельник Назар', '+380501234890', 'nazar.melnyk@tour.com', 'ID450125'),
('Шевчук Тарас', '+380661234321', 'taras.shevchuk@tour.com', 'ID450126');

INSERT INTO Tour (title, destination_country, destination_city, start_date, end_date, base_price, capacity, tour_type) VALUES
('Вікенд у Кракові', 'Польща', 'Краків', '2025-05-10', '2025-05-13', 12500.00, 20, 'екскурсійний'),
('Літній відпочинок у Чорногорії', 'Чорногорія', 'Будва', '2025-07-01', '2025-07-08', 23800.00, 15, 'пляжний'),
('Гірський тур у Карпати', 'Україна', 'Яремче', '2025-06-15', '2025-06-20', 9600.00, 18, 'гірський'),
('Романтичний Париж', 'Франція', 'Париж', '2025-09-05', '2025-09-10', 31200.00, 12, 'екскурсійний');

INSERT INTO Booking (customer_id, tour_id, booking_date, persons_count, status) VALUES
(1, 1, '2025-04-20', 2, 'confirmed'),
(2, 2, '2025-05-03', 1, 'new'),
(3, 3, '2025-05-15', 3, 'confirmed'),
(4, 4, '2025-06-01', 2, 'completed');

INSERT INTO Payment (booking_id, payment_date, amount, method, status) VALUES
(1, '2025-04-21', 25000.00, 'card', 'paid'),
(2, '2025-05-04', 23800.00, 'bank transfer', 'pending'),
(3, '2025-05-16', 28800.00, 'cash', 'paid'),
(4, '2025-06-02', 62400.00, 'card', 'paid');

INSERT INTO Guide (full_name, phone, languages, experience_years) VALUES
('Плохій Оксана', '+380671001122', 'українська, англійська, польська', 6),
('Голешев Тарас', '+380931009988', 'українська, англійська', 4),
('Стеценко Руслан ', '+380501007755', 'українська, французька', 8),
('Прокопенко Юлія', '+380661003344', 'українська, англійська, італійська', 5);

INSERT INTO Service (name, price, description) VALUES
('Медичне страхування', 650.00, 'Страхування на період подорожі'),
('Транспортне обслуговування з аеропорту', 1200.00, 'Індивідуальний або груповий трансфер'),
('Додаткова екскурсія', 900.00, 'Оглядова екскурсія з гідом'),
('Харчування ', 1800.00, 'Сніданок та вечеря');

INSERT INTO BookingService (booking_id, service_id, quantity) VALUES
(1, 1, 2),
(1, 3, 2),
(2, 2, 1),
(3, 1, 3),
(4, 4, 2);

INSERT INTO TourGuide (tour_id, guide_id, role) VALUES
(1, 1, 'екскурсійний гід'),
(2, 2, 'супроводжуючий гід'),
(3, 2, 'гірський гід'),
(4, 3, 'екскурсійний гід');

### SQL-запити:

SELECT 
    c.full_name AS customer_name,
    t.title AS tour_title,
    g.full_name AS guide_name,
    p.amount,
    STRING_AGG(s.name, ', ') AS services
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
JOIN Tour t ON b.tour_id = t.tour_id
LEFT JOIN Payment p ON b.booking_id = p.booking_id
LEFT JOIN TourGuide tg ON t.tour_id = tg.tour_id
LEFT JOIN Guide g ON tg.guide_id = g.guide_id
LEFT JOIN BookingService bs ON b.booking_id = bs.booking_id
LEFT JOIN Service s ON bs.service_id = s.service_id
GROUP BY c.full_name, t.title, g.full_name, p.amount
ORDER BY c.full_name;

---

## 3.Результати виконання.


