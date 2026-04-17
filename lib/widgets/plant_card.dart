import 'package:flutter/material.dart';

import '../models/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onFavoriteTap,
  });

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay':
        return Colors.green;
      case 'Orta':
        return Colors.orange;
      case 'Zor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'plant_image_${plant.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        plant.imagePath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          plant.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: plant.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onFavoriteTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Text(
                plant.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                plant.scientificName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _difficultyColor(plant.difficulty),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plant.difficulty,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}