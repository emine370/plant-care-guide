import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen>
    with TickerProviderStateMixin {
  late bool isFavorite;
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.plant.isFavorite;

    // Kalp pulse animasyonu
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    // İçerik fade-in animasyonu
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    _heartController.forward(from: 0);
    setState(() {
      isFavorite = !isFavorite;
      widget.plant.isFavorite = isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.plant.name} favorilere eklendi!'
              : '${widget.plant.name} favorilerden çıkarıldı.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay': return Colors.green;
      case 'Orta':  return Colors.orange;
      case 'Zor':   return Colors.red;
      default:      return Colors.grey;
    }
  }

  // Sulama zorluğu 1-21 gün arası, progress buna göre hesaplanıyor
  double _wateringProgress(int days) {
    if (days <= 3) return 1.0;
    if (days <= 7) return 0.75;
    if (days <= 14) return 0.45;
    return 0.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Kaydırınca küçülen fotoğraf + başlık
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.green.shade800,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ScaleTransition(
                  scale: _heartScale,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade600,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'plant_image_${widget.plant.id}',
                child: Image.asset(
                  widget.plant.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // İçerik — fade in ile giriyor
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // İsim + bilimsel isim
                    Text(
                      widget.plant.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.plant.scientificName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Zorluk badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _difficultyColor(widget.plant.difficulty),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Zorluk: ${widget.plant.difficulty}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sulama kartı — progress bar ile
                    _buildWateringCard(),
                    const SizedBox(height: 12),

                    // Işık kartı
                    _buildLightCard(),
                    const SizedBox(height: 28),

                    // Açıklama
                    const Text(
                      'Bitki Hakkında',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.plant.description,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 28),

                    // Favori butonu
                    _buildFavoriteButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWateringCard() {
    final progress = _wateringProgress(widget.plant.wateringDays);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.shade900.withValues(alpha: 0.4) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blue.shade700 : Colors.blue.shade100,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: Colors.blue.shade400, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sulama Sıklığı',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.blue.shade100 : Colors.blue.shade900,
                      ),
                    ),
                    Text(
                      '${widget.plant.wateringDays} günde bir',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        backgroundColor: isDark
                            ? Colors.blue.shade800
                            : Colors.blue.shade100,
                        valueColor: AlwaysStoppedAnimation(Colors.blue.shade400),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  progress >= 0.75
                      ? 'Çok sık sulama gerektirir'
                      : progress >= 0.45
                          ? 'Orta sıklıkta sulama'
                          : 'Az sulama yeterli',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.blue.shade300 : Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lightIcons = {
      'Düşük': Icons.brightness_3,
      'Orta': Icons.brightness_5,
      'Yüksek': Icons.brightness_7,
    };
    final lightColors = {
      'Düşük': Colors.indigo,
      'Orta': Colors.orange,
      'Yüksek': Colors.amber.shade700,
    };
    final color = lightColors[widget.plant.light] ?? Colors.amber;
    final icon = lightIcons[widget.plant.light] ?? Icons.wb_sunny;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? color.withValues(alpha: 0.4)
              : color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Işık İhtiyacı',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(3, (i) {
                    final filled = widget.plant.light == 'Yüksek'
                        ? true
                        : widget.plant.light == 'Orta'
                            ? i < 2
                            : i < 1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.wb_sunny,
                        size: 20,
                        color: filled ? color : Colors.grey.shade600,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.plant.light,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return ScaleTransition(
      scale: _heartScale,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isFavorite ? Colors.red.shade400 : Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          label: Text(
            isFavorite ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}