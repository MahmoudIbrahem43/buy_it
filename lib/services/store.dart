import 'package:buy_it/constanse.dart';
import 'package:buy_it/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice
    });
  }

  Stream<QuerySnapshot> loadProduct() {
    return _firestore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore
        .collection(KOrders)
        .doc(documentId)
        .collection(KOrderDetails)
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(KOrders).snapshots();
  }

  deleteProduct(documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).delete();
  }

  editProduct(data, documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).update(data);
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _firestore.collection(KOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(KOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        KQuatity: product.quantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory
      });
    }
  }
}
