class Producer {
  final int producerId;
  final String name;

Producer({
  required this.producerId,
  required this.name,
});

Map<String, dynamic> toJson() => {
      'producer_id': producerId,
      'name': name,
};

factory Producer.fromJson (Map<String,dynamic>json){
      return Producer(
          producerId: json['producer_id'],
          name: json['name']
          );
}

}


