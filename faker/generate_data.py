from faker import Faker
import psycopg2

# Database connection parameters
def get_connection():
   """Establishes and returns a connection to the PostgreSQL database."""
   return psycopg2.connect(
       dbname='moviebooking',
       user='postgres',
       password='admin',
       host='localhost'
   )

# Functions to seed data into the database
def seed_users(num_users=10):
   """Seeds the 'users' table with fake user data."""
   fake = Faker()
   conn = None
  
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(num_users):
           username = fake.user_name()
           cur.execute("INSERT INTO users (username) VALUES (%s);", (username,))
      
       conn.commit()
       cur.close()
       print(f"Successfully added {num_users} users.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding languages with a predefined list of Indian languages
def seed_languages():
   """Seeds the 'languages' table with a predefined list of Indian languages."""
   conn = None
   indian_langs = [
       "Hindi", "Gujarati", "Marathi", "Bengali", "Tamil","English"
   ]
  
   try:
       conn = get_connection()
       cur = conn.cursor()
   
       for language in indian_langs:
           cur.execute("INSERT INTO languages (language_name) VALUES (%s);", (language,))
      
       conn.commit()
       cur.close()
       print(f"Successfully added {len(indian_langs)} languages.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding movies with random names and durations
def seed_movies(num_movies=10):
   """Seeds the 'movies' table with random movie names and durations."""
   fake = Faker()
   conn = None
  
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(num_movies):
           movie_name = " ".join(fake.words(nb=fake.random_int(min=2, max=4))).title()
           duration = fake.random_int(min=90, max=250)
           cur.execute("INSERT INTO movies (movie_name, duration_in_minutes) VALUES (%s, %s);", (movie_name, duration))
      
       conn.commit()
       cur.close()
       print(f"Successfully added {num_movies} movies.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding theaters with random names and addresses
def seed_theaters(num_theaters=10):
   """Seeds the 'theaters' table with random theater names and addresses."""
   fake = Faker()
   conn = None
  
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(num_theaters):
           theater_name = fake.company().replace(',', '') + " Cinemas"
           theater_address = fake.address().replace('\n', ', ')
           theater_city = fake.city()
           cur.execute("INSERT INTO theaters (theater_name, address,city) VALUES (%s, %s, %s);", (theater_name, theater_address,theater_city))
      
       conn.commit()
       cur.close()
       print(f"Successfully added {num_theaters} theaters.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding screens with random names, theater associations, and seat capacities
def seed_screens(num_screens=10):
   """Seeds the 'screens' table with random screen names, theater associations, and seat capacities."""
   fake = Faker()
   conn = None
  
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(num_screens):
           screen_name = fake.word() + " Screen"
           theater_id = fake.random_int(min=2, max=11)
           seat_capacity = fake.random_int(min=21, max=150)
           cur.execute("INSERT INTO screens (theater_id,screen_name,seat_capacity) VALUES (%s, %s, %s);", (theater_id, screen_name, seat_capacity))
      
       conn.commit()
       cur.close()
       print(f"Successfully added {num_screens} screens.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding movie-language associations with random movie and language IDs
def seed_movielanguages():
   """Seeds the 'movie_languages' table with random movie and language IDs."""
   fake = Faker()
   conn = None
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for movie_id in range(1, 11):
           language_id = fake.random_int(min=1, max=6)
           cur.execute("INSERT INTO movie_languages (movie_id, language_id) VALUES (%s, %s);", (movie_id, language_id))
       conn.commit()
       cur.close()
       print(f"Successfully added movie-language associations.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding offers with random offer codes, discount percentages, and validity periods
def seed_offers():
   """ Seeds the 'offers' table with random offer codes, discount percentages, and validity periods."""
   fake = Faker()
   conn = None
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(3):
           offer_code = fake.bothify(text='OFFER-####')
           discount_percentage = fake.random_int(min=5, max=75)
           valid_from = fake.date_between(start_date='-30d', end_date='today')
           valid_to = fake.date_between(start_date='today', end_date='+30d')
           cur.execute("INSERT INTO offers (offer_name, offer_percentage, valid_from, valid_until) VALUES (%s, %s, %s, %s);", (offer_code, discount_percentage, valid_from, valid_to))
      
       conn.commit()
       cur.close()
       print(f"Successfully added 10 offers.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding shows with random movie and screen associations, show times, prices, and available seats 
def seed_shows():
   """Seeds the 'shows' table with random movie and screen associations, show times, prices, and available seats."""
   fake = Faker()
   conn = None
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(10):
           movie_id = fake.random_int(min=1, max=10)
           screen_id = fake.random_int(min=1, max=10)
           show_time = fake.date_time_between(start_date='-30d', end_date='+30d')
           price = fake.random_int(min=130, max=600)
           cur.execute("SELECT seat_capacity FROM screens WHERE screen_id = %s;", (screen_id,))
           available_seats = cur.fetchone()[0]
           cur.execute("INSERT INTO shows (movie_id, screen_id, show_time, price,available_seats) VALUES (%s, %s, %s, %s, %s);", (movie_id, screen_id, show_time, price, available_seats))
      
       conn.commit()
       cur.close()
       print(f"Successfully added 10 shows.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Seeding bookings with random user and show associations, number of seats, calculated amounts, and offer associations
def seed_bookings():
   """Seeds the 'bookings' table with random user and show associations, number of seats, calculated amounts, and offer associations."""
   fake = Faker()
   conn = None
   try:
       conn = get_connection()
       cur = conn.cursor()
      
       for _ in range(3):
           user_id = fake.random_int(min=1, max=10)
           show_id = fake.random_int(min=2, max=11)
           no_of_seats = fake.random_int(min=1, max=5)
           cur.execute("SELECT price FROM shows WHERE show_id = %s;", (show_id,))
           price_per_seat = float(cur.fetchone()[0])
           amount = price_per_seat * no_of_seats
           offer_id = fake.random_int(min=1, max=3)
           cur.execute("SELECT offer_percentage FROM offers WHERE offer_id = %s;", (offer_id,))
           discount_percentage = cur.fetchone()[0]
           amount = (discount_percentage / 100.0) * amount
           cur.execute("INSERT INTO bookings (user_id, show_id, no_of_seats, amount, offer_id) VALUES (%s, %s, %s, %s, %s);", (user_id, show_id, no_of_seats, amount, offer_id))
       conn.commit()
       cur.close()
       print(f"Successfully added 10 bookings.")
      
   except Exception as e:
       print(f"Error: {e}")
       if conn:
           conn.rollback()
   finally:
       if conn:
           conn.close()

# Function to seed all tables
def seed_all():
    """Calls all individual seeding functions to populate the database with fake data."""
    seed_users()
    seed_languages()
    seed_movies()
    seed_theaters()
    seed_screens()
    seed_movielanguages()
    seed_offers()
    seed_shows()
    seed_bookings()

if __name__ == "__main__":
    seed_all()
