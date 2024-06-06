
class FishCatch {
  final String id;
  final String nickname;
  final String species;
  final double weight;
  final double length;
  final DateTime date;
  final String imagePath;

  FishCatch({
    required this.id,
    required this.nickname,
    required this.species,
    required this.weight,
    required this.length,
    required this.date,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nickname' : nickname,
    'species': species,
    'weight': weight,
    'length': length,
    'date': date.toIso8601String(),
    'imagePath': imagePath,
  };

  factory FishCatch.fromJson(Map<String, dynamic> json) => FishCatch(
    id: json['id'],
    nickname: json['nickname'],
    species: json['species'],
    weight: json['weight'],
    length: json['length'],
    date: DateTime.parse(json['date']),
    imagePath: json['imagePath'],
  );
}
