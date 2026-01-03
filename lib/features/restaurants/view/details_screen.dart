import 'package:ahgzly_app/features/booking/bloc/booking_bloc.dart';
import 'package:ahgzly_app/features/booking/bloc/booking_event.dart';
import 'package:ahgzly_app/features/booking/bloc/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic restaurant; // نمرر بيانات المطعم التي جاءت من الـ API

  const DetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    List tableTypes = restaurant['table_types'] ?? [];

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(restaurant['name'])),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "اختر نوع الطاولة المناسب للحجز:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tableTypes.length,
                itemBuilder: (context, index) {
                  final table = tableTypes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(table['name']),
                      subtitle: Text("السعة: ${table['capacity']} أشخاص"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showBookingDialog(
                            context,
                            restaurant['id'],
                            table['id'],
                          );
                        },
                        child: const Text("حجز"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showBookingDialog(
  BuildContext context,
  int restaurantId,
  int tableTypeId,
) {
  DateTime selectedDate = DateTime.now();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("تأكيد الحجز"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("اختر التاريخ والوقت"),
              subtitle: Text(
                DateFormat('yyyy-MM-dd – HH:mm').format(selectedDate),
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDate),
                  );
                  if (pickedTime != null) {
                    selectedDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  }
                }
                // تحديث الواجهة بعد اختيار التاريخ والوقت
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              // إرسال الطلب للـ Bloc
              context.read<BookingBloc>().add(
                SubmitBooking(
                  userId: 1, // يجب استبدال هذا بالقيمة الحقيقية للمستخدم
                  restaurantId: restaurantId,
                  tableTypeId: tableTypeId,
                  bookingDate: selectedDate.toString(),
                  guestsCount: 2, // يمكنك تعديل هذا حسب الحاجة
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("تأكيد الحجز"),
          ),
        ],
      );
    },
  );
}
