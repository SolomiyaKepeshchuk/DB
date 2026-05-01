-- SELECT

-- 1. Пошук доступних турів до 20000 грн
SELECT title, destination_country, base_price
FROM Tour
WHERE base_price < 20000
ORDER BY base_price;

-- 2. Пошук турів, які тривають більше 4 днів
SELECT title, start_date, end_date, end_date - start_date AS duration_days
FROM Tour
WHERE end_date - start_date > 4;

-- 3. Перегляд підтверджених бронювань
SELECT booking_id, customer_id, tour_id, status
FROM Booking
WHERE status = 'confirmed';

-- 4. Пошук клієнтів, які замовили додаткові послуги
SELECT c.full_name, s.name, bs.quantity
FROM BookingService bs
JOIN Booking b ON bs.booking_id = b.booking_id
JOIN Customer c ON b.customer_id = c.customer_id
JOIN Service s ON bs.service_id = s.service_id;

-- 5. Перегляд турів із закріпленими гідами
SELECT t.title, g.full_name, tg.role
FROM TourGuide tg
JOIN Tour t ON tg.tour_id = t.tour_id
JOIN Guide g ON tg.guide_id = g.guide_id;

-- INSERT

-- 1. Додавання нового клієнта
INSERT INTO Customer (full_name, phone, email, passport_no)
VALUES ('Іваненко Марія', '+380681234567', 'maria.ivanenko@tour.com', 'ID450127');

SELECT full_name, phone, email, passport_no
FROM Customer
WHERE email = 'maria.ivanenko@tour.com';

-- 2. Додавання нового туру
INSERT INTO Tour (title, destination_country, destination_city, start_date, end_date, base_price, capacity, tour_type)
VALUES ('Осінній тур до Праги', 'Чехія', 'Прага', '2025-10-10', '2025-10-15', 18500.00, 16, 'екскурсійний');

SELECT title, destination_country, destination_city, base_price, capacity, tour_type
FROM Tour
WHERE title = 'Осінній тур до Праги';

-- 3. Додавання нової додаткової послуги
INSERT INTO Service (name, price, description)
VALUES ('Оренда туристичного спорядження', 1500.00, 'Оренда спорядження для активного відпочинку');

SELECT name, price, description
FROM Service
WHERE name = 'Оренда туристичного спорядження';

-- UPDATE

-- 1. Оновлення номера телефону клієнта
UPDATE Customer
SET phone = '+380681111111'
WHERE email = 'maria.ivanenko@tour.com';

SELECT full_name, phone, email
FROM Customer
WHERE email = 'maria.ivanenko@tour.com';

-- 2. Оновлення інформації про тур
UPDATE Tour
SET base_price = 17900.00,
    capacity = 18
WHERE title = 'Осінній тур до Праги';

SELECT title, base_price, capacity
FROM Tour
WHERE title = 'Осінній тур до Праги';

-- 3. Оновлення ціни додаткової послуги
UPDATE Service
SET price = 1350.00
WHERE name = 'Оренда туристичного спорядження';

SELECT name, price, description
FROM Service
WHERE name = 'Оренда туристичного спорядження';

-- DELETE

-- 1. Видалення послуги, яка більше не актуальна
DELETE FROM BookingService
WHERE service_id IN (
    SELECT service_id
    FROM Service
    WHERE name = 'Додаткова екскурсія'
);

DELETE FROM Service
WHERE name = 'Додаткова екскурсія';

SELECT service_id, name, price, description
FROM Service;

-- 2. Видалення гіда, який більше не співпрацює з агенцією
DELETE FROM Guide
WHERE full_name = 'Прокопенко Юлія';

SELECT guide_id, full_name, phone, languages, experience_years
FROM Guide;

-- 3. Видалення туру, який більше не доступний для бронювання
DELETE FROM Tour
WHERE title = 'Осінній тур до Праги'
  AND destination_country = 'Чехія';

SELECT tour_id, title, destination_country, destination_city, base_price
FROM Tour;
