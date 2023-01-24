class Location {
  final int locationId;
  final String name;

Location({
  required this.locationId,
  required this.name,
});

Map<String, dynamic> toJson() => {
      'category_id': locationId,
      'name': name,
};

}


