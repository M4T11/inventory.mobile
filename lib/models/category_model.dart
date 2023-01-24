class Category {
  final int categoryId;
  final String name;

Category({
  required this.categoryId,
  required this.name,
});

// Map toJson(){
//     return {"category_id": categoryId, "name": name};
//   }

Map<String, dynamic> toJson() => {
      'category_id': categoryId,
      'name': name,
};

factory Category.fromJson (Map<String,dynamic>json){
      return Category(
          categoryId: json['category_id'],
          name: json['name']
          );
}

}


