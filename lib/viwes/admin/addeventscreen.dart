
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/category-dropdown_controller.dart';
import '../../controllers/is-sale-controller.dart';
import '../../controllers/products-images-controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event.dart';
import '../../utils/appconstant.dart';
import '../../utils/generate_id.dart';
import '../../widgets/dropdown-categories-widget.dart';
import 'mapsceen.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // Controllers for managing images, categories, and sale options
  final AddImagesController addProductImagesController = Get.put(AddImagesController());

  final CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController());

  final IsSaleController isSaleController = Get.put(IsSaleController());

  // Text controllers for product fields
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController fullPriceController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventDayController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  LatLng? selectedLocation;
  var zoomLevel = 10.0.obs; // مستوى التكبير الافتراضي
   final MapController _mapController = MapController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  void _selectLocation(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  void zoomIn() {
    if (zoomLevel.value < 18) {
      zoomLevel.value += 1;
      _mapController.move(_mapController.camera.center, zoomLevel.value);
    }
  }

  void zoomOut() {
    if (zoomLevel.value > 5) {
      zoomLevel.value -= 1;
      _mapController.move(_mapController.camera.center, zoomLevel.value);
    }
  }
  void _navigateToMap() async {
    LatLng? location = await Get.to(() => MapScreen(onLocationSelected: _selectLocation));
    if (location != null) {
      setState(() {
        selectedLocation = location;
      });
    }
  }



  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("اختر التاريخ"),
          content: Container(
            width: double.maxFinite, // يضمن الامتداد الأقصى للعرض
            child: Column(
              mainAxisSize: MainAxisSize.min, // يجعل الحجم يعتمد على المحتوى
              children: [
                SizedBox(
                  height: 400, // تحديد ارتفاع مناسب لتجنب أخطاء التخطيط
                  child: TableCalendar(
                    focusedDay: _selectedDate,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    calendarFormat: _calendarFormat,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        eventDateController.text = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
                        eventDayController.text = _getDayName(selectedDay);
                      });
                      Navigator.pop(context);
                    },
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        eventTimeController.text = pickedTime.format(context);
      });
    }
  }

  String _getDayName(DateTime date) {
    List<String> days = ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("إضافة حدث", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Selection Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("اختار الصور",style: TextStyle(color: AppConstant.appMainColor)),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: const Text("حدد الصور",style: TextStyle(color: AppConstant.appMainColor)),
                    )
                  ],
                ),
              ),
              // Display Selected Images
              GetBuilder<AddImagesController>(
                init: AddImagesController(),
                builder: (imageController) {
                  return imageController.selectedIamges.isNotEmpty
                      ? Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: Get.height / 3.0,
                    child: GridView.builder(
                      itemCount: imageController.selectedIamges.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Image.file(
                              File(addProductImagesController.selectedIamges[index].path),
                              fit: BoxFit.cover,
                              height: Get.height / 4,
                              width: Get.width / 2,
                            ),
                            Positioned(
                              right: 10,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  imageController.removeImages(index);
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Icon(Icons.close, color: AppConstant.appTextColor),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                      : const SizedBox.shrink();
                },
              ),
              // Category Dropdown
              const DropDownCategoriesWiidget(),

              // Sale Switch
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("هل يوجد حسم؟"),
                          Switch(
                            value: isSaleController.isSale.value,
                            activeColor: AppConstant.appMainColor,
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Product Name Field
              _buildTextFormField(
                controller: eventNameController,
                hintText: "اسم الحدث",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الحدث';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),

              // Sale Price Field
              Obx(() {
                return isSaleController.isSale.value
                    ? _buildTextFormField(
                  controller: salePriceController,
                  hintText: "السعر بعد الحسم",
                  validator: (value) {
                    if (isSaleController.isSale.value && (value == null || value.isEmpty)) {
                      return 'يرجى إدخال السعر بعد الحسم';
                    }
                    return null;
                  },
                )
                    : const SizedBox.shrink();
              }),
              SizedBox(height: 10,),
              // Full Price Field
              _buildTextFormField(
                controller: fullPriceController,
                hintText: "سعر التذكرة",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال سعر التذكرة';
                  }
                  return null;
                },
              ),


              SizedBox(height: 10,),


              // Product Description Field
              _buildTextFormField(
                controller: eventDescriptionController,
                hintText: "شرح عن الحدث",

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال شرح عن الحدث   ';
                  }
                  return null;
                },
                maxLines: 5, // تكبير الحقل ليشمل 5 أسطر
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10,),
              _buildTextFormField(
                controller: notesController,
                hintText: "ملاحظات",
              ),
              SizedBox(height: 10,),

              ElevatedButton(
                onPressed: _showCalendarDialog,
                child: Text("اختر التاريخ",style: TextStyle(color: AppConstant.appMainColor)),
              ),
              _buildTextField(eventDateController, "تاريخ الحدث", readOnly: true, onTap: _showCalendarDialog),
              _buildTextField(eventDayController, "اليوم", readOnly: true),
              _buildTextField(eventTimeController, "الوقت", readOnly: true, onTap: _selectTime),
              // عرض الموقع المحدد
              selectedLocation != null
                  ? Text("الموقع المحدد: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}")
                  : Text("لم يتم تحديد الموقع بعد"),

              // زر لفتح صفحة الخريطة
              ElevatedButton(
                onPressed: _navigateToMap, // التنقل لصفحة الخريطة
                child: const Text("حدد الموقع على الخريطة"),
              ),

              // Upload Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      EasyLoading.show();

                      // Upload Images
                      await addProductImagesController.uploadFunction(addProductImagesController.selectedIamges);

                      // Generate Product ID
                      String productId = await GenerateIds().generateProductId();


                      // Create Product Model
                      EventModel productModel = EventModel(
                        eventId: productId,
                        categoryId: categoryDropDownController.selectedCategoryId.toString(),
                        eventName: eventNameController.text.trim(),
                        categoryName: categoryDropDownController.selectedCategoryName.toString(),
                        salePrice: salePriceController.text.isNotEmpty ? salePriceController.text.trim() : '',
                        fullPrice: fullPriceController.text.trim(),
                        eventImages: addProductImagesController.arrImagesUrl,
                        productDescription: eventDescriptionController.text.trim(),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        isSale: isSaleController.isSale.value,
                        latitude:selectedLocation!.latitude,
                        longitude: selectedLocation!.longitude,
                        eventDate: eventDateController.text,
                        eventDay: eventDateController.text,
                        eventTime: eventTimeController.text,
                        notes: notesController.text,

                      );

                      // Save Product to Firestore
                      await FirebaseFirestore.instance.collection('events').doc(productId).set(productModel.toMap());

                      EasyLoading.dismiss();
                    } catch (e) {
                      EasyLoading.dismiss();
                      print("Error: $e");
                    }
                  } else {
                    // Show error message if validation fails
                    EasyLoading.showToast('يرجى تعبئة جميع الحقول المطلوبة');
                  }
                },
                child: const Text("إضافة",style: TextStyle(color: AppConstant.appMainColor)),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields with validation
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines, // السماح للحقل بالتوسع تلقائيًا
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          hintText: hintText,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
    );
  }
  Widget _buildTextField(TextEditingController controller, String hintText, {bool readOnly = false, VoidCallback? onTap}) {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          hintText: hintText,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          suffixIcon: Icon(readOnly ? Icons.access_time : null),
        ),
      ),
    );
  }
}
