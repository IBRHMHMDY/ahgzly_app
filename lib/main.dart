import 'package:ahgzly_app/features/booking/bloc/booking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api_service.dart';
import 'features/restaurants/bloc/restaurants_bloc.dart';
import 'features/restaurants/bloc/restaurants_event.dart';
import 'features/restaurants/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                RestaurantsBloc(ApiService())..add(FetchRestaurants()),
          ),
          BlocProvider(
            create: (context) => BookingBloc(ApiService()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AhgzlyOnline App',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
