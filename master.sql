-- ================================================================================
-- DATABASE SETUP
-- ================================================================================
DROP DATABASE IF EXISTS airbnb;
CREATE DATABASE airbnb;
USE airbnb;

-- ================================================================================
-- PART 1: INDEPENDENT LOOKUP TABLES & USERS
-- ================================================================================

CREATE TABLE `region` (
    `id` INT PRIMARY KEY,
    `region_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `language` (
    `id` INT PRIMARY KEY,
    `language_name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `guest_type` (
    `id` INT PRIMARY KEY,
    `type_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `place_type` (
    `id` INT PRIMARY KEY,
    `type_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `property_type` (
    `id` INT PRIMARY KEY,
    `type_name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `booking_status` (
    `id` INT PRIMARY KEY,
    `status_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `category` (
    `id` INT PRIMARY KEY,
    `category_name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `attribute_category` (
    `id` INT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `review_component` (
    `id` INT PRIMARY KEY,
    `component_name` VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE `user_account` (
    `id` INT PRIMARY KEY,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255),
    `join_date` DATETIME,
    `date_host_started` DATE
);

-- ================================================================================
-- PART 2: LEVEL 1 DEPENDENCIES (Requires Part 1 tables)
-- ================================================================================

CREATE TABLE `country` (
    `id` INT PRIMARY KEY,
    `region_id` INT,
    `country_name` VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (`region_id`)
        REFERENCES `region` (`id`)
);

CREATE TABLE `attribute` (
    `id` INT PRIMARY KEY,
    `attribute_category_id` INT,
    `attribute_name` VARCHAR(100),
    `description` TEXT,
    FOREIGN KEY (`attribute_category_id`)
        REFERENCES `attribute_category` (`id`)
);

CREATE TABLE `user_language` (
    `user_id` INT,
    `language_id` INT,
    PRIMARY KEY (`user_id` , `language_id`),
    FOREIGN KEY (`user_id`)
        REFERENCES `user_account` (`id`),
    FOREIGN KEY (`language_id`)
        REFERENCES `language` (`id`)
);

-- ================================================================================
-- PART 3: LEVEL 2 DEPENDENCIES & CORE SYSTEM
-- ================================================================================

CREATE TABLE `location` (
    `id` INT PRIMARY KEY,
    `country_id` INT,
    `location_name` VARCHAR(255),
    FOREIGN KEY (`country_id`)
        REFERENCES `country` (`id`)
);


CREATE TABLE `property` (
    `id` INT PRIMARY KEY,
    `location_id` INT,
    `host_id` INT,
    `place_type_id` INT,
    `property_type_id` INT,
    `night_price` DECIMAL(10 , 2 ),
    `property_name` VARCHAR(100),
    `num_guests` TINYINT,
    `num_bed` TINYINT,
    `num_bathroom` TINYINT,
    `is_guest_favourite` TINYINT,
    `description` TEXT,
    `address_line1` VARCHAR(255),
    `address_line2` VARCHAR(255),
    FOREIGN KEY (`location_id`)
        REFERENCES `location` (`id`),
    FOREIGN KEY (`host_id`)
        REFERENCES `user_account` (`id`),
    FOREIGN KEY (`place_type_id`)
        REFERENCES `place_type` (`id`),
    FOREIGN KEY (`property_type_id`)
        REFERENCES `property_type` (`id`)
);

-- ================================================================================
-- PART 4: TRANSACTIONS & MEDIA (Requires Property & User tables)
-- ================================================================================

CREATE TABLE `booking` (
    `id` INT PRIMARY KEY,
    `property_id` INT,
    `user_id` INT,
    `booking_status_id` INT,
    `checkin_date` DATE,
    `checkout_date` DATE,
    `night_price` DECIMAL(10 , 2 ),
    `service_fee` DECIMAL(10 , 2 ),
    `cleaning_fee` DECIMAL(10 , 2 ),
    `total_price` DECIMAL(10 , 2 ),
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`),
    FOREIGN KEY (`user_id`)
        REFERENCES `user_account` (`id`),
    FOREIGN KEY (`booking_status_id`)
        REFERENCES `booking_status` (`id`)
);

CREATE TABLE `guest_booking` (
    `booking_id` INT,
    `guest_type_id` INT,
    `number_guests` TINYINT,
    PRIMARY KEY (`booking_id` , `guest_type_id`),
    FOREIGN KEY (`booking_id`)
        REFERENCES `booking` (`id`),
    FOREIGN KEY (`guest_type_id`)
        REFERENCES `guest_type` (`id`)
);

CREATE TABLE `user_review` (
    `id` INT PRIMARY KEY,
    `property_id` INT,
    `user_id` INT,
    `overall_rating` DECIMAL(3 , 2 ),
    `comment` TEXT,
    `review_date` DATE,
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`),
    FOREIGN KEY (`user_id`)
        REFERENCES `user_account` (`id`)
);

CREATE TABLE `component_rating` (
    `id` INT PRIMARY KEY,
    `component_id` INT,
    `user_review_id` INT,
    `rating` DECIMAL(3 , 2 ),
    FOREIGN KEY (`component_id`)
        REFERENCES `review_component` (`id`),
    FOREIGN KEY (`user_review_id`)
        REFERENCES `user_review` (`id`)
);

CREATE TABLE `favourite` (
    `property_id` INT,
    `user_id` INT,
    PRIMARY KEY (`property_id` , `user_id`),
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`),
    FOREIGN KEY (`user_id`)
        REFERENCES `user_account` (`id`)
);

CREATE TABLE `property_attribute` (
    `property_id` INT,
    `attribute_id` INT,
    PRIMARY KEY (`property_id` , `attribute_id`),
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`),
    FOREIGN KEY (`attribute_id`)
        REFERENCES `attribute` (`id`)
);

CREATE TABLE `product_category` (
    `id` INT PRIMARY KEY,
    `category_id` INT,
    `property_id` INT,
    FOREIGN KEY (`category_id`)
        REFERENCES `category` (`id`),
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`)
);

