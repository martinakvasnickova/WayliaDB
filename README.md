# Carpooling App Database Documentation

## Overview
This database is designed for a carpooling app that allows users to offer and search for rides. It is built on PostgreSQL and includes tables for managing users, roles, contacts, ride offers, preferences, ride requests, passengers, and ratings.

---

## Database Contents
### 1. Table `users` (Users)
Stores basic user information, including name, birth date, password, and profile.

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    photo BYTEA,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Table `roles` (User Roles)
Defines system roles: `user`, `admin`, `superadmin`.

```sql
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL CHECK (role_name IN ('user', 'admin', 'superadmin'))
);
```

### 3. Table `user_roles` (User Role Assignments)
Allows users to have multiple roles.

```sql
CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE (user_id, role_id)
);
```

### 4. Table `contacts` (Contact Information)
Stores user contact details, including email, phone, and social media.

```sql
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    contact_type VARCHAR(50) CHECK (contact_type IN ('email', 'tel', 'ig', 'fb')) NOT NULL,
    contact_value VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Table `ride_offers` (Ride Offers)
Contains details about available rides, including seat availability and price.

```sql
CREATE TABLE ride_offers (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    departure_location VARCHAR(255) NOT NULL,
    arrival_location VARCHAR(255) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    estimated_arrival_time TIMESTAMP NOT NULL,
    available_seats INT NOT NULL CHECK (available_seats >= 0),
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. Table `preferences` (Basic Preferences)
Stores user preferences regarding pets and smoking.

```sql
CREATE TABLE preferences (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pets_allowed BOOLEAN DEFAULT TRUE,
    smoking_prohibited BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7. Table `custom_preferences` (Custom Preferences)
Allows users to define their own ride preferences.

```sql
CREATE TABLE custom_preferences (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    preference_name VARCHAR(255) NOT NULL,
    preference_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 8. Table `passengers` (Passengers)
Records which users are participating in a specific ride.

```sql
CREATE TABLE passengers (
    id SERIAL PRIMARY KEY,
    ride_offer_id INT NOT NULL REFERENCES ride_offers(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 9. Table `ride_requests` (Ride Requests)
Stores ride requests and their status.

```sql
CREATE TABLE ride_requests (
    id SERIAL PRIMARY KEY,
    ride_offer_id INT NOT NULL REFERENCES ride_offers(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted', 'rejected')) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 10. Table `user_ratings` (User Ratings)
Stores ratings between users as drivers or passengers.

```sql
CREATE TABLE user_ratings (
    id SERIAL PRIMARY KEY,
    rated_user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rater_user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating DECIMAL(2, 1) CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT,
    role VARCHAR(20) CHECK (role IN ('driver', 'passenger')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(rated_user_id, rater_user_id, role)
);
```

---

## Automatic Timestamp Updates
Each table includes `updated_at`, which is updated using triggers:

```sql
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Example trigger for `users`:

```sql
CREATE TRIGGER update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();
```

---

## Test Data Set
A test data set has been inserted, including users, roles, contacts, ride offers, ride requests, and ratings. The full test data can be found in the `test_data.sql` file.

---

## Test Scripts
Scripts are available to test database functionality, such as listing users by role or registering passengers for a ride. Examples:

- Listing user contacts:
```sql
SELECT * FROM contacts WHERE user_id=1;
```

- Registering a passenger for a ride:
```sql
INSERT INTO passengers (ride_offer_id, user_id) VALUES (11, 9);
```

---

This document provides an overview of the carpooling app database structure, including tables, relationships, test data, and key scripts for functionality verification.

