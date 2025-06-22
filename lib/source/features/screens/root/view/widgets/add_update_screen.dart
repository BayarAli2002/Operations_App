import 'package:crud_app/source/core/extension/extentions.dart'; // flushbar extension
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/screens/home/provider/add_update_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../home/data/model/product_model.dart';
import '../../../home/provider/product_provider.dart';

class AddUpdateProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddUpdateProductScreen({super.key, this.product});

  @override
  State<AddUpdateProductScreen> createState() => _AddUpdateProductScreenState();
}

class _AddUpdateProductScreenState extends State<AddUpdateProductScreen> {
  late final AddUpdateProductProvider _controller;

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _controller = AddUpdateProductProvider(
      productProvider: productProvider,
      initialProduct: widget.product,
    );
  }

  @override
  void dispose() {
    _controller.disposeControllers();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    try {
      await _controller.submit();
      if (!mounted) return;
      Navigator.of(context).pop();
      context.showFlushbar(
        _controller.isEditMode
            ? LocaleKeys.product_updated.tr()
            : LocaleKeys.product_added.tr(),
      );
    } catch (e) {
      context.showFlushbar(e.toString(), isError: true);
    }
  }

  InputDecoration _inputDecoration(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      fillColor: theme.colorScheme.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withAlpha((0.3 * 255).round())),  
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = _controller.isEditMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? LocaleKeys.update_page.tr() : LocaleKeys.add_page.tr(),
          style: theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _controller.formKey,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: ListView(
            children: [
              SizedBox(height: 18.h),
              if (isEditMode)
                TextFormField(
                  controller: _controller.idController,
                  decoration: _inputDecoration(LocaleKeys.enterProductId.tr(), theme),
                  enabled: false,
                  style: theme.textTheme.bodyMedium,
                ),
              SizedBox(height: 25.h),
              TextFormField(
                controller: _controller.titleController,
                decoration: _inputDecoration(LocaleKeys.textFormFieldTitle.tr(), theme),
                validator: (val) =>
                    val == null || val.isEmpty ? LocaleKeys.enter_title.tr() : null,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 25.h),
              TextFormField(
                controller: _controller.priceController,
                decoration: _inputDecoration(LocaleKeys.textFormFieldPrice.tr(), theme),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? LocaleKeys.enter_price.tr() : null,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 25.h),
              TextFormField(
                controller: _controller.descriptionController,
                decoration: _inputDecoration(LocaleKeys.textFormFieldDescription.tr(), theme),
                maxLines: 1,
                validator: (val) =>
                    val == null || val.isEmpty ? LocaleKeys.enter_description.tr() : null,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 25.h),
              TextFormField(
                controller: _controller.imageUrlController,
                decoration: _inputDecoration(LocaleKeys.textFormFieldImageUrl.tr(), theme),
                validator: (val) =>
                    val == null || val.isEmpty ? LocaleKeys.enter_image_url.tr() : null,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 60.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  backgroundColor: isEditMode
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondaryContainer, // or choose any theme color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: _handleSubmit,
                child: Text(
                  isEditMode
                      ? LocaleKeys.updateProductButtonText.tr()
                      : LocaleKeys.addProductButtonText.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
