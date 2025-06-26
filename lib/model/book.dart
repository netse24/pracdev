import 'dart:ffi';

class Book {
  int? id;
  String? title;
  String? author;

  String? description;
  Double? price;
  Double? discount;

  Book(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.price,
      this.discount});
}
