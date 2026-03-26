CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);
 
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    movie_name VARCHAR(255) NOT NULL,
    duration_in_minutes INTEGER NOT NULL CHECK (duration_in_minutes > 0)
);
 
CREATE TABLE movie_languages (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    language_id INTEGER NOT NULL REFERENCES languages(language_id) ON DELETE CASCADE,
    UNIQUE (movie_id, language_id)
);
 
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE
);
 
CREATE TABLE theaters (
    theater_id SERIAL PRIMARY KEY,
    theater_name VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    city VARCHAR(100) NOT NULL
);
 
CREATE TABLE screens (
    screen_id SERIAL PRIMARY KEY,
    theater_id INTEGER NOT NULL REFERENCES theaters(theater_id) ON DELETE CASCADE,
    screen_name VARCHAR(100) NOT NULL,
    seat_capacity INTEGER NOT NULL CHECK (seat_capacity > 0),
    UNIQUE (theater_id, screen_name)
);
 
CREATE TABLE offers (
    offer_id SERIAL PRIMARY KEY,
    offer_name VARCHAR(255) NOT NULL,
    offer_percentage INTEGER NOT NULL CHECK (offer_percentage BETWEEN 1 AND 100),
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    CHECK (valid_until > valid_from)
);
 
CREATE TABLE shows (
    show_id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    screen_id INTEGER NOT NULL REFERENCES screens(screen_id) ON DELETE CASCADE,
    show_start_time TIMESTAMP NOT NULL,
    show_end_time TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    available_seats INTEGER NOT NULL CHECK (available_seats >= 0)
    CHECK (show_end_time > show_start_time)
);
 
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    show_id INTEGER NOT NULL REFERENCES shows(show_id) ON DELETE RESTRICT,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    no_of_seats INTEGER NOT NULL CHECK (no_of_seats > 0),
    amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    offer_id INTEGER REFERENCES offers(offer_id) ON DELETE SET NULL
);