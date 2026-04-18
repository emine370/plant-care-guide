import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
import '../data/plants_data.dart';
import '../models/plant.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class PlantListScreen extends StatefulWidget {
  final VoidCallback? onFavoriteChanged;
  const PlantListScreen({super.key, this.onFavoriteChanged});

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitki Bakım Rehberi'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: isDark ? 'Açık tema' : 'Koyu tema',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                  selectedColor: colorScheme.primary,
                  backgroundColor: isDark
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredPlants.isEmpty
                ? _buildEmptyState()  // ← boş durum
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredPlants.length,
                    itemBuilder: (ctx, i) => PlantCard(
                      plant: filteredPlants[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlantDetailScreen(plant: filteredPlants[i]),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      onFavoriteTap: () {
                        setState(() {
                          filteredPlants[i].isFavorite = !filteredPlants[i].isFavorite;
                        });
                        widget.onFavoriteChanged?.call();
                    },
                   ),
                  ),
                 ),
               ],
             ),
          );
         }
  Widget _buildEmptyState() {
    final bool isSearching = searchQuery.isNotEmpty;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60), 
            // İkon
            SizedBox(
              width: 130,
              height: 130,
              child: CustomPaint(
                painter: SadPlantPainter(
                  color: Colors.green.shade300,
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Başlık
            Text(
              isSearching
                  ? '"$searchQuery" bulunamadı'
                  : '$selectedFilter zorluk seviyesinde bitki yok',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),

            // Alt yazı
            Text(
              isSearching
                  ? 'Farklı bir bitki adı aramayı deneyin.'
                  : 'Başka bir zorluk seviyesi seçmeyi deneyin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 28),

            // Sıfırla butonu
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Tümünü Göster'),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  selectedFilter = 'Hepsi';
                  // Eğer arama kutusunu controller ile yönetiyorsan:
                  // _searchController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
class SadPlantPainter extends CustomPainter {
  final Color color;
  SadPlantPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;

    // Saksı
    final potPath = Path()
      ..moveTo(cx - 28, size.height * 0.62)
      ..lineTo(cx - 22, size.height * 0.92)
      ..lineTo(cx + 22, size.height * 0.92)
      ..lineTo(cx + 28, size.height * 0.62)
      ..close();
    canvas.drawPath(potPath, paint..color = color.withValues(alpha: 0.5));

    // Saksı üst kenar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 30, size.height * 0.59, 60, 8),
        const Radius.circular(4),
      ),
      paint..color = color,
    );

    // Gövde (sap)
    canvas.drawLine(
      Offset(cx, size.height * 0.59),
      Offset(cx, size.height * 0.38),
      strokePaint,
    );

    // Sol yaprak — sarkık (solmuş)
    final leftLeaf = Path()
      ..moveTo(cx, size.height * 0.45)
      ..cubicTo(
        cx - 10, size.height * 0.35,
        cx - 35, size.height * 0.32,
        cx - 30, size.height * 0.52,
      )
      ..cubicTo(
        cx - 25, size.height * 0.48,
        cx - 10, size.height * 0.50,
        cx, size.height * 0.45,
      );
    canvas.drawPath(leftLeaf, paint..color = color.withValues(alpha: 0.7));

    // Sağ yaprak — sarkık
    final rightLeaf = Path()
      ..moveTo(cx, size.height * 0.42)
      ..cubicTo(
        cx + 10, size.height * 0.30,
        cx + 36, size.height * 0.28,
        cx + 28, size.height * 0.50,
      )
      ..cubicTo(
        cx + 22, size.height * 0.44,
        cx + 10, size.height * 0.44,
        cx, size.height * 0.42,
      );
    canvas.drawPath(rightLeaf, paint..color = color.withValues(alpha: 0.85));

    // Üst küçük yaprak — eğik solmuş
    final topLeaf = Path()
      ..moveTo(cx, size.height * 0.38)
      ..cubicTo(
        cx + 5, size.height * 0.22,
        cx + 25, size.height * 0.18,
        cx + 20, size.height * 0.32,
      )
      ..cubicTo(
        cx + 14, size.height * 0.28,
        cx + 6, size.height * 0.32,
        cx, size.height * 0.38,
      );
    canvas.drawPath(topLeaf, paint..color = color);

    // Üzgün yüz — gözler
    canvas.drawCircle(
      Offset(cx - 8, size.height * 0.76),
      2.5,
      paint..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx + 8, size.height * 0.76),
      2.5,
      paint..color = Colors.white,
    );

    // Üzgün ağız
    final mouthPath = Path()
      ..moveTo(cx - 7, size.height * 0.84)
      ..cubicTo(
        cx - 3, size.height * 0.81,
        cx + 3, size.height * 0.81,
        cx + 7, size.height * 0.84,
      );
    canvas.drawPath(mouthPath, strokePaint..color = Colors.white..strokeWidth = 2);

    // Ter damlası (arama yapıyorken)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + 22, size.height * 0.68),
        width: 7,
        height: 11,
      ),
      paint..color = Colors.blue.shade200.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}