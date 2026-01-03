import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitBooking extends BookingEvent {
  final int userId;
  final int restaurantId;
  final int tableTypeId;
  final String bookingDate;
  final int guestsCount;


  SubmitBooking({
    required this.userId,
    required this.restaurantId,
    required this.tableTypeId,
    required this.bookingDate,
    required this.guestsCount,

  });
}
