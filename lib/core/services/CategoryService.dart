import 'package:marketky/core/model/Category.dart';

class CategoryService {
  static List<Category> categoryData = categoryRawData.map((data) => Category.fromJson(data)).toList();
}

var categoryRawData = [
  {
    'featured': true,
    'icon_url': 'assets/icons/Discount.svg',
    'name': 'all',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/shirts-garment-fashion-woman-man-wear-svgrepo-com.svg',
    'name': 'woman shirts',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Woman-dress.svg',
    'name': 'woman dresses',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Man-Pants.svg',
    'name': 'woman pants',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/skirt-svgrepo-com.svg',
    'name': 'woman skirts',
  },
];
