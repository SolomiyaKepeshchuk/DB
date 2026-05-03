-- 1. АГРЕГАТНІ ФУНКЦІЇ

-- Підраховуємо загальну кількість клієнтів у базі даних
SELECT COUNT(*) AS total_customers
FROM Customer;

-- Обчислюємо середню вартість туру
SELECT ROUND(AVG(base_price), 2) AS average_tour_price
FROM Tour;

-- Обчислюємо загальну суму оплат
SELECT SUM(amount) AS total_payments
FROM Payment;

-- Знаходимо мінімальну ціну туру
SELECT MIN(base_price) AS min_price
FROM Tour;

-- Знаходимо максимальну ціну туру
SELECT MAX(base_price) AS max_price
FROM Tour;

-- 2. ГРУПУВАННЯ ДАНИХ

-- Підраховуємо кількість турів за країнами
SELECT destination_country, COUNT(*) AS tours_count
FROM Tour
GROUP BY destination_country
ORDER BY tours_count DESC;

-- Обчислюємо суму оплат за способом оплати
SELECT method, SUM(amount) AS total_amount
FROM Payment
GROUP BY method
ORDER BY total_amount DESC;

-- Підраховуємо кількість гідів за мовами
SELECT languages, COUNT(*) AS guides_count
FROM Guide
GROUP BY languages
ORDER BY guides_count DESC;

-- 3. ФІЛЬТРУВАННЯ ГРУП

-- Виводимо типи турів із середньою ціною понад 10000 грн
SELECT tour_type, ROUND(AVG(base_price), 2) AS average_price
FROM Tour
GROUP BY tour_type
HAVING AVG(base_price) > 10000;

-- Виводимо країни, де загальна місткість турів більша за 15 місць
SELECT destination_country, SUM(capacity) AS total_capacity
FROM Tour
GROUP BY destination_country
HAVING SUM(capacity) > 15;

-- Виводимо способи оплати, які використовувались більше одного разу
SELECT method, COUNT(*) AS payments_count
FROM Payment
GROUP BY method
HAVING COUNT(*) > 1;

-- 4. JOIN-ЗАПИТИ

-- Виводимо бронювання разом з іменем клієнта та назвою туру
SELECT c.full_name, t.title, b.booking_date, b.persons_count, b.status
FROM Booking b
INNER JOIN Customer c ON b.customer_id = c.customer_id
INNER JOIN Tour t ON b.tour_id = t.tour_id;

-- Виводимо всі тури та закріплених гідів
SELECT t.title, g.full_name AS guide_name, tg.role
FROM Tour t
LEFT JOIN TourGuide tg ON t.tour_id = tg.tour_id
LEFT JOIN Guide g ON tg.guide_id = g.guide_id;

-- Виводимо всі можливі комбінації клієнтів і додаткових послуг
SELECT c.full_name, s.name AS service_name
FROM Customer c
CROSS JOIN Service s;

-- 5. БАГАТОТАБЛИЧНА АГРЕГАЦІЯ

-- Обчислюємо загальну вартість кожної додаткової послуги у бронюваннях
SELECT 
    c.full_name,
    b.booking_id,
    s.name AS service_name,
    bs.quantity,
    SUM(s.price * bs.quantity) AS service_total
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
JOIN BookingService bs ON b.booking_id = bs.booking_id
JOIN Service s ON bs.service_id = s.service_id
GROUP BY c.full_name, b.booking_id, s.name, bs.quantity
ORDER BY service_total DESC;

-- Підраховуємо кількість бронювань для кожного туру
SELECT t.title, COUNT(b.booking_id) AS bookings_count
FROM Tour t
JOIN Booking b ON t.tour_id = b.tour_id
GROUP BY t.title
ORDER BY bookings_count DESC;

-- Обчислюємо загальну суму оплат для кожного клієнта
SELECT c.full_name, SUM(p.amount) AS total_paid
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.full_name
ORDER BY total_paid DESC;

-- 6. ПІДЗАПИТИ

-- Виводимо клієнтів, які мають бронювання
SELECT full_name, phone, email
FROM Customer
WHERE customer_id IN (
    SELECT customer_id
    FROM Booking
);

-- Виводимо бронювання, за які вже є оплата
SELECT booking_id, customer_id, tour_id, booking_date, status
FROM Booking
WHERE booking_id IN (
    SELECT booking_id
    FROM Payment
);

-- Виводимо найдорожчу додаткову послугу
SELECT name, price
FROM Service
WHERE price = (
    SELECT MAX(price)
    FROM Service
);
