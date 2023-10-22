// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./BookingService.sol";  // Replace with the correct path to the BookingService contract


contract PaymentSystem {
    address public owner;
    IERC20 public maticToken;
    BookingService public bookingService;

    event PaymentLocked(uint256 bookingId, address payer, uint256 amount);
    event PaymentReleased(uint256 bookingId, address payer, uint256 amount);

    constructor(address _maticTokenAddress, address _bookingServiceAddress) {
        owner = msg.sender;
        maticToken = IERC20(_maticTokenAddress);
        bookingService = BookingService(_bookingServiceAddress);
    }

    function lockPayment(uint256 _bookingId) public {
        require(bookingService.getBooking(_bookingId).user == msg.sender, "You are not the booking user");
        require(bookingService.getBooking(_bookingId).confirmed, "Booking is not confirmed");
        require(!bookingService.getBooking(_bookingId).paid, "Payment has already been made");

        uint256 amount = bookingService.getBooking(_bookingId).price;
        require(maticToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        bookingService.markBookingAsPaid(_bookingId);
        emit PaymentLocked(_bookingId, msg.sender, amount);
    }

    function finishPayment(uint256 _bookingId) public {
        require(bookingService.getBooking(_bookingId).user == msg.sender, "You are not the booking user");
        require(bookingService.getBooking(_bookingId).confirmed, "Booking is not confirmed");
        require(bookingService.getBooking(_bookingId).paid, "Payment has not been locked");
        require(!bookingService.getBooking(_bookingId).paymentReleased, "Payment already released");

        uint256 amount = bookingService.getBooking(_bookingId).price;
        require(maticToken.transferFrom(address(this), bookingService.getService(bookingService.getBooking(_bookingId).serviceId).serviceProvider, amount), "Transfer failed");

        bookingService.markBookingAsPaid(_bookingId);
        emit PaymentReleased(_bookingId, msg.sender, amount);
    }

    function withdrawFunds(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(_amount <= maticToken.balanceOf(address(this)), "Insufficient balance");
        require(maticToken.transfer(owner, _amount), "Transfer failed");
    }

    function getBalance() public view returns (uint256) {
        return maticToken.balanceOf(address(this));
    }
}
