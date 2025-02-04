INSERT INTO roles (role_name)
VALUES
('user'),
('admin'),
('superadmin');

INSERT INTO users (first_name, last_name, birth_date, password_hash, bio)
VALUES
('Jan', 'Novák', '1985-02-15', 'hashed_pass1', 'Rád cestuji a poznávám nové lidi.'),
('Anna', 'Dvořáková', '1990-11-08', 'hashed_pass2', 'Studentka, která jezdí často mezi městy.'),
('Petr', 'Svoboda', '1978-07-12', 'hashed_pass3', 'Řidič s dlouholetou praxí.'),
('Eva', 'Horáková', '1983-09-25', 'hashed_pass4', 'Jezdím za rodinou, hledám sdílené jízdy.'),
('Karel', 'Veselý', '1995-04-03', 'hashed_pass5', 'Mladý nadšenec do aut.'),
('Lucie', 'Procházková', '1992-12-01', 'hashed_pass6', 'Organizátorka spolujízd.'),
('Tomáš', 'Král', '1988-05-20', 'hashed_pass7', 'Jezdím na pravidelné trase mezi Brnem a Prahou.'),
('Adéla', 'Malá', '1997-03-14', 'hashed_pass8', 'Cestuji za prací i zábavou.'),
('Filip', 'Novotný', '2000-08-30', 'hashed_pass9', 'Student, co hledá levné spolujízdy.'),
('Michaela', 'Pokorná', '1986-06-10', 'hashed_pass10', 'Ráda poznávám nové lidi na cestách.');

INSERT INTO user_roles (user_id, role_id) 
VALUES 
(1, 1), 
(1, 2), 
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1);

INSERT INTO contacts (user_id, contact_type, contact_value)
VALUES
(1, 'email', 'jan.novak@waylia.com'),
(1, 'tel', '+420723123456'),
(2, 'email', 'anna.dvorakova@waylia.com'),
(2, 'tel', '+420333123456'),
(3, 'email', 'petr.svoboda@waylia.com'),
(3, 'tel', '+420777654321'),
(4, 'email', 'eva.horakova@gmail.com'),
(4, 'tel', '+420723123888'),
(5, 'email', 'karel.vesely@mail.com'),
(5, 'tel', '+420457555456'),
(6, 'email', 'lucie.prochazkova@seznam.cz'),
(6, 'tel', '+420457555732'),
(6, 'fb', 'https://facebook.com/lucieprochazkova'),
(7, 'email', 'tomas.kral@seznam.cz'),
(7, 'tel', '+420457555879'),
(8, 'email', 'adela.mala@gmail.com'),
(8, 'tel', '+420457472456'),
(9, 'email', 'filip.novotny@gmail.com'),
(9, 'tel', '+420239555456'),
(10, 'email', 'michaela.pokorna@seznam.cz'),
(10, 'tel', '+420457555892');

INSERT INTO ride_offers (user_id, departure_location, arrival_location, departure_time, estimated_arrival_time, available_seats, price)
VALUES
(7, 'Praha', 'Brno', '2025-02-01 08:00:00', '2025-02-01 10:30:00', 3, 200.00),
(6, 'Brno', 'Olomouc', '2025-02-02 14:00:00', '2025-02-02 15:30:00', 2, 150.00),
(8, 'Hradec Králové', 'Pardubice', '2025-02-03 09:00:00', '2025-02-03 09:30:00', 4, 50.00),
(7, 'Praha', 'Plzeň', '2025-02-01 16:00:00', '2025-02-01 18:00:00', 2, 180.00),
(6, 'České Budějovice', 'Praha', '2025-02-04 07:00:00', '2025-02-04 09:30:00', 3, 250.00),
(6, 'Liberec', 'Praha', '2025-02-02 12:00:00', '2025-02-02 14:00:00', 1, 300.00),
(7, 'Zlín', 'Olomouc', '2025-02-05 08:00:00', '2025-02-05 09:15:00', 3, 100.00),
(5, 'Karlovy Vary', 'Praha', '2025-02-03 15:00:00', '2025-02-03 17:30:00', 4, 280.00),
(7, 'Brno', 'Praha', '2025-02-06 06:00:00', '2025-02-06 09:00:00', 3, 200.00),
(7, 'Praha', 'České Budějovice', '2025-02-07 10:00:00', '2025-02-07 12:30:00', 2, 220.00);

INSERT INTO ride_requests (ride_offer_id, user_id, status)
VALUES
(1, 7, 'accepted'),
(1, 8, 'pending'),
(2, 6, 'pending'),
(3, 8, 'rejected');

INSERT INTO passengers (ride_offer_id, user_id)
VALUES
(1, 7);

INSERT INTO preferences (user_id, pets_allowed, smoking_prohibited)
VALUES
(1, TRUE, TRUE),
(2, TRUE, FALSE),
(3, FALSE, TRUE),
(4, TRUE, TRUE),
(5, FALSE, FALSE),
(6, TRUE, TRUE),
(7, TRUE, TRUE),
(8, TRUE, FALSE),
(9, FALSE, TRUE),
(10, TRUE, TRUE);

INSERT INTO custom_preferences (user_id, preference_name, preference_value)
VALUES
(1, 'Window Preference', 'I prefer an open window during the ride.'),
(2, 'Music', 'Please no loud music.'),
(3, 'Food', 'Snacks allowed.'),
(4, 'Temperature', 'I like warm temperature in the car.'),
(5, 'Window Preference', 'Please keep the windows closed.'),
(6, 'Seating', 'I prefer to sit in the front seat.'),
(7, 'Conversation', 'I prefer quiet rides.'),
(8, 'Pets', 'I love pets, bring them along!'),
(9, 'Music', 'I enjoy light music.'),
(10, 'Food', 'Please no eating during the ride.');

INSERT INTO user_ratings (rated_user_id, rater_user_id, rating, comment, role)
VALUES
(1, 2, 4.5, 'Skvělý spolujezdec!', 'passenger'),
(3, 4, 5.0, 'Řidič byl velmi ochotný a příjemný.', 'driver'),
(5, 6, 3.5, 'Auto nebylo moc čisté.', 'driver'),
(7, 8, 4.0, 'Cesta byla v pořádku, ale řidič jel trochu rychleji.', 'driver'),
(9, 10, 5.0, 'Super komunikace a organizace.', 'passenger'),
(2, 1, 4.0, 'Jízda proběhla hladce.', 'passenger'),
(4, 3, 3.0, 'Trochu hlučný.', 'passenger'),
(6, 5, 4.5, 'Dobrá cesta, doporučuji.', 'driver'),
(8, 7, 5.0, 'Perfektní komunikace!', 'passenger'),
(10, 9, 4.5, 'Vše šlo hladce.', 'passenger');