CREATE TABLE `image` (
    `id` INT PRIMARY KEY,
    `property_id` INT,
    `img_url` VARCHAR(2048),
    `img_order` TINYINT,
    FOREIGN KEY (`property_id`)
        REFERENCES `property` (`id`)
);


-- ================================================================================
-- TABLE 1: region
-- DESCRIPTION: Independent lookup table storing global regions (e.g., Europe, Asia).
-- DEPENDENCIES: None. Must be populated before 'country'.
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `region` (`id`, `region_name`) VALUES
(1, 'North America'), 
(2, 'Central America'), 
(3, 'South America'), (4, 'Caribbean'),
(5, 'Northern Europe'), (6, 'Western Europe'), (7, 'Eastern Europe'), (8, 'Southern Europe'),
(9, 'Middle East'), (10, 'North Africa'), (11, 'West Africa'), (12, 'East Africa'),
(13, 'Southern Africa'), (14, 'Central Africa'), (15, 'South Asia'), (16, 'Southeast Asia'),
(17, 'East Asia'), (18, 'Central Asia'), (19, 'Oceania'), (20, 'Antarctica');

-- SELECT * FROM region;
-- ================================================================================
-- TABLE 2: country
-- DESCRIPTION: Lookup table storing specific countries. 
-- DEPENDENCIES: Relies on 'region_id' from the `region` table.
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `country` (`id`, `region_id`, `country_name`) VALUES
-- North America (Region ID 1)
(1, 1, 'United States'), 
(2, 1, 'Canada'), 
(3, 1, 'Mexico'),
-- South America (Region ID 3)
(4, 3, 'Brazil'), (5, 3, 'Argentina'), (6, 3, 'Colombia'),
-- Northern & Western Europe (Region IDs 5, 6)
(7, 5, 'United Kingdom'), (8, 5, 'Sweden'), (9, 5, 'Norway'),
(10, 6, 'France'), (11, 6, 'Germany'), (12, 6, 'Netherlands'),
-- Southern Europe (Region ID 8)
(13, 8, 'Italy'), (14, 8, 'Spain'), (15, 8, 'Greece'),
-- Asia (Region IDs 15, 16, 17)
(16, 17, 'Japan'), (17, 17, 'South Korea'), (18, 15, 'India'), (19, 16, 'Thailand'),
-- Oceania (Region ID 19)
(20, 19, 'Australia'), (21, 19, 'New Zealand');


-- SELECT * FROM country;
-- ================================================================================
-- TABLE 3: location
-- DESCRIPTION: Lookup table storing specific cities or areas.
-- DEPENDENCIES: Relies on 'country_id' from the `country` table (IDs 1-21).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `location` (`id`, `country_id`, `location_name`) VALUES
-- United States (Country ID 1)
(1, 1, 'New York City'), (2, 1, 'Los Angeles'), (3, 1, 'Miami'),
-- Canada (Country ID 2)
(4, 2, 'Toronto'), (5, 2, 'Vancouver'),
-- Brazil (Country ID 4)
(6, 4, 'Rio de Janeiro'), (7, 4, 'São Paulo'),
-- United Kingdom (Country ID 7)
(8, 7, 'London'), (9, 7, 'Edinburgh'),
-- France (Country ID 10)
(10, 10, 'Paris'), (11, 10, 'Lyon'),
-- Germany (Country ID 11)
(12, 11, 'Berlin'), (13, 11, 'Munich'),
-- Italy (Country ID 13)
(14, 13, 'Rome'), (15, 13, 'Milan'), (16, 13, 'Florence'),
-- Spain (Country ID 14)
(17, 14, 'Barcelona'), (18, 14, 'Madrid'),
-- Japan (Country ID 16)
(19, 16, 'Tokyo'), (20, 16, 'Kyoto'),
-- Australia (Country ID 20)
(21, 20, 'Sydney'), (22, 20, 'Melbourne');


