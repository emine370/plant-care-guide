class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String imagePath;
  final int wateringDays;
  final String light;
  final String difficulty;
  final String description;
  bool isFavorite;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.imagePath,
    required this.wateringDays,
    required this.light,
    required this.difficulty,
    required this.description,
    this.isFavorite = false,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      imagePath: json['imagePath'],
      wateringDays: json['wateringDays'],
      light: json['light'],
      difficulty: json['difficulty'],
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'imagePath': imagePath,
      'wateringDays': wateringDays,
      'light': light,
      'difficulty': difficulty,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
}