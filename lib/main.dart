import 'package:ahgzly_app/features/auth/bloc/auth_bloc.dart';
import 'package:ahgzly_app/features/auth/view/login_screen.dart';
import 'package:ahgzly_app/features/booking/bloc/booking_bloc.dart';
import 'package:ahgzly_app/features/my_bookings/bloc/my_bookings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api_service.dart';
import 'features/restaurants/bloc/restaurants_bloc.dart';
import 'features/restaurants/bloc/restaurants_event.dart';
import 'features/restaurants/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(
    MyApp(
      startScreen: token == null ? const LoginScreen() : const HomeScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(ApiService())),
        BlocProvider(
          create: (context) =>
              RestaurantsBloc(ApiService())..add(FetchRestaurants()),
        ),
        BlocProvider(create: (context) => BookingBloc(ApiService())),
        BlocProvider(create: (context) => MyBookingsBloc(ApiService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AhgzlyOnline App',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: startScreen,
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