-- SELECT * FROM location;

-- ================================================================================
-- TABLE 4: language
-- DESCRIPTION: Independent lookup table for spoken languages.
-- DEPENDENCIES: None.
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `language` (`id`, `language_name`) VALUES
(1, 'English'), (2, 'Spanish'), (3, 'French'), (4, 'German'), 
(5, 'Italian'), (6, 'Portuguese'), (7, 'Mandarin Chinese'), (8, 'Japanese'), 
(9, 'Korean'), (10, 'Arabic'), (11, 'Russian'), (12, 'Hindi'), 
(13, 'Dutch'), (14, 'Swedish'), (15, 'Turkish'), (16, 'Polish'), 
(17, 'Vietnamese'), (18, 'Thai'), (19, 'Greek'), (20, 'Hebrew');


-- SELECT * FROM guest_type;
-- ================================================================================
-- TABLE 5: guest_type
-- DESCRIPTION: Types of guests allowed on a booking.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `guest_type` (`id`, `type_name`) VALUES
(1, 'Adult'), (2, 'Child'), (3, 'Infant'), (4, 'Pet');

-- ================================================================================
-- TABLE 6: place_type
-- DESCRIPTION: The level of privacy for the booking.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `place_type` (`id`, `type_name`) VALUES
(1, 'Entire place'), (2, 'Private room'), 
(3, 'Shared room'), (4, 'Hotel room');

-- SELECT * FROM place_type;
-- ================================================================================
-- TABLE 7: property_type
-- DESCRIPTION: The physical structure of the listing.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `property_type` (`id`, `type_name`) VALUES
(1, 'House'), (2, 'Apartment'), (3, 'Guesthouse'), 
(4, 'Hotel'),(5, 'Cabin'), (6, 'Villa'), (7, 'Castle'), 
(8, 'Treehouse'),(9, 'Boat'), (10, 'Camper/RV');


-- SELECT * FROM property_type;
-- ================================================================================
-- TABLE 8: booking_status
-- DESCRIPTION: The lifecycle states of a reservation.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `booking_status` (`id`, `status_name`) VALUES
(1, 'Pending Approval'), (2, 'Confirmed'), (3, 'Cancelled by Guest'), 
(4, 'Cancelled by Host'), (5, 'Completed');


-- SELECT * FROM booking_status;
-- ================================================================================
-- TABLE 9: attribute_category
-- DESCRIPTION: Groupings for property amenities.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `attribute_category` (`id`, `category_name`) VALUES
(1, 'Essentials'),
(2, 'Features'), 
(3, 'Location'), 
(4, 'Safety'), 
(5, 'House Rules');

-- SELECT * FROM attribute_category;

-- ================================================================================
-- TABLE 10: review_component
-- DESCRIPTION: The specific aspects a guest can rate out of 5 stars.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `review_component` (`id`, `component_name`) VALUES
(1, 'Cleanliness'), (2, 'Accuracy'), (3, 'Communication'), 
(4, 'Location'), (5, 'Check-in'), (6, 'Value');

-- SELECT * FROM review_component;

-- ================================================================================
-- TABLE 11: category
-- DESCRIPTION: Marketing tags used on the Airbnb homepage.
-- DEPENDENCIES: None.
-- ================================================================================
INSERT INTO `category` (`id`, `category_name`) VALUES
(1, 'OMG!'), (2, 'Beachfront'), (3, 'Cabins'), (4, 'Amazing pools'), 
(5, 'Countryside'), (6, 'National parks'), (7, 'Skiing'), 
(8, 'Castles'), (9, 'Camping'), (10, 'Historical homes');


-- SELECT * FROM category;

