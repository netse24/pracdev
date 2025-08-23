import 'package:flutter/material.dart';
import 'package:procdev/models/banner.dart' as model;
// ====================================================================
// File: lib/services/banner_service.dart
// Service to fetch banner data.
// ====================================================================

class BannerService extends ChangeNotifier {
  List<model.Banner> getBanners() {
    // This is placeholder data. In a real app, you'd fetch this from an API.
    return [
      model.Banner(
          id: 1,
          imageUrl:
              'https://placehold.co/600x300/F4D7D7/FFFFFF?text=Ad+Banner+1'),
      model.Banner(
          id: 2,
          imageUrl:
              'https://placehold.co/600x300/F4D7D7/FFFFFF?text=Ad+Banner+2'),
    ];
  }
}
