USE AirlineReservationDB;

-- Query 1: Flight Manifesto (Lists passengers, their flight numbers, and their booked seats)
SELECT 
    p.FirstName, 
    p.LastName, 
    f.FlightNumber, 
    s.SeatNumber, 
    s.Class
FROM Passenger p
JOIN Booking b ON p.PassengerID = b.PassengerID
JOIN Ticket t ON b.BookingID = t.BookingID
JOIN Flight f ON t.FlightID = f.FlightID
JOIN Seat s ON t.SeatID = s.SeatID;

-- Query 2: Crew Assignments (Finds out who is working on Flight DL100)
SELECT 
    f.FlightNumber, 
    c.Name AS CrewMember, 
    fa.RoleOnFlight
FROM Flight f
JOIN FlightAssignment fa ON f.FlightID = fa.FlightID
JOIN Crew c ON fa.CrewID = c.CrewID
WHERE f.FlightNumber = 'DL100';

-- Query 3: Financial Summary (Lists total money earned per flight)
SELECT 
    f.FlightNumber, 
    SUM(t.Fare) AS TotalRevenue
FROM Flight f
JOIN Ticket t ON f.FlightID = t.FlightID
GROUP BY f.FlightNumber;
