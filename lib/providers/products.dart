import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  Products(this.authToken, this.userId, this._products);

  final String authToken;
  final String userId;
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favouriteProducts {
    return _products.where((product) => product.isFavourite == true).toList();
  }

  Future<void> fetchProducts({bool filterByCreator = false}) async {
    final filterString =
        filterByCreator ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://my-shop-21b95-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
          'https://my-shop-21b95-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        var favStat = false;
        if (favData != null && favData[key] != null) favStat = favData[key];
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavourite: favStat,
          authToken: authToken,
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://my-shop-21b95-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final res = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }),
    );
    product.id = json.decode(res.body)['name'];
    _products.add(product);
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-shop-21b95-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final productIndex = _products.indexWhere((product) => product.id == id);
    final product = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) throw HttpException('Failed to Delete');
    } catch (error) {
      _products.insert(productIndex, product);
      notifyListeners();
      throw error;
    }
  }
}
