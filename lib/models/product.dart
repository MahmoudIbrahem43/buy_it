class Product {
  late String pName;
  late String pPrice;
  late String pLocation;
  late String pDescription;
  late String pCategory;
  String? pId;
  int? quantity;

  Product(
      {this.quantity,
      required this.pName,
      required this.pCategory,
      required this.pDescription,
      required this.pLocation,
      required this.pPrice,
      this.pId
      });
}
