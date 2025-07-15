import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/api_response.dart';
import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../../core/data/data_provider.dart';

class DashBoardProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addProductFormKey = GlobalKey<FormState>();

  // Text controllers
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescCtrl = TextEditingController();
  TextEditingController productQntCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  TextEditingController productOffPriceCtrl = TextEditingController();

  // Dropdown selections
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Brand? selectedBrand;

  // Variant Map
  Map<VariantType, List<String>> selectedVariantsMap = {};

  // Product being updated
  Product? productForUpdate;

  // Images
  File? selectedMainImage, selectedSecondImage, selectedThirdImage, selectedFourthImage, selectedFifthImage;
  XFile? mainImgXFile, secondImgXFile, thirdImgXFile, fourthImgXFile, fifthImgXFile;

  // Filtered lists
  List<SubCategory> subCategoriesByCategory = [];
  List<Brand> brandsBySubCategory = [];

  DashBoardProvider(this._dataProvider);

  Future<void> addProduct() async {
    try {
      if (selectedMainImage == null) {
        SnackBarHelper.showErrorSnackBar("Please Choose A Image!");
        return;
      }

      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'proBrandId': selectedBrand?.sId ?? '',
        'price': productPriceCtrl.text,
        'offerPrice': productOffPriceCtrl.text.isEmpty ? productPriceCtrl.text : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
        'variants': selectedVariantsMap.map((key, value) => MapEntry(key.sId ?? '', value)),
      };

      final FormData form = await createFormDataForMultipleImage(imgXFiles: [
        {'image1': mainImgXFile},
        {'image2': secondImgXFile},
        {'image3': thirdImgXFile},
        {'image4': fourthImgXFile},
        {'image5': fifthImgXFile}
      ], formData: formDataMap);

      final response = await service.addItem(endpointUrl: 'products', itemData: form);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add product: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error: ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  Future<void> updateProduct() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'proBrandId': selectedBrand?.sId ?? '',
        'price': productPriceCtrl.text,
        'offerPrice': productOffPriceCtrl.text.isEmpty ? productPriceCtrl.text : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
        'variants': selectedVariantsMap.map((key, value) => MapEntry(key.sId ?? '', value)),
      };

      final FormData form = await createFormDataForMultipleImage(imgXFiles: [
        {'image1': mainImgXFile},
        {'image2': secondImgXFile},
        {'image3': thirdImgXFile},
        {'image4': fourthImgXFile},
        {'image5': fifthImgXFile},
      ], formData: formDataMap);

      final response = await service.updateItem(endpointUrl: 'products', itemData: form, itemId: productForUpdate?.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to update product: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error: ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  void submitProduct() {
    if (productForUpdate != null) {
      updateProduct();
    } else {
      addProduct();
    }
  }

  Future<FormData> createFormDataForMultipleImage({
    required List<Map<String, XFile?>> imgXFiles,
    required Map<String, dynamic> formData,
  }) async {
    for (int i = 0; i < imgXFiles.length; i++) {
      XFile? file = imgXFiles[i]['image${i + 1}'];
      if (file != null) {
        if (kIsWeb) {
          formData['image${i + 1}'] = MultipartFile(await file.readAsBytes(), filename: file.name);
        } else {
          formData['image${i + 1}'] = await MultipartFile(file.path, filename: file.path.split('/').last);
        }
      }
    }

    return FormData(formData);
  }

  void pickImage({required int imageCardNumber}) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      switch (imageCardNumber) {
        case 1:
          selectedMainImage = File(image.path);
          mainImgXFile = image;
          break;
        case 2:
          selectedSecondImage = File(image.path);
          secondImgXFile = image;
          break;
        case 3:
          selectedThirdImage = File(image.path);
          thirdImgXFile = image;
          break;
        case 4:
          selectedFourthImage = File(image.path);
          fourthImgXFile = image;
          break;
        case 5:
          selectedFifthImage = File(image.path);
          fifthImgXFile = image;
          break;
      }
      notifyListeners();
    }
  }

  void filterSubcategory(Category category) {
    selectedCategory = category;
    selectedSubCategory = null;
    selectedBrand = null;

    subCategoriesByCategory = _dataProvider.subCategories
        .where((sub) => sub.categoryId?.sId == category.sId)
        .toList();

    brandsBySubCategory.clear();
    notifyListeners();
  }

  void filterBrand(SubCategory subCategory) {
    selectedSubCategory = subCategory;
    selectedBrand = null;

    brandsBySubCategory = _dataProvider.brands
        .where((brand) => brand.subcategoryId?.sId == subCategory.sId)
        .toList();

    notifyListeners();
  }

  // Variant Type helpers
  List<String> getVariantsByType(VariantType type) {
    return _dataProvider.variants
        .where((variant) => variant.variantTypeId?.sId == type.sId)
        .map((v) => v.name ?? '')
        .toList();
  }

  void updateSelectedVariants(VariantType type, List<String> selectedValues) {
    selectedVariantsMap[type] = selectedValues;
    notifyListeners();
  }

  void setDataForUpdateProduct(Product? product) {
    if (product != null) {
      productForUpdate = product;

      productNameCtrl.text = product.name ?? '';
      productDescCtrl.text = product.description ?? '';
      productPriceCtrl.text = '${product.price}';
      productOffPriceCtrl.text = '${product.offerPrice}';
      productQntCtrl.text = '${product.quantity}';

      selectedCategory = _dataProvider.categories.firstWhereOrNull((c) => c.sId == product.proCategoryId?.sId);
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull((sc) => sc.sId == product.proSubCategoryId?.sId);
      selectedBrand = _dataProvider.brands.firstWhereOrNull((b) => b.sId == product.proBrandId?.sId);

      subCategoriesByCategory = _dataProvider.subCategories
          .where((sc) => sc.categoryId?.sId == selectedCategory?.sId)
          .toList();
      brandsBySubCategory = _dataProvider.brands
          .where((b) => b.subcategoryId?.sId == selectedSubCategory?.sId)
          .toList();

      selectedVariantsMap.clear();
      for (var variantType in _dataProvider.variantTypes) {
        final allVariants = getVariantsByType(variantType);
        final selected = product.proVariantId?.where((id) => allVariants.contains(id)).toList() ?? [];
        if (selected.isNotEmpty) {
          selectedVariantsMap[variantType] = selected;
        }
      }
    } else {
      clearFields();
    }
  }

  void clearFields() {
    productNameCtrl.clear();
    productDescCtrl.clear();
    productPriceCtrl.clear();
    productOffPriceCtrl.clear();
    productQntCtrl.clear();

    selectedMainImage = null;
    selectedSecondImage = null;
    selectedThirdImage = null;
    selectedFourthImage = null;
    selectedFifthImage = null;

    mainImgXFile = null;
    secondImgXFile = null;
    thirdImgXFile = null;
    fourthImgXFile = null;
    fifthImgXFile = null;

    selectedCategory = null;
    selectedSubCategory = null;
    selectedBrand = null;

    selectedVariantsMap.clear();
    subCategoriesByCategory = [];
    brandsBySubCategory = [];

    productForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
  Future<void> deleteProduct(Product product) async {
  try {
    final response = await service.deleteItem(
      endpointUrl: 'products',
      itemId: product.sId ?? '',
    );

    if (response.isOk) {
      ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
      if (apiResponse.success == true) {
        SnackBarHelper.showSuccessSnackBar('Product deleted successfully');
        _dataProvider.getAllProduct();
      } else {
        SnackBarHelper.showErrorSnackBar('Delete failed: ${apiResponse.message}');
      }
    } else {
      SnackBarHelper.showErrorSnackBar('Error: ${response.body?['message'] ?? response.statusText}');
    }
  } catch (e) {
    SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    rethrow;
  }
}
}
