import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.plant.isFavorite;
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay': return Colors.green;
      case 'Orta':  return Colors.orange;
      case 'Zor':   return Colors.red;
      default:      return Colors.grey;
    }
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
        centerTitle: true,
        // AppBar'da da favori ikonu — hem görsel hem pratik
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                widget.plant.isFavorite = isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero animasyonu — listeden detaya geçişte görsel uçar
            Hero(
              tag: 'plant_image_${widget.plant.id}',
              child: Image.asset(
                widget.plant.imagePath,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.plant.name,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(widget.plant.scientificName,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: _difficultyColor(widget.plant.difficulty),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Zorluk: ${widget.plant.difficulty}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _infoCard(
                        icon: Icons.water_drop,
                        title: 'Sulama',
                        value: '${widget.plant.wateringDays} günde bir',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _infoCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Işık',
                        value: widget.plant.light,
                        color: Colors.amber.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text('Bitki Hakkında',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.plant.description,
                      style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 30),

                  // ✅ YÖNERGEDEKİ "state güncelleme butonu" burada
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite
                            ? Colors.red.shade400
                            : Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      label: Text(
                        isFavorite
                            ? 'Favorilerden Çıkar'
                            : 'Favorilere Ekle',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                          widget.plant.isFavorite = isFavorite;
                        });
                        // Kullanıcıya geri bildirim
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isFavorite
                                ? '${widget.plant.name} favorilere eklendi!'
                                : '${widget.plant.name} favorilerden çıkarıldı.'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}