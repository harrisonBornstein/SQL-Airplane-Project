-- TDDD37 - Database Technology Project
-- VILAS Tony _ tonvi217
-- BORNSTEIN Harrison _ harbo085

-- 3.a)
-- Creation of the Tables --


DROP TABLE IF EXISTS
	CITY,
	AIRPORT,
	ROUTE,
	DAY,
	YEAR,
	WEEKDAY,
	WEEKLYFLIGHT,
	FLIGHT,
	RESERVATION,
	CCHOLDER,
	BOOKING,
	PASSENGER,
	PGROUP,
	TRAVELLER,
	CUSTOMER
	;


-- The City table allows storing for all the necessary information on every city the company will be led to travel to.  --
CREATE TABLE CITY (
	id		INT(8) 		NOT NULL AUTO_INCREMENT,
	name	VARCHAR(25)
	);

-- The Airport table contains information on every airport in which BrianAir operates such as its name and City. 
-- The reason for it is that one City can have several Airports.
CREATE TABLE AIRPORT(
	id		INT(8) 		NOT NULL AUTO_INCREMENT,
	name	VARCHAR(25),
	city 	INT(8)	
);

-- The Route table corresponds to a travel from one Airport to another. 
-- It has its own routePrice as per the requirements
-- and takes a certain amount of time stored in the length attribute
-- Its Primary key is composed of the primary keys of the airports linked by this route and the year for which the routePrice is applicable.
CREATE TABLE ROUTE(
	airportDep	INT(8),
	airportDest	INT(8),
	length		TIME,
	price		FLOAT(8,2)
);


-- The Day table stores the seven days of a week. Initially, this is so in order to avoid invalid dayOfWeek entries in the WeeklyFlight table. 
CREATE TABLE DAY(
	id		INT(8) 		NOT NULL,
	name	VARCHAR(15)
	);

-- The Year table stores the years during which BrianAir operates.
CREATE TABLE YEAR(
	year 	int(4)
);


-- The WeekDay table stores the seven days of a week.
-- Initially, this is so in order to avoid invalid dayOfWeek entries in the WeeklyFlight table. 
-- We also store in this table the price factor of each week day, used in the calculation of the final flight price.
-- The year during which the said priceFactor is applied is also stored.  
CREATE TABLE WEEKDAY(
	day		INT(8),
	year		INT(4),
	priceFactor	FLOAT(5,2)
);

-- The WeeklyFlight table stores all the flights the company proposes on a weekly basis.
-- As mentioned in the instructions, this offer is the same all year long.
-- The flights stored in this table are thus “template flights” of which a Flight is a particular instance. 
-- A WeeklyFlight takes place on a specific dayOfWeek, at a given depTime, and takes a Route.
CREATE TABLE WEEKLYFLIGHT(
	id			INT(8) 		NOT NULL AUTO_INCREMENT,
	dayOfWeek	INT(1),
	depTime		TIME,
	route 		INT(8)
);

-- The Flight table contains particular instances of a WeeklyFlight, which occur at a precise date, and have a number of openSeats left.
CREATE TABLE FLIGHT(
	id				INT(8) 		NOT NULL AUTO_INCREMENT,
	fdate			DATE,
	openSeats		INT(3),
	weeklyflight 	INT(8)
);

-- The Reservation table stores information on the reservation made by a Customer on a specific Flight for a given Group. 
-- A Reservation is paid for by a CCHolder (Credit Card Holder).
CREATE TABLE RESERVATION(
	id			INT(8) 		NOT NULL AUTO_INCREMENT,
	pgroup 		INT(8),
	flight		INT(8),
	ccholder	INT(8),
	customer	INT(8),
);

-- The CCHolder (Credit Card Holder) table stores the Credit Card information ccInfo about the payment made for a Reservation 
-- as well as the FName and LName of its owner.
CREATE TABLE CCHOLDER(
	id			INT(8) 		NOT NULL AUTO_INCREMENT,
	ccInfo		VARCHAR(30),
	FName		VARCHAR(25),
	LName		VARCHAR(25)
);

-- The Booking table contains the finalPrice of a Reservation as well as all the information of this reservation. 
-- At BrianAir, a Reservation becomes a booking when it has been paid for. Only a Booking allows taking seats on a Flight. 
-- The Flight.openSeats attribute is thus only decremented when a Reservation has successfully become a Booking.
CREATE TABLE BOOKING(
	id			INT(8) 		NOT NULL AUTO_INCREMENT,
	finalPrice	FLOAT(11,2),
	reservation INT(8)
);

