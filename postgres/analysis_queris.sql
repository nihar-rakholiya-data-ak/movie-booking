--create a trigger to update available seats when 
CREATE OR REPLACE FUNCTION update_available_seats()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		UPDATE shows
		SET available_seats = available_seats - NEW.no_of_seats
		WHERE show_id = NEW.show_id;

	ELSEIF TG_OP = 'DELETE' THEN
		UPDATE shows
		SET available_seats = available_seats + OLD.no_of_seats
		WHERE show_id = NEW.show_id;
		
	ELSIF TG_OP = 'UPDATE' THEN
        UPDATE shows
        SET available_seats = available_seats + (OLD.no_of_seats - NEW.no_of_seats)
        WHERE show_id = NEW.show_id;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_booking_seats
AFTER INSERT OR UPDATE OR DELETE ON bookings
FOR EACH ROW EXECUTE FUNCTION update_available_seats();

SELECT * FROM BOOKINGS;

--Write a query to find total bookings per theatre per day.
SELECT 
    t.theater_name,
    DATE(s.show_time) AS booking_date,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN shows s ON b.show_id = s.show_id
JOIN screens sc ON s.screen_id = sc.screen_id
JOIN theaters t ON sc.theater_id = t.theater_id
GROUP BY t.theater_name, DATE(s.show_time)
ORDER BY booking_date, total_bookings DESC;

-- Write a query to detect duplicate booking entries for the same user and show.
SELECT 
    user_id,
    show_id,
    COUNT(*) AS duplicate_count
FROM bookings
GROUP BY user_id, show_id
HAVING COUNT(*) > 1;

--Write a query to capture both inserted and updated rows from the seat availability stream.
WITH first_booking AS (
    SELECT user_id, MIN(created_at) AS first_booking_date
    FROM bookings
    GROUP BY user_id
),
repeat_users AS (
    SELECT DISTINCT b.user_id
    FROM bookings b
    JOIN first_booking f ON b.user_id = f.user_id
    WHERE b.created_at > f.first_booking_date
      AND b.created_at <= f.first_booking_date + INTERVAL '30 days'
)
SELECT 
    COUNT(repeat_users.user_id) * 100.0 / COUNT(first_booking.user_id) AS retention_rate
FROM first_booking
LEFT JOIN repeat_users 
    ON first_booking.user_id = repeat_users.user_id;

-- Calculate seat utilisation rate per show (booked seats / total seats).
SELECT 
    s.show_id,
    sc.seat_capacity AS total_seats,
    COALESCE(SUM(b.no_of_seats), 0) AS booked_seats,
    ROUND(
        COALESCE(SUM(b.no_of_seats), 0) * 100.0 / sc.seat_capacity, 2
    ) AS utilisation_rate
FROM shows s
JOIN screens sc ON s.screen_id = sc.screen_id
LEFT JOIN bookings b ON s.show_id = b.show_id
GROUP BY s.show_id, sc.seat_capacity;

-- Identify the most profitable movie across all shows.
SELECT 
    m.movie_name,
    SUM(b.amount) AS total_revenue
FROM bookings b
JOIN shows s ON b.show_id = s.show_id
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.movie_name
ORDER BY total_revenue DESC
LIMIT 1;

--Create a function to calculate total revenue per show.
CREATE OR REPLACE FUNCTION get_revenue_per_show()
RETURNS TABLE (
    show_id INT,
    total_revenue NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.show_id,
        COALESCE(SUM(b.amount), 0) AS total_revenue
    FROM shows s
    LEFT JOIN bookings b ON s.show_id = b.show_id
    GROUP BY s.show_id
    ORDER BY total_revenue DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * from get_revenue_per_show()