-- ================================================================================
-- TABLE 12: user_account
-- DESCRIPTION: Core table storing all users.
-- DEPENDENCIES: None.
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `user_account` (`id`, `first_name`, `last_name`, `email`, `password`, `join_date`, `date_host_started`) VALUES
(1, 'Alice', 'Smith', 'alice@example.com', 'hashed_pw_1', '2021-01-15 10:00:00', '2021-02-01'),
(2, 'Bob', 'Johnson', 'bob.j@example.com', 'hashed_pw_2', '2021-03-22 14:30:00', NULL),
(3, 'Charlie', 'Brown', 'charlie.b@example.com', 'hashed_pw_3', '2021-05-10 09:15:00', '2021-06-15'),
(4, 'Diana', 'Prince', 'diana.p@example.com', 'hashed_pw_4', '2021-08-05 11:45:00', NULL),
(5, 'Ethan', 'Hunt', 'ethan.h@example.com', 'hashed_pw_5', '2021-11-20 16:20:00', '2022-01-10'),
(6, 'Fiona', 'Gallagher', 'fiona.g@example.com', 'hashed_pw_6', '2022-01-12 08:00:00', NULL),
(7, 'George', 'Lucas', 'george.l@example.com', 'hashed_pw_7', '2022-02-14 19:30:00', '2022-03-01'),
(8, 'Hannah', 'Abbott', 'hannah.a@example.com', 'hashed_pw_8', '2022-04-18 12:10:00', NULL),
(9, 'Ian', 'Malcolm', 'ian.m@example.com', 'hashed_pw_9', '2022-06-25 15:55:00', '2022-07-20'),
(10, 'Julia', 'Roberts', 'julia.r@example.com', 'hashed_pw_10', '2022-08-30 07:45:00', NULL),
(11, 'Kevin', 'Hart', 'kevin.h@example.com', 'hashed_pw_11', '2022-10-10 18:25:00', '2022-11-05'),
(12, 'Laura', 'Dern', 'laura.d@example.com', 'hashed_pw_12', '2022-12-05 09:35:00', NULL),
(13, 'Michael', 'Scott', 'michael.s@example.com', 'hashed_pw_13', '2023-01-20 14:50:00', '2023-02-15'),
(14, 'Nina', 'Simone', 'nina.s@example.com', 'hashed_pw_14', '2023-03-15 11:20:00', NULL),
(15, 'Oscar', 'Isaac', 'oscar.i@example.com', 'hashed_pw_15', '2023-05-10 16:40:00', '2023-06-01'),
(16, 'Penelope', 'Cruz', 'penelope.c@example.com', 'hashed_pw_16', '2023-07-22 08:15:00', NULL),
(17, 'Quinn', 'Fabray', 'quinn.f@example.com', 'hashed_pw_17', '2023-09-18 13:05:00', '2023-10-10'),
(18, 'Rachel', 'Green', 'rachel.g@example.com', 'hashed_pw_18', '2023-11-05 17:30:00', NULL),
(19, 'Steve', 'Rogers', 'steve.r@example.com', 'hashed_pw_19', '2024-01-12 10:45:00', '2024-02-20'),
(20, 'Tina', 'Fey', 'tina.f@example.com', 'hashed_pw_20', '2024-03-08 15:15:00', NULL);


-- SELECT * FROM user_account;

-- ================================================================================
-- TABLE 13: property
-- DESCRIPTION: Core table storing all accommodation listings.
-- DEPENDENCIES: location_id (1-22), host_id (must be a host), 
--               place_type_id (1-4), property_type_id (1-10).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `property` (`id`, `location_id`, `host_id`, `place_type_id`, `property_type_id`,
 `night_price`, `property_name`, `num_guests`, `num_bed`, `num_bathroom`, 
 `is_guest_favourite`, `description`, `address_line1`, `address_line2`) VALUES
(1, 1, 1, 1, 2, 150.00, 'Cozy Manhattan Studio', 2, 1, 1, 1, 
'A lovely studio in the heart of NYC close to Times Square.', '123 Broadway', 'Apt 4B'),
(2, 2, 3, 1, 1, 350.50, 'Sunny LA House with Pool', 6, 3, 2, 1, 
'Spacious house near Hollywood with a private backyard and pool.', '456 Sunset Blvd', NULL),
(3, 3, 5, 2, 2, 85.00, 'Ocean View Private Room', 2, 1, 1, 0, 
'Private room in a beachfront condo. Shared living space.', '789 Ocean Drive', 'Unit 101'),
(4, 4, 7, 1, 2, 200.00, 'Downtown Toronto Loft', 4, 2, 1, 1, 
'Modern loft in the entertainment district.', '101 King St W', 'Loft 5'),
(5, 5, 9, 1, 1, 275.00, 'Vancouver Mountain Retreat', 8, 4, 3, 0, 
'Beautiful home with mountain views and quick ski access.', '202 Alpine Way', NULL),
(6, 6, 11, 1, 2, 120.00, 'Copacabana Beach Apartment', 4, 2, 1, 1, 
'Steps away from the famous Copacabana beach.', '303 Atlantica Ave', 'Apt 12'),
(7, 7, 13, 2, 1, 45.00, 'Sao Paulo Business Room', 1, 1, 1, 0, 
'Affordable room for solo business travelers.', '404 Paulista Ave', 'Room B'),
(8, 8, 15, 1, 2, 180.00, 'Classic London Flat', 3, 2, 1, 1, 'Charming flat near the British Museum.', '505 Oxford St', 'Flat 2A'),
(9, 9, 17, 1, 1, 220.00, 'Historic Edinburgh Townhouse', 5, 3, 2, 1, 'Stay in a piece of history near the castle.', '606 Royal Mile', NULL),
(10, 10, 19, 1, 2, 300.00, 'Eiffel Tower View Apartment', 2, 1, 1, 1, 'Romantic getaway with a view of the Eiffel Tower.', '707 Rue de Rivoli', '5th Floor'),
(11, 11, 1, 2, 2, 60.00, 'Quiet Room in Lyon', 2, 1, 1, 0, 'Peaceful room in the culinary capital of France.', '808 Rue de la Republique', NULL),
(12, 12, 3, 1, 2, 110.00, 'Trendy Kreuzberg Loft', 4, 2, 1, 1, 'Industrial style loft in Berlin\'s coolest neighborhood.', '909 Oranienstrasse', 'Hof 1'),
(13, 13, 5, 1, 2, 140.00, 'Munich Oktoberfest Base', 6, 3, 1, 0, 'Perfect apartment for groups visiting Oktoberfest.', '1010 Leopoldstrasse', 'Apt 3'),
(14, 14, 7, 1, 2, 160.00, 'Roman Colosseum Apartment', 4, 2, 1, 1, 'Walking distance to ancient ruins.', '1111 Via del Corso', 'Int 4'),
(15, 15, 9, 1, 2, 210.00, 'Milan Fashion District Condo', 2, 1, 1, 0, 'Luxury condo near the best shopping streets.', '1212 Via Montenapoleone', 'Suite 8'),
(16, 16, 11, 1, 6, 500.00, 'Tuscan Countryside Villa', 10, 5, 4, 1, 'Stunning historic villa with a vineyard.', '1313 Chianti Road', NULL),
(17, 17, 13, 1, 2, 130.00, 'Gothic Quarter Studio', 2, 1, 1, 1, 'Experience the old city of Barcelona.', '1414 La Rambla', 'Apt 1'),
(18, 18, 15, 2, 2, 75.00, 'Central Madrid Room', 2, 1, 1, 0, 'Comfortable room right near Plaza Mayor.', '1515 Gran Via', 'Room 3'),
(19, 19, 17, 1, 2, 190.00, 'Shibuya Neon View Apartment', 3, 2, 1, 1, 'High-rise apartment overlooking the Shibuya crossing.', '1616 Dogenzaka', 'Floor 20'),
(20, 20, 19, 1, 1, 250.00, 'Traditional Kyoto Machiya', 4, 4, 1, 1, 'Sleep on futons in a traditional wooden townhouse.', '1717 Gion Shirakawa', NULL);


