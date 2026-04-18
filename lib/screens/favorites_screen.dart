import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Plant> allPlants;

  const FavoritesScreen({super.key, required this.allPlants});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Plant> get favoritePlants =>
      widget.allPlants.where((p) => p.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
        centerTitle: true,
      ),
      body: favoritePlants.isEmpty
          ? _buildEmptyFavorites()
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoritePlants.length,
              itemBuilder: (ctx, i) => PlantCard(
                plant: favoritePlants[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PlantDetailScreen(plant: favoritePlants[i]),
                    ),
                  ).then((_) => setState(() {}));
                },
                onFavoriteTap: () => setState(() {
                  favoritePlants[i].isFavorite = false;
                }),
              ),
            ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 48,
              color: Colors.green.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz favori eklemedin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bitkileri keşfet ve favorine ekle!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}