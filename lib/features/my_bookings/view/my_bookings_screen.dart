import 'package:ahgzly_app/features/my_bookings/bloc/my_bookings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/my_bookings_bloc.dart';
import '../bloc/my_bookings_state.dart';
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حجوزاتي"),),
      body: BlocBuilder<MyBookingsBloc, MyBookingsState>(
        builder: (context, state) {
          if (state is MyBookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyBookingsLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text("ليس لديك حجوزات حالياً"));
            }
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(booking['restaurant']['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("التاريخ: ${booking['booking_date']}"),
                        if (booking['status'] == 'pending')
                          TextButton(
                            onPressed: () =>
                                _confirmCancel(context, booking['id']),
                            child: const Text(
                              "إلغاء الحجز",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    trailing: _buildStatusBadge(booking['status']),
                  ),
                );
              },
            );
          } else if (state is MyBookingsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    String text = "قيد الانتظار";
    if (status == 'confirmed') {
      color = Colors.green;
      text = "مؤكد";
    }
    if (status == 'cancelled') {
      color = Colors.red;
      text = "ملغي";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // دالة لتأكيد الإلغاء عبر Dialog
  void _confirmCancel(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد الإلغاء"),
        content: const Text("هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("تراجع"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MyBookingsBloc>().add(CancelBookingRequested(id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("نعم، إلغاء"),
          ),
        ],
      ),
    );
  }
}
