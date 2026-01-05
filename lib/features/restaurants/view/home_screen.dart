import 'package:ahgzly_app/features/my_bookings/bloc/my_bookings_bloc.dart';
import 'package:ahgzly_app/features/my_bookings/bloc/my_bookings_event.dart';
import 'package:ahgzly_app/features/my_bookings/view/my_bookings_screen.dart';
import 'package:ahgzly_app/features/restaurants/view/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/restaurants_bloc.dart';
import '../bloc/restaurants_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة المطاعم"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBookingsScreen(),
                ),
              );
              context.read<MyBookingsBloc>().add(
                FetchMyBookings(),
              ); // تحديث البيانات عند الفتح
            },
          ),
        ],
      ),
      body: BlocBuilder<RestaurantsBloc, RestaurantsState>(
        builder: (context, state) {
          if (state is RestaurantsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantsLoaded) {
            if (state.restaurants.isEmpty) {
              return const Center(child: Text("لا توجد مطاعم حالياً"));
            }
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = state.restaurants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                    title: Text(restaurant['name'] ?? 'بدون اسم'),
                    subtitle: Text(restaurant['address'] ?? 'العنوان غير محدد'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(restaurant: restaurant),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is RestaurantsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("مرحباً بك في تطبيق حجوزاتي"));
        },
      ),
    );
  }
}
