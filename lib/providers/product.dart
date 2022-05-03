import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;
  final String authToken;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
    @required this.authToken,
  });

  Future<void> updateProduct({title, description, imageUrl, price}) async {
    final url =
        'https://my-shop-21b95-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(
      url,
      body: json.encode({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      }),
    );
    this.title = title;
    this.description = description;
    this.imageUrl = imageUrl;
    this.price = price;
    notifyListeners();
  }

  Future<void> toggleFavourite(String userId) async {
    final url =
        'https://my-shop-21b95-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400)
        throw HttpException('Failed to toggle favourite');
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
