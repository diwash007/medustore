class Product {
  Product({this.id, this.title, this.description, this.thumbnail, this.price});

  String? id;
  String? title;
  String? description;
  String? thumbnail;
  int? price;

  factory Product.fromJson(dynamic json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        price: json["variants"][0]["prices"][0]["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "price": price
      };
}