-- SELECT * FROM property;

-- ================================================================================
-- TABLE 14: attribute
-- DESCRIPTION: Lookup table for specific amenities and rules.
-- DEPENDENCIES: attribute_category_id (1=Essentials, 2=Features, 3=Location, 4=Safety, 5=Rules)
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `attribute` (`id`, `attribute_category_id`, `attribute_name`, `description`) VALUES
(1, 1, 'Wifi', 'Fast and reliable internet connection.'),
(2, 1, 'Kitchen', 'Space where guests can cook their own meals.'),
(3, 1, 'Air conditioning', 'Cooling system for hot weather.'),
(4, 1, 'Heating', 'Central heating or space heaters.'),
(5, 1, 'Washer', 'In-building or in-unit washing machine.'),
(6, 1, 'Dryer', 'In-building or in-unit clothes dryer.'),
(7, 1, 'TV', 'Television, often with cable or streaming apps.'),
(8, 1, 'Iron', 'Clothes iron and ironing board.'),
(9, 1, 'Hair dryer', 'Standard bathroom hair dryer.'),
(10, 2, 'Pool', 'Private or shared swimming pool.'),
(11, 2, 'Hot tub', 'Private or shared jacuzzi/hot tub.'),
(12, 2, 'Free parking on premises', 'Dedicated parking spot for guests.'),
(13, 2, 'EV charger', 'Electric vehicle charging station.'),
(14, 2, 'Gym', 'Fitness center access.'),
(15, 3, 'Beachfront', 'Direct access to the beach.'),
(16, 3, 'Ski-in/Ski-out', 'Direct access to ski slopes.'),
(17, 4, 'Smoke alarm', 'Monitors for smoke/fire.'),
(18, 4, 'Carbon monoxide alarm', 'Monitors for CO gas.'),
(19, 4, 'Fire extinguisher', 'Emergency fire extinguisher.'),
(20, 4, 'First aid kit', 'Basic medical supplies.'),
(21, 5, 'No smoking', 'Smoking is strictly prohibited.'),
(22, 5, 'Pets allowed', 'Guests can bring their furry friends.');


-- SELECT * FROM attribute;


-- ================================================================================
-- TABLE 15: property_attribute
-- DESCRIPTION: Junction table linking properties to their specific amenities.
-- DEPENDENCIES: property_id (1-20), attribute_id (1-22).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `property_attribute` (`property_id`, `attribute_id`) VALUES
-- Property 1 (NYC Studio) gets Wifi, Kitchen, TV, No Smoking
(1, 1), (1, 2), (1, 7), (1, 21),
-- Property 2 (LA House) gets Wifi, Pool, Free Parking, Pets allowed
(2, 1), (2, 10), (2, 12), (2, 22),
-- Property 3 (Ocean View) gets Wifi, Beachfront, Air conditioning
(3, 1), (3, 15), (3, 3),
-- Property 4 (Toronto Loft) gets Wifi, Gym, Washer, Dryer
(4, 1), (4, 14), (4, 5), (4, 6),
-- Property 5 (Ski Retreat) gets Heating, Ski-in/out, Hot tub
(5, 4), (5, 16), (5, 11),
-- Let's give all remaining properties at least Wifi and a Smoke Alarm to meet the quota
(6, 1), (6, 17), (7, 1), (7, 17), (8, 1), (8, 17), (9, 1), (9, 17),
(10, 1), (10, 17), (11, 1), (11, 17), (12, 1), (12, 17), (13, 1), (13, 17),
(14, 1), (14, 17), (15, 1), (15, 17), (16, 1), (16, 17), (17, 1), (17, 17),
(18, 1), (18, 17), (19, 1), (19, 17), (20, 1), (20, 17);


