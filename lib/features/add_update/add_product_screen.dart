import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <-- import
import 'package:provider/provider.dart';

import '../home/provider/product_database_operations.dart';
import '../home/model/product_model.dart';
import '../../core/static_texts/static_app_texts.dart';

class AddUpdateProductScreen extends StatefulWidget {
  const AddUpdateProductScreen({super.key});

  @override
  State<AddUpdateProductScreen> createState() => _AddUpdateProductScreenState();
}

class _AddUpdateProductScreenState extends State<AddUpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        title: _titleController.text,
        price: double.tryParse(_priceController.text),
        description: _descriptionController.text,
        image: _imageUrlController.text,
      );

      try {
        await Provider.of<ProductProvider>(context, listen: false).addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("product_added".tr())),
        );
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('add_failed $e'.tr())),
        );
      }
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final id = _idController.text.trim();
      if (id.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("enter_product_id_to_update".tr())),
        );
        return;
      }

      final product = ProductModel(
        id: id,
        title: _titleController.text,
        price: double.tryParse(_priceController.text),
        description: _descriptionController.text,
        image: _imageUrlController.text,
      );

      try {
        await Provider.of<ProductProvider>(context, listen: false).updateProduct(id, product);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("product_updated".tr()),
        ));
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('product_failed $e').tr()),
        );
      }
    }
  }

  void _clearFields() {
    _idController.clear();
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),  // responsive radius
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Builder(
        builder: (context) {
          final _ = context.locale;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10.w),  // responsive padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h),
                    TextFormField(
                      controller: _idController,
                      decoration: _inputDecoration("enterProductId".tr()),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration("textFormFieldTitle".tr()),
                      validator: (val) => val == null || val.isEmpty ? 'enter_title'.tr() : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _priceController,
                      decoration: _inputDecoration("textFormFieldPrice".tr()),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? 'enter_price'.tr() : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration("textFormFieldDescription".tr()),
                      maxLines: 1,
                      validator: (val) => val == null || val.isEmpty ? 'enter_description'.tr() : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 25.h),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _inputDecoration("textFormFieldImageUrl".tr()),
                      validator: (val) => val == null || val.isEmpty ? 'enter_image_url'.tr() : null,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 60.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              "addProductButtonText".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: _addProduct,
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              "updateProductButtonText".tr(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: _updateProduct,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
