// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BookingService {
    struct Booking {
        address user;
        uint256 serviceId;
        uint256 bookingTime;
        uint256 startTime;
        uint256 endTime;
        uint256 price;
        bool confirmed;
        bool paid;
        bool paymentReleased;
    }

    uint256 public serviceCount;
    uint256 public bookingCount;
    uint256 public schoolCount;
    mapping(uint256 => Booking) public bookings;
    mapping(uint256 => address) public schools;
    address public owner;

    event ServiceCreated(uint256 serviceId, address serviceProvider, string serviceName, uint256 price, string departureLocation, string destination, uint256 availableSeats, uint256 departureTime);
    event ServiceCanceled(uint256 serviceId);
    event BookingCreated(uint256 bookingId, address user, uint256 serviceId, uint256 bookingTime, uint256 startTime, uint256 endTime, uint256 price);
    event BookingConfirmed(uint256 bookingId);
    event BookingPaid(uint256 bookingId);

    constructor() {
        serviceCount = 0;
        bookingCount = 0;
        schoolCount = 0;
        owner = msg.sender;
    }

    struct Service {
        uint256 serviceId;
        address serviceProvider;
        string serviceName;
        uint256 price;
        string departureLocation;
        string destination;
        uint256 availableSeats;
        uint256 departureTime;
        bool isActive;
        bool isFinished;
        bool isValidated;
        bool isPaid;
    }

    mapping(uint256 => Service) public services;

    function createService(string memory _serviceName, uint256 _price, string memory _departureLocation, string memory _destination, uint256 _availableSeats, uint256 _departureTime) public {
        serviceCount++;
        require(_availableSeats > 0, "Number of available seats must be greater than 0");
        require(_departureTime > block.timestamp, "Invalid departure time");
        require(_price >= 0, "Price cannot be negative");
        Service storage newCarpool = services[serviceCount];
        newCarpool.serviceProvider = msg.sender;
        newCarpool.departureLocation = _departureLocation;
        newCarpool.destination = _destination;
        newCarpool.availableSeats = _availableSeats;
        newCarpool.departureTime = _departureTime;
        newCarpool.price = _price;
        newCarpool.isActive = true;
        newCarpool.isFinished = false;
        newCarpool.isValidated = false;
        newCarpool.isPaid = false;
        newCarpool.serviceName = "carpool";
        newCarpool.serviceId = serviceCount;

        emit ServiceCreated(serviceCount, msg.sender, _serviceName, _price,_departureLocation, _destination, _availableSeats, _departureTime);
    }

    function cancelService(uint256 _serviceId) public {
        require(_serviceId <= serviceCount, "Invalid service ID");
        require(services[_serviceId].serviceProvider == msg.sender, "You are not the service provider");
        require(services[_serviceId].isActive, "Service is already canceled");

        services[_serviceId].isActive = false;

        emit ServiceCanceled(_serviceId);
    }

    function finishService(uint256 _serviceId) public {
        require(_serviceId <= serviceCount, "Invalid service ID");
        require(services[_serviceId].serviceProvider == msg.sender, "You are not the service provider");
        require(services[_serviceId].isActive, "Service is not active");

        services[_serviceId].isActive = false;
        services[_serviceId].isFinished = true;

        emit ServiceCanceled(_serviceId);
    }

    function isSchoolRegistered(address _schoolAddress) public view returns (bool) {
    for (uint256 i = 1; i <= schoolCount; i++) {
        if (schools[i] == _schoolAddress) {
            return true; // Sender's address is found in the mapping
        }
    }
    return false; // Sender's address is not found in the mapping
}

    function validateService(uint256 _serviceId) public {
        require(_serviceId <= serviceCount, "Invalid service ID");
        require(isSchoolRegistered(msg.sender), "School not registered");
        require(services[_serviceId].isFinished, "Service not yet finished");

        services[_serviceId].isValidated = true;
    }

    function bookService(uint256 _serviceId, uint256 _startTime, uint256 _endTime, uint256 _price) public {
        require(_serviceId > 0 && _serviceId <= serviceCount, "Invalid service ID");
        require(_startTime > block.timestamp, "Invalid start time");
        require(_endTime > _startTime, "Invalid end time");
        require(_price >= 0, "Price cannot be negative");

        bookingCount++;
        Booking storage newBooking = bookings[bookingCount];
        newBooking.user = msg.sender;
        newBooking.serviceId = _serviceId;
        newBooking.bookingTime = block.timestamp;
        newBooking.startTime = _startTime;
        newBooking.endTime = _endTime;
        newBooking.price = _price;
        newBooking.confirmed = false;
        newBooking.paid = false;
        newBooking.paymentReleased = false;

        emit BookingCreated(bookingCount, msg.sender, _serviceId, block.timestamp, _startTime, _endTime, _price);
    }

    function confirmBooking(uint256 _bookingId) public {
        require(_bookingId <= bookingCount, "Invalid booking ID");
        require(services[bookings[_bookingId].serviceId].serviceProvider == msg.sender, "You are not the service provider");
        require(!bookings[_bookingId].confirmed, "Booking already confirmed");

        bookings[_bookingId].confirmed = true;

        emit BookingConfirmed(_bookingId);
    }

    function markBookingAsPaid(uint256 _bookingId) public {
        require(_bookingId <= bookingCount, "Invalid booking ID");
        require(bookings[_bookingId].user == msg.sender, "You are not the user");
        require(bookings[_bookingId].confirmed, "Booking is not confirmed");
        require(!bookings[_bookingId].paid, "Payment has already been made");

        bookings[_bookingId].paid = true;

        emit BookingPaid(_bookingId);
    }

    function getBooking(uint256 _bookingId) public view returns (
Booking memory
) {
    require(_bookingId <= bookingCount, "Invalid booking ID");

    Booking storage booking = bookings[_bookingId];

    return (
booking
    );
}

        function getService(uint256 _serviceId) public view returns (
Service memory
) {
    require(_serviceId <= serviceCount, "Invalid booking ID");

    Service storage service = services[_serviceId];

    return (
service
    );
}

    function addSchool(address _schoolAddress) public {
        require(owner == msg.sender, "only owner can call this function");
        schoolCount++;
        schools[schoolCount] = _schoolAddress;
    }

}

