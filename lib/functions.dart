import 'models/product.dart';

List<Product>  getProductsByCategorey(
    String kCategory, List<Product> allProducts) {
  List<Product> products = [];
  try {
    for (var product in allProducts) {
      if (product.pCategory == kCategory) {
        products.add(product);
      }
    }
  } on Error catch (ex) {
    print(ex);
  }
  return products;
}
