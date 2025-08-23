import 'package:flutter/material.dart';
import 'package:procdev/models/category.dart';
// ====================================================================
// File: lib/services/category_service.dart
// Service to fetch category data.
// ====================================================================

class CategoryService extends ChangeNotifier {
  List<Category> getCategories() {
    // Placeholder data
    return [
      Category(id: 1, name: 'Night cream'),
      Category(id: 2, name: 'Day cream'),
      Category(id: 3, name: 'Lip Stain'),
      Category(id: 4, name: 'Foundation'),
      Category(id: 5, name: 'Cleanser'),
    ];
  }
}
