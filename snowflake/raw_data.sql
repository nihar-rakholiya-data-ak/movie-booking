CREATE TABLE languages (
    language_id INTEGER AUTOINCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE movies (
    movie_id INTEGER AUTOINCREMENT PRIMARY KEY,
    movie_name STRING NOT NULL,
    duration_in_minutes INTEGER NOT NULL
);

CREATE TABLE movie_languages (
    id INTEGER AUTOINCREMENT PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    language_id INTEGER NOT NULL,
    UNIQUE (movie_id, language_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

CREATE TABLE users (
    user_id INTEGER AUTOINCREMENT PRIMARY KEY,
    username STRING NOT NULL UNIQUE
);

CREATE TABLE theaters (
    theater_id INTEGER AUTOINCREMENT PRIMARY KEY,
    theater_name STRING NOT NULL,
    address STRING,
    city STRING NOT NULL
);

CREATE TABLE screens (
    screen_id INTEGER AUTOINCREMENT PRIMARY KEY,
    theater_id INTEGER NOT NULL,
    screen_name STRING NOT NULL,
    seat_capacity INTEGER NOT NULL,
    UNIQUE (theater_id, screen_name),
    FOREIGN KEY (theater_id) REFERENCES theaters(theater_id)
);

CREATE TABLE offers (
    offer_id INTEGER AUTOINCREMENT PRIMARY KEY,
    offer_name STRING NOT NULL,
    offer_percentage INTEGER NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL
);

CREATE TABLE shows (
    show_id INTEGER AUTOINCREMENT PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    screen_id INTEGER NOT NULL,
    show_time TIMESTAMP NOT NULL,
    price NUMBER(10,2) NOT NULL,
    available_seats INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id)
);

CREATE TABLE bookings (
    booking_id INTEGER AUTOINCREMENT PRIMARY KEY,
    show_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    no_of_seats INTEGER NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    offer_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (show_id) REFERENCES shows(show_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (offer_id) REFERENCES offers(offer_id)
);