-- SELECT * FROM property_attribute;

-- ================================================================================
-- TABLE 16: image
-- DESCRIPTION: Stores photo URLs and display orders for properties.
-- DEPENDENCIES: property_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `image` (`id`, `property_id`, `img_url`, `img_order`) VALUES
(1, 1, 'https://example.com/images/prop1_main.jpg', 1),
(2, 1, 'https://example.com/images/prop1_bed.jpg', 2),
(3, 2, 'https://example.com/images/prop2_pool.jpg', 1),
(4, 2, 'https://example.com/images/prop2_living.jpg', 2),
(5, 3, 'https://example.com/images/prop3_ocean.jpg', 1),(6, 4, 'https://example.com/images/prop4_loft.jpg', 1),
(7, 5, 'https://example.com/images/prop5_snow.jpg', 1),(8, 6, 'https://example.com/images/prop6_beach.jpg', 1),
(9, 7, 'https://example.com/images/prop7_room.jpg', 1),(10, 8, 'https://example.com/images/prop8_flat.jpg', 1),
(11, 9, 'https://example.com/images/prop9_house.jpg', 1),(12, 10, 'https://example.com/images/prop10_eiffel.jpg', 1),
(13, 11, 'https://example.com/images/prop11_lyon.jpg', 1),(14, 12, 'https://example.com/images/prop12_berlin.jpg', 1),
(15, 13, 'https://example.com/images/prop13_munich.jpg', 1),(16, 14, 'https://example.com/images/prop14_rome.jpg', 1),
(17, 15, 'https://example.com/images/prop15_milan.jpg', 1),(18, 16, 'https://example.com/images/prop16_tuscan.jpg', 1),
(19, 17, 'https://example.com/images/prop17_barca.jpg', 1),(20, 18, 'https://example.com/images/prop18_madrid.jpg', 1),(21, 19, 'https://example.com/images/prop19_tokyo.jpg', 1),
(22, 20, 'https://example.com/images/prop20_kyoto.jpg', 1);


-- SELECT * FROM image;

-- ================================================================================
-- TABLE 17: booking
-- DESCRIPTION: Core transaction table recording property reservations.
-- DEPENDENCIES: property_id (1-20), user_id (1-20), booking_status_id (1-5).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `booking` (`id`, `property_id`, `user_id`, 
`booking_status_id`, `checkin_date`, `checkout_date`, 
`night_price`, `service_fee`, `cleaning_fee`, `total_price`) VALUES
(1, 1, 2, 5, '2024-01-10', '2024-01-15', 
150.00, 50.00, 40.00, 840.00),
(2, 2, 4, 5, '2024-02-01', '2024-02-05', 
350.50, 100.00, 80.00, 1582.00),
(3, 3, 6, 5, '2024-03-12', '2024-03-14',
 85.00, 20.00, 15.00, 205.00),
(4, 4, 8, 2, '2024-11-20', '2024-11-25', 
200.00, 70.00, 50.00, 1120.00),
(5, 5, 10, 3, '2024-04-05', '2024-04-10', 
275.00, 90.00, 60.00, 1525.00),
(6, 6, 12, 5, '2024-05-15', '2024-05-22', 120.00, 45.00, 30.00, 915.00),
(7, 7, 14, 5, '2024-06-01', '2024-06-03', 45.00, 10.00, 10.00, 110.00),
(8, 8, 16, 2, '2024-12-10', '2024-12-15', 180.00, 60.00, 40.00, 1000.00),
(9, 9, 18, 5, '2024-07-20', '2024-07-25', 220.00, 80.00, 50.00, 1230.00),
(10, 10, 20, 1, '2024-12-24', '2024-12-30', 300.00, 110.00, 75.00, 1985.00),
(11, 11, 2, 5, '2024-08-05', '2024-08-08', 60.00, 15.00, 15.00, 210.00),
(12, 12, 4, 2, '2024-10-15', '2024-10-20', 110.00, 40.00, 25.00, 615.00),
(13, 13, 6, 4, '2024-09-20', '2024-09-25', 140.00, 50.00, 35.00, 785.00),
(14, 14, 8, 5, '2024-02-14', '2024-02-18', 160.00, 55.00, 40.00, 735.00),
(15, 15, 10, 5, '2024-03-01', '2024-03-05', 210.00, 75.00, 50.00, 965.00),
(16, 16, 12, 2, '2025-05-10', '2025-05-17', 500.00, 200.00, 100.00, 3800.00),
(17, 17, 14, 5, '2024-04-10', '2024-04-14', 130.00, 45.00, 30.00, 595.00),
(18, 18, 16, 5, '2024-05-20', '2024-05-22', 75.00, 20.00, 15.00, 185.00),
(19, 19, 18, 1, '2025-03-15', '2025-03-25', 190.00, 80.00, 50.00, 2030.00),
(20, 20, 20, 2, '2025-04-01', '2025-04-07', 250.00, 90.00, 60.00, 1650.00);


