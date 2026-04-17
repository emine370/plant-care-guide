import '../models/plant.dart';

final List<Plant> plantList = [
  Plant(
    id: '1',
    name: 'Pothos',
    scientificName: 'Epipremnum aureum',
    imagePath: 'assets/images/pothos.jpg',
    wateringDays: 7,
    light: 'Düşük',
    difficulty: 'Kolay',
    description:
        'Pothos, ev ortamında bakımı en kolay bitkilerden biridir. Az ışıkta da yaşayabilir ve düzenli sulama ile sağlıklı şekilde gelişir.',
  ),
  Plant(
    id: '2',
    name: 'Kaktüs',
    scientificName: 'Cactaceae',
    imagePath: 'assets/images/kaktus.jpg',
    wateringDays: 21,
    light: 'Yüksek',
    difficulty: 'Kolay',
    description:
        'Kaktüsler güneş ışığını sever ve çok sık sulanmayı sevmez. Dayanıklı yapısıyla yeni başlayanlar için uygundur.',
  ),
  Plant(
    id: '3',
    name: 'Orkide',
    scientificName: 'Phalaenopsis',
    imagePath: 'assets/images/orkide.jpg',
    wateringDays: 10,
    light: 'Orta',
    difficulty: 'Zor',
    description:
        'Orkide, doğru ışık ve dikkatli sulama ile uzun süre çiçek açabilen zarif bir bitkidir.',
  ),
  Plant(
    id: '4',
    name: 'Lavanta',
    scientificName: 'Lavandula',
    imagePath: 'assets/images/lavanta.jpg',
    wateringDays: 6,
    light: 'Yüksek',
    difficulty: 'Orta',
    description:
        'Lavanta hoş kokusu ile bilinir. Güneşli ortamları sever ve toprağının fazla ıslak kalmaması gerekir.',
  ),
  Plant(
    id: '5',
    name: 'Monstera',
    scientificName: 'Monstera deliciosa',
    imagePath: 'assets/images/monstera.jpg',
    wateringDays: 8,
    light: 'Orta',
    difficulty: 'Orta',
    description:
        'Monstera geniş yaprakları ile dekoratif bir ev bitkisidir. Aydınlık fakat direkt güneş almayan alanlarda iyi gelişir.',
  ),
  Plant(
    id: '6',
    name: 'Aloe Vera',
    scientificName: 'Aloe barbadensis miller',
    imagePath: 'assets/images/aloe_vera.jpg',
    wateringDays: 14,
    light: 'Yüksek',
    difficulty: 'Kolay',
    description:
        'Aloe Vera hem dekoratif hem de faydalı bir bitkidir. Fazla su istemez ve güneşli alanlarda iyi büyür.',
  ),
];