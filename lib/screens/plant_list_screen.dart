import 'package:flutter/material.dart';

import '../data/plants_data.dart';
import '../models/plant.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  String selectedFilter = 'Hepsi';
  String searchQuery = '';

  final List<String> filters = ['Hepsi', 'Kolay', 'Orta', 'Zor'];

  List<Plant> get filteredPlants {
    return plantList.where((plant) {
      final matchesFilter =
          selectedFilter == 'Hepsi' || plant.difficulty == selectedFilter;

      final matchesSearch = plant.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitki Bakım Rehberi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade300,
                  Colors.green.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ev Bitkilerini Keşfet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bakım bilgilerini öğren, favorilerini işaretle ve bitkilerini daha sağlıklı büyüt.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Bitki ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;

                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  selectedColor: Colors.green.shade600,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredPlants.isEmpty
                ? const Center(
                    child: Text(
                      'Sonuç bulunamadı.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filteredPlants.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];

                      return PlantCard(
                        plant: plant,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlantDetailScreen(plant: plant),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        onFavoriteTap: () {
                          setState(() {
                            plant.isFavorite = !plant.isFavorite;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}