-- SELECT * FROM booking;

-- ================================================================================
-- TABLE 18: guest_booking
-- DESCRIPTION: Junction table mapping how many of each guest type are on a booking.
-- DEPENDENCIES: booking_id (1-20), guest_type_id (1=Adult, 2=Child, 3=Infant, 4=Pet).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `guest_booking` (`booking_id`, `guest_type_id`, `number_guests`) VALUES
(1, 1, 2), (2, 1, 4), (2, 2, 2), (3, 1, 1), (4, 1, 2), 
(4, 4, 1), (5, 1, 4), (5, 2, 4), (6, 1, 2), (6, 3, 1), 
(7, 1, 1), (8, 1, 2), (9, 1, 2), (9, 2, 1), (10, 1, 2), 
(11, 1, 1), (12, 1, 2), (13, 1, 3), (14, 1, 2), (15, 1, 2), 
(16, 1, 6), (16, 2, 4), (17, 1, 2), (18, 1, 1), (19, 1, 2), 
(20, 1, 2), (20, 2, 2);

-- SELECT * FROM guest_booking;

-- ================================================================================
-- TABLE 19: user_review
-- DESCRIPTION: Overall review left by a user for a property they stayed at.
-- DEPENDENCIES: property_id (1-20), user_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `user_review` (`id`, `property_id`, `user_id`, 
`overall_rating`, `comment`, `review_date`) VALUES
(1, 1, 2, 4.80, 'Great location, very clean studio!', '2024-01-16'),
(2, 2, 4, 5.00, 'Amazing pool and very spacious.', '2024-02-06'),
(3, 3, 6, 4.50, 'Nice view but the shared area was a bit noisy.', '2024-03-15'),
(4, 6, 12, 4.90, 'Loved being right on the beach.', '2024-05-23'),
(5, 7, 14, 4.00, 'Good for business, very basic.', '2024-06-04'),
(6, 9, 18, 5.00, 'Absolutely stunning historic home!', '2024-07-26'),
(7, 11, 2, 4.70, 'Very quiet and comfortable.', '2024-08-09'),
(8, 14, 8, 4.95, 'Can literally see the Colosseum from the window.', '2024-02-19'),
(9, 15, 10, 5.00, 'Luxury at its finest.', '2024-03-06'),
(10, 17, 14, 4.60, 'Great spot in the Gothic Quarter.', '2024-04-15'),
(11, 18, 16, 4.20, 'Room was small but location made up for it.', '2024-05-23'),
(12, 1, 6, 4.85, 'Would stay here again!', '2024-02-10'),
(13, 2, 10, 4.90, 'Perfect for our family vacation.', '2024-03-20'),
(14, 8, 12, 4.50, 'Charming flat, but stairs were steep.', '2024-04-05'),
(15, 10, 16, 5.00, 'The view of the Eiffel Tower is unmatched.', '2024-05-12'),
(16, 12, 18, 4.80, 'Super trendy and cool vibe.', '2024-06-18'),
(17, 19, 2, 4.90, 'Neon views were exactly as advertised.', '2024-07-02'),
(18, 20, 4, 5.00, 'A beautiful, traditional Kyoto experience.', '2024-08-15'),
(19, 4, 14, 4.70, 'Awesome loft in Toronto.', '2024-09-10'),
(20, 5, 20, 4.95, 'Skiing was great, loved the hot tub.', '2024-10-05');


-- SELECT * FROM user_review;
-- ================================================================================
-- TABLE 20: component_rating
-- DESCRIPTION: Granular ratings (e.g., Cleanliness, Check-in) for a specific review.
-- DEPENDENCIES: component_id (1-6), user_review_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `component_rating` (`id`, `component_id`,
 `user_review_id`, `rating`) VALUES
(1, 1, 1, 5.00), (2, 2, 1, 4.80), (3, 3, 1, 5.00),
(4, 1, 2, 5.00), (5, 4, 2, 5.00), (6, 5, 2, 4.90),
(7, 1, 3, 4.50), (8, 6, 3, 4.20),(9, 1, 4, 4.90), 
(10, 4, 4, 5.00),(11, 6, 5, 4.00), (12, 3, 5, 4.50),
(13, 1, 6, 5.00), (14, 2, 6, 5.00), (15, 4, 6, 5.00),
(16, 1, 7, 4.80), (17, 5, 7, 4.90),(18, 4, 8, 5.00),
(19, 2, 8, 4.90),(20, 1, 9, 5.00), (21, 6, 9, 4.80),
(22, 1, 10, 4.60), (23, 4, 10, 4.90);

