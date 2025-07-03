class Book {
  int? id;
  String? title;
  String? author;
  String? description;
  double? price;
  double? discount;

  Book(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.price,
      this.discount});

  Map<String, dynamic> toMap() => {
    'id':id,
    'title':title,
    'author':author,
    'description':description,
    'price': price,
    'discount': discount
  };
  factory Book.fromMap(Map<String,dynamic> map){
   return Book(
     id:map['id'],
     title:map['title'],
     author:map['author'],
     description:map['description'],
     price:map['price'],
     discount:map['discount'],
   );
  }
}
