-- 1. Create and select the main database container
CREATE DATABASE AirlineReservationDB;
USE AirlineReservationDB;

-- 2. Level 1: Tables with no foreign keys (Independent)
CREATE TABLE Airline (
    AirlineID INT AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    ContactEmail VARCHAR(100) UNIQUE,
    PRIMARY KEY (AirlineID)
);

CREATE TABLE Airport (
    AirportCode CHAR(3),
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    PRIMARY KEY (AirportCode)
);

CREATE TABLE Passenger (
    PassengerID INT AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20) UNIQUE,
    PassportNumber VARCHAR(20) NOT NULL UNIQUE,
    DateOfBirth DATE NOT NULL,
    PRIMARY KEY (PassengerID)
);

CREATE TABLE Crew (
    CrewID INT AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(30),
    PRIMARY KEY (CrewID)
);

-- 3. Level 2: Tables that depend directly on independent tables
CREATE TABLE Aircraft (
    AircraftID INT AUTO_INCREMENT,
    Model VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    AirlineID INT,
    PRIMARY KEY (AircraftID),
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID) ON DELETE SET NULL
);

CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT,
    PassengerID INT,
    BookingDate DATE NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('confirmed', 'cancelled')),
    TotalAmount DECIMAL(10,2),
    PRIMARY KEY (BookingID),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE
);

-- 4. Level 3: Tables that link to multiple dependent layouts
CREATE TABLE Seat (
    SeatID INT AUTO_INCREMENT,
    AircraftID INT,
    SeatNumber VARCHAR(5) NOT NULL,
    Class VARCHAR(20) CHECK (Class IN ('economy', 'business', 'first')),
    PRIMARY KEY (SeatID),
    FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID) ON DELETE CASCADE
);

CREATE TABLE Flight (
    FlightID INT AUTO_INCREMENT,
    FlightNumber VARCHAR(10) NOT NULL UNIQUE,
    DepartureAirport CHAR(3),
    ArrivalAirport CHAR(3),
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    AircraftID INT,
    AirlineID INT,
    PRIMARY KEY (FlightID),
    FOREIGN KEY (DepartureAirport) REFERENCES Airport(AirportCode),
    FOREIGN KEY (ArrivalAirport) REFERENCES Airport(AirportCode),
    FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID),
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID)
);

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT,
    BookingID INT,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    Method VARCHAR(20),
    Status VARCHAR(20) CHECK (Status IN ('paid', 'pending', 'failed')),
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE
);

-- 5. Level 4: Complex multi-link tables and junction tables
CREATE TABLE Ticket (
    TicketID INT AUTO_INCREMENT,
    BookingID INT,
    FlightID INT,
    SeatID INT,
    Fare DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (TicketID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);

CREATE TABLE FlightAssignment (
    FlightID INT,
    CrewID INT,
    RoleOnFlight VARCHAR(30),
    PRIMARY KEY (FlightID, CrewID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE CASCADE,
    FOREIGN KEY (CrewID) REFERENCES Crew(CrewID) ON DELETE CASCADE
);
