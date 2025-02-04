-- 1. Table for users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    role VARCHAR(20) CHECK (role IN ('user', 'admin', 'superadmin')) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    photo BYTEA,  -- Fotka jako binární data
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Deleting roles from user table
ALTER TABLE users DROP COLUMN role;

-- Roles(user, admin, superadmin)
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL CHECK (role_name IN ('user', 'admin', 'superadmin'))
);

-- 2. Table connecting users with roles
CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE (user_id, role_id) -- Each role can be add to user only once
);




-- 3. Table for contacts (email, telefon, IG, FB...)
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- Odkaz na uživatele
    contact_type VARCHAR(50) CHECK (contact_type IN ('email', 'tel', 'ig', 'fb')) NOT NULL,
    contact_value VARCHAR(255) NOT NULL,  -- Hodnota kontaktu (např. emailová adresa, telefonní číslo)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Table for ride offers
CREATE TABLE ride_offers (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- Řidič, který nabízí jízdu
    departure_location VARCHAR(255) NOT NULL,
    arrival_location VARCHAR(255) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    estimated_arrival_time TIMESTAMP NOT NULL,
    available_seats INT NOT NULL CHECK (available_seats >= 0),  -- Počet volných míst
    price DECIMAL(10, 2) NOT NULL,  -- Cena jízdy
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Table for preferences - smoaking, animals
CREATE TABLE preferences (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
    pets_allowed BOOLEAN DEFAULT TRUE,  
    smoking_prohibited BOOLEAN DEFAULT TRUE,  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Table for customizing preferences
CREATE TABLE custom_preferences (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE, 
    preference_name VARCHAR(255) NOT NULL, 
    preference_value TEXT NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Table for passangers
CREATE TABLE passengers (
    id SERIAL PRIMARY KEY,
    ride_offer_id INT NOT NULL REFERENCES ride_offers(id) ON DELETE CASCADE,  -- reference to driver
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- reference to passanger
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Table for ride requests
CREATE TABLE ride_requests (
    id SERIAL PRIMARY KEY,
    ride_offer_id INT NOT NULL REFERENCES ride_offers(id) ON DELETE CASCADE,  
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
    request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted', 'rejected')) DEFAULT 'pending', 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Table for ratings
CREATE TABLE user_ratings (
    id SERIAL PRIMARY KEY,
    rated_user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- Is rated
    rater_user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- Is rating
    rating DECIMAL(2, 1) CHECK (rating >= 1 AND rating <= 5) NOT NULL,  -- Rating between 1-5
    comment TEXT,  -- Volitelný komentář
    role VARCHAR(20) CHECK (role IN ('driver', 'passenger')) NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(rated_user_id, rater_user_id, role)  
);



-- -- Trigger pro automatické aktualizování časů při změnách v tabulkách
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_contacts_timestamp
    BEFORE UPDATE ON contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_ride_offers_timestamp
    BEFORE UPDATE ON ride_offers
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_preferences_timestamp
    BEFORE UPDATE ON preferences
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_custom_preferences_timestamp
    BEFORE UPDATE ON custom_preferences
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_passengers_timestamp
    BEFORE UPDATE ON passengers
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_ride_requests_timestamp
    BEFORE UPDATE ON ride_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_user_ratings_timestamp
    BEFORE UPDATE ON user_ratings
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();
