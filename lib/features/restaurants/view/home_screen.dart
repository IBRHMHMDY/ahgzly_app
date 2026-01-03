import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/restaurants_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("احجزلي أونلاين - المطاعم")),
      body: BlocBuilder<RestaurantsBloc, RestaurantsState>(
        builder: (context, state) {
          if (state is RestaurantsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantsLoaded) {
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final res = state.restaurants[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(res['name']),
                    subtitle: Text(res['address'] ?? 'لا يوجد عنوان'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // سنضيف الانتقال لصفحة التفاصيل لاحقاً
                    },
                  ),
                );
              },
            );
          } else if (state is RestaurantsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("ابدأ البحث عن مطاعم"));
        },
      ),
    );
  }
}
