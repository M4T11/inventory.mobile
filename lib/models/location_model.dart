class Location {
  final int locationId;
  final String name;

Location({
  required this.locationId,
  required this.name,
});

Map<String, dynamic> toJson() => {
      'location_id': locationId,
      'name': name,
};

factory Location.fromJson (Map<String,dynamic>json){
      return Location(
          locationId: json['location_id'],
          name: json['name']
          );
}

}


