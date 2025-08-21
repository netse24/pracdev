import 'package:procdev/models/category.dart';

class CategoryService {
  static List<Category> getDemoCategories() {
    return [
      Category(id: 1, name: "Day Cream"),
      Category(id: 2, name: "Night Cream"),
      Category(id: 3, name: "Lip Stain"),
    ];
  }
}