-- SELECT * FROM component_rating;

-- ================================================================================
-- TABLE 21: favourite
-- DESCRIPTION: Junction table storing properties that users have saved.
-- DEPENDENCIES: property_id (1-20), user_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `favourite` (`property_id`, `user_id`) VALUES
(1, 4), (2, 4), (10, 4), (19, 4),
(3, 8), (6, 8), (15, 8), 
(5, 12), (9, 12), (12, 12), (13, 12), 
(7, 14), (17, 14), (18, 14), 
(4, 16), (8, 16), (20, 16), 
(11, 2), (14, 2), (16, 2), (1, 20);

-- SELECT * FROM favourite;

-- ================================================================================
-- TABLE 22: product_category
-- DESCRIPTION: Junction table linking properties to marketing categories.
-- DEPENDENCIES: category_id (1-10), property_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `product_category` (`id`, `category_id`, `property_id`) VALUES
(1, 2, 3), (2, 2, 6), -- Beachfront
(3, 4, 2), -- Amazing pools
(4, 7, 5), -- Skiing
(5, 8, 9), (6, 8, 16), -- Castles/Historical
(7, 10, 9), (8, 10, 16), (9, 10, 20), -- Historical homes
(10, 1, 19), (11, 1, 10), -- OMG!
(12, 5, 16), (13, 5, 11), -- Countryside
(14, 4, 16), (15, 1, 12),
(16, 3, 5), (17, 10, 14), (18, 1, 14),
(19, 2, 17), (20, 10, 8);

-- SELECT * FROM product_category;

-- ================================================================================
-- TABLE 23: user_language
-- DESCRIPTION: Junction table storing the languages spoken by users/hosts.
-- DEPENDENCIES: user_id (1-20), language_id (1-20).
-- REQUIREMENT: At least 20 records.
-- ================================================================================
INSERT INTO `user_language` (`user_id`, `language_id`) VALUES
-- Most speak English (ID 1)
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), 
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
-- Adding secondary languages
(1, 2), -- Alice speaks Spanish
(3, 4), -- Charlie speaks German
(5, 3), -- Ethan speaks French
(7, 5), -- George speaks Italian
(9, 8), -- Ian speaks Japanese
(11, 6), -- Kevin speaks Portuguese
(13, 2), -- Michael speaks Spanish
(15, 5), -- Oscar speaks Italian
(17, 8), -- Quinn speaks Japanese
(19, 1), (19, 4), (20, 1), (20, 2);


-- SELECT * FROM user_language;

SELECT 
    p.property_name AS 'Listing',
    ac.category_name AS 'Amenity Category',
    a.attribute_name AS 'Amenity'
FROM
    property p
        JOIN
    property_attribute pa ON p.id = pa.property_id
        JOIN
    attribute a ON pa.attribute_id = a.id
        JOIN
    attribute_category ac ON a.attribute_category_id = ac.id
ORDER BY p.id , ac.category_name
LIMIT 12;

-- View Bookings, the Guest who booked it, and the breakdown of guest types
SELECT 
    b.id AS 'Booking ID',
    p.property_name AS 'Property',
    CONCAT(u.first_name, ' ', u.last_name) AS 'Primary Guest',
    gt.type_name AS 'Guest Type',
    gb.number_guests AS 'Count'
FROM
    booking b
        JOIN
    property p ON b.property_id = p.id
        JOIN
    user_account u ON b.user_id = u.id
        JOIN
    guest_booking gb ON b.id = gb.booking_id
        JOIN
    guest_type gt ON gb.guest_type_id = gt.id
ORDER BY b.id
LIMIT 12;


-- View specific component ratings attached to an overall user review
SELECT 
    p.property_name AS 'Property',
    ur.overall_rating AS 'Overall Score',
    rc.component_name AS 'Metric',
    cr.rating AS 'Metric Score'
FROM
    user_review ur
        JOIN
    property p ON ur.property_id = p.id
        JOIN
    component_rating cr ON ur.id = cr.user_review_id
        JOIN
    review_component rc ON cr.component_id = rc.id
ORDER BY ur.id
LIMIT 10;

-- ================================================================================
-- PHASE 3: METADATA & DATABASE VOLUME
-- Description: Calculates the total physical size of the database in Megabytes (MB).
-- Purpose: Fulfills the final portfolio requirement to provide exact database volume.
-- Note: This queries the MySQL Information Schema to accurately sum the combined 
--       lengths of all data and indexes within the 'airbnb' schema.
-- ================================================================================
SELECT table_schema AS "Database Name", 
ROUND(SUM(data_length + index_length) / 1024 / 1024, 3) AS "Size in MB" 
FROM information_schema.TABLES 
WHERE table_schema = "airbnb" 
GROUP BY table_schema;
