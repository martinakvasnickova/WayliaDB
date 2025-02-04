-- 1. Select user by ID
SELECT * FROM contacts WHERE user_id=1;

-- 2. Select users by role
SELECT u.id AS user_id, u.first_name, u.last_name
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id
WHERE r.role_name = 'superadmin';

-- 3. Select contacts for users
SELECT u.id AS user_id, u.first_name, u.last_name, contacts.contact_value
FROM users u
JOIN contacts ON u.id = contacts.user_id

-- 4. Select ride offers of a driver
SELECT ro.departure_location, ro.arrival_location, ro.departure_time, ro.available_seats, u.first_name 
FROM ride_offers ro
JOIN users u ON ro.user_id = u.id
WHERE u.id = 7;

-- 5. Register for a ride flow

-- Driver offers a ride
INSERT INTO ride_offers (user_id, departure_location, arrival_location, departure_time, estimated_arrival_time, available_seats, price)
VALUES (6, 'Praha', 'Brno', '2025-12-01 08:00:00', '2025-12-01 10:30:00', 3, 200.00);

-- Possible passanger requests a ride
INSERT INTO ride_requests (ride_offer_id, user_id, status)
VALUES (11, 9, 'pending');

-- Driver approves the request
UPDATE ride_requests
SET status = 'accepted'
WHERE id = 11;

-- Adding passenger to table: passengers 
INSERT INTO passengers (ride_offer_id, user_id)
VALUES (11, 9);

-- Decreasing available seats 
UPDATE ride_offers
SET available_seats = available_seats - 1
WHERE id = 11;

SELECT * FROM ride_offers;
SELECT * FROM passengers;


