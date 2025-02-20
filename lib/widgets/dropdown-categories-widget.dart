// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category-dropdown_controller.dart';

class DropDownCategoriesWiidget extends StatelessWidget {
  const DropDownCategoriesWiidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDropDownController>(
      init: CategoryDropDownController(),
      builder: (categoriesDropDownController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value:
                    categoriesDropDownController.selectedCategoryId?.value,
                    items:
                    categoriesDropDownController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['categoryId'],
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                category['categoryImages'].toString(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(category['categoryName']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? selectedValue) async {
                      categoriesDropDownController
                          .setSelectedCategory(selectedValue);
                      String? categoryName = await categoriesDropDownController
                          .getCategoryName(selectedValue);
                      categoriesDropDownController
                          .setSelectedCategoryName(categoryName);
                    },
                    //تتجه أنظار عشاق كرة القدم حول العالم إلى المواجهة النهائية المرتقبة بين (اسم الفريق الأول) و**(اسم الفريق الثاني)**، حيث سيتواجه الفريقان على أرضية ملعب (اسم الملعب) في قمة كروية ينتظرها الجميع بفارغ الصبر.
                    hint: const Text(
                      'حدد صنف',
                    ),
                    isExpanded: true,
                    elevation: 10,
                    underline: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
