import 'dart:io';

import 'package:breed_coster/controller/classificationController.dart';
import 'package:breed_coster/view/resultScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? _image;

  Future _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  openBottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  _getImageFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () {
                  _getImageFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ClassificationController controller = Get.put(ClassificationController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 28.sp),),
      ),
      body: Obx(() {
        return Center(
          child: controller.isLoading.value
              ? Lottie.asset("assets/json/loading.json")
              : SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _image == null
                          ? const SizedBox()
                          : Container(
                              height: 0.5.sh,
                              width: 0.8.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25.r,),),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.r),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      InkWell(
                        onTap: () {
                          // _getImage();
                          Get.bottomSheet(openBottomSheet());
                          // openBottomSheet();
                        },
                        child: Container(
                          height: 0.15.sh,
                          width: 0.8.sw,
                          padding: const EdgeInsets.all(9),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                weight: 22.sp,
                                size: 38.sp,
                              ),
                              Text(
                                "Select Image to checkout details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
      bottomNavigationBar: _image == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  controller.detectAnimal(_image!);
                  // Get.to(() => ResultScreen(imageFile: _image!,));
                },
                child: Container(
                  height: 50,
                  width: 90,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10,
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Find out Details!",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
