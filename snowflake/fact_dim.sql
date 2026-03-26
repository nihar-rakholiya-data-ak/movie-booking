CREATE OR REPLACE TABLE dim_movies AS
    SELECT 
        m.movie_id,
        m.movie_name,
        m.duration_in_minutes,
        LISTAGG(l.language_name, ', ') AS languages
    FROM movies m
    LEFT JOIN movie_languages ml ON m.movie_id = ml.movie_id
    LEFT JOIN languages l ON ml.language_id = l.language_id
    GROUP BY m.movie_id, m.movie_name, m.duration_in_minutes;

CREATE OR REPLACE TABLE dim_users AS
SELECT 
    user_id,
    username
FROM users;


CREATE OR REPLACE TABLE dim_offers AS
SELECT 
    offer_id,
    offer_name,
    offer_percentage,
    valid_from,
    valid_until
FROM offers;

CREATE OR REPLACE TABLE dim_screens AS
SELECT theater_id,theater_name, address,city, screen_name,seat_capacity FROM theaters NATURAL JOIN screens;

CREATE OR REPLACE TABLE fact_bookings AS
SELECT 
    b.booking_id,
    b.user_id,
    s.movie_id,
    sc.theater_id, 
    s.show_time,
    DATE(s.show_time) AS show_date,
    EXTRACT(YEAR FROM s.show_time) AS year,
    EXTRACT(MONTH FROM s.show_time) AS month,
    DAYNAME(s.show_time) AS day_name,
    b.no_of_seats,
    b.amount,
    b.amount / (1 - o.offer_percentage/100.0) AS original_amount,
    (b.amount * o.offer_percentage) / (100 - o.offer_percentage) AS discount_amount
FROM bookings b
JOIN shows s ON b.show_id = s.show_id
JOIN screens sc ON s.screen_id = sc.screen_id
JOIN offers o ON o.offer_id = b.offer_id


CREATE OR REPLACE TABLE fact_seat_availability AS
SELECT 
    s.show_id,
    s.movie_id,
    s.screen_id,
    sc.theater_id,
    s.show_time,
    sc.seat_capacity AS total_capacity,
    s.available_seats
FROM shows s
JOIN screens sc ON s.screen_id = sc.screen_id;