-- The Passenger table contains basic passengers’ information such as FName and LName. 
-- A Passenger is the general designation of someone partaking in a Flight.
CREATE TABLE PASSENGER(
	id			INT(8) 		NOT NULL AUTO_INCREMENT,
	FName		VARCHAR(25),
	LName		VARCHAR(25)

);

-- The Group table stores information on the group of Passengers partaking in a Reservation. 
-- A Group can be constituted of one or several Passengers who all participate in the same Reservation.
CREATE TABLE PGROUP(
	passenger 	INT(8),
	reservation INT(8)
);

-- The Traveller table contains the ticketNumber attributed to a Passenger for a given Booking. 
-- Entries into this table are made automatically when the Booking is confirmed.
CREATE TABLE TRAVELLER(
	ticketNumber	INT NOT NULL AUTO_INCREMENT,
	passenger 		INT(8),
	booking 		INT(8)
);

-- The Customer table contains information on a Passenger in addition to contact details such as email or phoneNumber. 
-- A Customer is a Passenger who manages one or several Reservation(s).
CREATE TABLE CUSTOMER(
	passenger 	INT(8),
	email		VARCHAR(60),
	phoneNumber VARCHAR(15)
);


-- Definition of Primary Key constraints --
ALTER TABLE CITY			ADD CONSTRAINT city_id_pk	PRIMARY KEY (id) ;
ALTER TABLE AIRPORT			ADD CONSTRAINT airport_id_pk	PRIMARY KEY (id);
ALTER TABLE ROUTE			ADD CONSTRAINT route_dep_dest_pk	PRIMARY KEY (airportDep, airportDest);
ALTER TABLE DAY				ADD CONSTRAINT day_id_pk	PRIMARY KEY (id);
ALTER TABLE YEAR			ADD CONSTRAINT year_year_pk	PRIMARY KEY (year);
ALTER TABLE WEEKDAY			ADD CONSTRAINT weekday_day_year_pk	PRIMARY KEY (day, year);
ALTER TABLE WEEKLYFLIGHT	ADD CONSTRAINT weeklyflight_id_pk	PRIMARY KEY (id);
ALTER TABLE FLIGHT			ADD CONSTRAINT flight_id_pk	PRIMARY KEY (id);
ALTER TABLE RESERVATION		ADD CONSTRAINT reservation_id_pk	PRIMARY KEY (id);
ALTER TABLE CCHOLDER		ADD CONSTRAINT ccholder_id_pk	PRIMARY KEY (id);
ALTER TABLE BOOKING			ADD CONSTRAINT booking_id_pk	PRIMARY KEY (id);
ALTER TABLE PASSENGER		ADD CONSTRAINT passenger_id_pk	PRIMARY KEY (id);
ALTER TABLE pGROUP			ADD CONSTRAINT pgroup_passngr_resrvtn_pk	PRIMARY KEY (passenger, reservation);
ALTER TABLE TRAVELLER		ADD CONSTRAINT traveller_ticketnum_pk	PRIMARY KEY (ticketNumber);
ALTER TABLE CUSTOMER		ADD CONSTRAINT customer_passenger_pk	PRIMARY KEY (passenger);

-- Definition of Foreign Key constraints --

ALTER TABLE AIRPORT 		ADD (
	CONSTRAINT 	airport_city_fk	FOREIGN KEY (city)
	REFERENCES CITY(id)
);

ALTER TABLE ROUTE 			ADD (
	CONSTRAINT 	route_airportdep_fk	FOREIGN KEY (airportDep)
	REFERENCES 	AIRPORT(id),
	CONSTRAINT 	route_airportdest_fk	FOREIGN KEY (airportDest)
	REFERENCES 	AIRPORT(id)
);

ALTER TABLE WEEKDAY 		ADD (
	CONSTRAINT 	weekday_day_fk	FOREIGN KEY (day)
	REFERENCES	DAY(id),
	CONSTRAINT 	weekday_year_fk	FOREIGN KEY (year)
	REFERENCES	YEAR(year)
);

