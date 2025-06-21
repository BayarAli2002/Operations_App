import 'dart:developer';

import 'package:flutter/material.dart';
import '../data/model/product_model.dart';
import '../provider/product_provider.dart';

class AddUpdateProductProvider extends ChangeNotifier {
  final ProductProvider productProvider;
  final bool isEditMode;
  final ProductModel? initialProduct;

  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  AddUpdateProductProvider({required this.productProvider, this.initialProduct})
    : isEditMode = initialProduct != null {
    if (isEditMode) {
      idController.text = initialProduct!.id ?? '';
      titleController.text = initialProduct!.title ?? '';
      priceController.text = initialProduct!.price?.toString() ?? '';
      descriptionController.text = initialProduct!.description ?? '';
      imageUrlController.text = initialProduct!.image ?? '';
    }
  }

  Future<void> submit() async {
  if (!formKey.currentState!.validate()) {
    throw Exception('Form validation failed');
  }

  final product = ProductModel(
    id: isEditMode ? idController.text : null,
    title: titleController.text,
    price: int.tryParse(priceController.text),
    description: descriptionController.text,
    image: imageUrlController.text,
  );

  try {
    if (isEditMode) {
      await productProvider.updateProduct(product.id!, product);
    } else {
      await productProvider.addProduct(product);
    }
  } catch (e, stackTrace) {
    //stacktrace gives as the full path of the error
    log('Error in submit(): $e', stackTrace: stackTrace);
    throw Exception('Failed to ${isEditMode ? "update" : "add"} product');
  }
}


  void disposeControllers() {
    idController.dispose();
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
  }
}
