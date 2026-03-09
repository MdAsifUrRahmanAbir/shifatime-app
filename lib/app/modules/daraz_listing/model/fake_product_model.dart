import 'dart:convert';

List<FakeProduct> fakeProductFromJson(String str) => List<FakeProduct>.from(
  json.decode(str).map((x) => FakeProduct.fromJson(x)),
);

class FakeProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  FakeProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory FakeProduct.fromJson(Map<String, dynamic> json) => FakeProduct(
    id: json["id"],
    title: json["title"],
    price: json["price"].toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
    rating: Rating.fromJson(json["rating"]),
  );

  factory FakeProduct.dummy({int id = 0}) => FakeProduct(
    id: id,
    title: 'Loading Product Name...',
    price: 99.99,
    description: 'Loading description details...',
    category: 'Category $id',
    image: '',
    rating: Rating(rate: 0.0, count: 0),
  );
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) =>
      Rating(rate: json["rate"].toDouble(), count: json["count"]);
}