ALTER TABLE WEEKLYFLIGHT 	ADD (
	CONSTRAINT 	weeklyflight_route_fk	FOREIGN KEY (route)
	REFERENCES 	ROUTE(id),
	CONSTRAINT 	weeklyflight_dayofweek_fk	FOREIGN KEY (dayOfWeek)
	REFERENCES 	WEEKDAY(id)
);

ALTER TABLE FLIGHT 			ADD (
	CONSTRAINT 	flight_weeklyflight_fk	FOREIGN KEY (weeklyflight)
	REFERENCES 	WEEKLYFLIGHT(id)
);

ALTER TABLE RESERVATION 	ADD (
	CONSTRAINT 	preservation_group_fk	FOREIGN KEY (pgroup)
	REFERENCES 	pGROUP(id),
	CONSTRAINT 	reservation_flight_fk	FOREIGN KEY (flight)
	REFERENCES 	FLIGHT(id),
	CONSTRAINT 	reservation_ccholder_fk	FOREIGN KEY (ccholder)
	REFERENCES 	CCHOLDER(id),
	CONSTRAINT 	reservation_customer_fk	FOREIGN KEY (customer)
	REFERENCES 	CUSTOMER(id)
);

ALTER TABLE BOOKING 		ADD (
	CONSTRAINT 	booking_reservation_fk	FOREIGN KEY (reservation)
	REFERENCES 	RESERVATION(id)
);

ALTER TABLE pGROUP 			ADD (
	CONSTRAINT 	pgroup_passenger_fk	FOREIGN KEY (passenger)
	REFERENCES 	PASSENGER(id),
	CONSTRAINT 	pgroup_reservation_fk	FOREIGN KEY (reservation)
	REFERENCES 	RESERVATION(id)
);
ALTER TABLE TRAVELLER 		ADD (
	CONSTRAINT 	traveller_passenger_fk	FOREIGN KEY (passenger)
	REFERENCES 	PASSENGER(id),
	CONSTRAINT 	traveller_booking_fk	FOREIGN KEY (booking)
	REFERENCES 	BOOKING(id)
);
ALTER TABLE CUSTOMER 		ADD (
	CONSTRAINT 	customer_passenger_fk	FOREIGN KEY (passenger)
	REFERENCES 	PASSENGER(id),
);


-- 3.b)
-- Population of the tables with data

INSERT INTO CITY (id, name) VALUES (1, "dublin");
INSERT INTO CITY (id, name) VALUES (2, "lyon");
INSERT INTO CITY (id, name) VALUES (3, "stockholm");
INSERT INTO CITY (id, name) VALUES (4, "dallas");
COMMIT; 

INSERT INTO AIRPORT (id, name, city) VALUES (1, "dub", 1);
INSERT INTO AIRPORT (id, name, city) VALUES (2, "lys", 2);
INSERT INTO AIRPORT (id, name, city) VALUES (3, "arn", 3);
INSERT INTO AIRPORT (id, name, city) VALUES (4, "dfw", 4);
COMMIT;

INSERT INTO ROUTE (airportDep, airportDest, price) VALUES (1, 2, '02:15:00', 150.00);	-- Dublin-Lyon
INSERT INTO ROUTE (airportDep, airportDest, price) VALUES (2, 4, '16:00:00', 1500.00);	-- Lyon-Dallas
INSERT INTO ROUTE (airportDep, airportDest, price) VALUES (3, 1, '05:05:00', 75.00);	-- Stockholm-Dublin
INSERT INTO ROUTE (airportDep, airportDest, price) VALUES (4, 3, '14:50:00', 2000.00);	-- Dallas-Stockholm
COMMIT;

INSERT INTO DAY (id, name) VALUES 	(1,"Monday"),
									(2,"Tuesday"),
									(3,"Wednesday"),
									(4,"Thursday"),
									(5,"Friday"),
									(6,"Saturday"),
									(7,"Sunday");
COMMIT;

INSERT INTO YEAR (year) VALUES (2014);
INSERT INTO YEAR (year) VALUES (2015);
COMMIT;

INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (1, 2014, 0.5); -- Mondays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (2, 2014, 1.0); -- Tuesdays 2014 
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (3, 2014, 1.5); -- Wednesdays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (4, 2014, 1.5); -- Thursdays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (5, 2014, 4.5); -- Fridays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (6, 2014, 6.0); -- Saturdays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (7, 2014, 4.5); -- Sundays 2014
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (1, 2015, 1.0); -- Mondays 2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (2, 2015, 1.5); -- Tuesdays  2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (3, 2015, 2.0); -- Wednesdays 2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (4, 2015, 2.0); -- Thursdays 2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (5, 2015, 5.0); -- Fridays 2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (6, 2015, 6.5); -- Saturdays 2015
INSERT INTO WEEKDAY (day, year, priceFactor) VALUES (7, 2015, 5.0); -- Sundays 2015
COMMIT;

INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (1, 3, 2014, '06:35:00', 1, 2);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (2, 5, 2014, '13:40:00', 4, 3);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (3, 6, 2014, '20:00:00', 3, 1);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (4, 6, 2014, '14:50:00', 2, 4);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (5, 2, 2015, '04:30:00', 4, 3);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (6, 3, 2015, '22:15:00', 2, 4);
INSERT INTO WEEKLYFLIGHT (id, dayOfWeek, depTime, route) VALUES (7, 7, 2015, '17:30:00', 1, 2);
COMMIT;
/*
Should not be hard coded but computed by a stored procedure.
The procedure should go through all the Weeklyflights and create an instance of Flight for each date where the day and the date correspond.

INSERT INTO FLIGHT (id, fdate, openSeats, weeklyflight) VALUES (1, '2014-08-27', 27, 1);
INSERT INTO FLIGHT (id, fdate, openSeats, weeklyflight) VALUES (2, '2014-12-26', 4, 2);
INSERT INTO FLIGHT (id, fdate, openSeats, weeklyflight) VALUES (3, '2015-01-11', 60, 7);
INSERT INTO FLIGHT (id, fdate, openSeats, weeklyflight) VALUES (4, '2015-07-14', 60, 5);
COMMIT;
*/

CREATE PROCEDURE populate_flights 
BEGIN
	INSERT INTO FLIGHT (fdate, openSeats, weeklyflight) VALUES (, 60, );
END;

INSERT INTO CCHOLDER (id, ccInfo, FName, LName) VALUES (1, 'ccinfoholder1', 'Harrison', 'Bornstein');
INSERT INTO CCHOLDER (id, ccInfo, FName, LName) VALUES (2, 'ccinfoholder2', 'Tony', 'Vilas');
INSERT INTO CCHOLDER (id, ccInfo, FName, LName) VALUES (3, 'ccinfoholder3', 'James', 'Bond');
INSERT INTO CCHOLDER (id, ccInfo, FName, LName) VALUES (4, 'ccinfoholder4', 'Carl', 'Gustaf');
COMMIT;
/*
INSERT INTO BOOKING (id, finalPrice, reservation) VALUES (valA, valB, ...);
COMMIT;
*/
INSERT INTO PASSENGER (id, FName, LName) VALUES (1, 'Harrison', 'Bornstein');
INSERT INTO PASSENGER (id, FName, LName) VALUES (2, 'Tony', 'Vilas');
INSERT INTO PASSENGER (id, FName, LName) VALUES (3, 'Lorenzo', 'Masciolini');
INSERT INTO PASSENGER (id, FName, LName) VALUES (4, 'Jonas', 'Vorwerg');
COMMIT;
/*
INSERT INTO pGROUP (passenger, reservation) VALUES (valA, valB, ...);
COMMIT;
INSERT INTO TRAVELLER (ticketNumber, passenger, booking) VALUES (valA, valB, ...);
COMMIT;
*/
INSERT INTO CUSTOMER (passenger, email, phoneNumber) VALUES (1, 'harbo085@student.liu.se', '0046720200001');
INSERT INTO CUSTOMER (passenger, email, phoneNumber) VALUES (2, 'tonvi217@student.liu.se', '0046704051016');
COMMIT;

/*
INSERT INTO RESERVATION (id, pgroup, flight, ccholder, customer) VALUES (valA, valB, ...);
COMMIT;
*/







/* List of all the tables --

CITY,
AIRPORT,
ROUTE,
DAY,
YEAR,
WEEKDAY,
WEEKLYFLIGHT,
FLIGHT,
RESERVATION,
CCHOLDER,
BOOKING,
PASSENGER,
pGROUP,
TRAVELLER,
CUSTOMER 

*/