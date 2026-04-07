-- Export into CSV
COPY languages TO '/tmp/languages.csv' DELIMITER ',' CSV HEADER;
COPY movies TO '/tmp/movies.csv' DELIMITER ',' CSV HEADER;
COPY movie_languages TO '/tmp/movie_languages.csv' CSV HEADER;
COPY users TO '/tmp/users.csv' CSV HEADER;
COPY theaters TO '/tmp/theaters.csv' CSV HEADER;
COPY screens TO '/tmp/screens.csv' CSV HEADER;
COPY offers TO '/tmp/offers.csv' CSV HEADER;
COPY shows TO '/tmp/shows.csv' CSV HEADER;
COPY bookings TO '/tmp/bookings.csv' CSV HEADER;
