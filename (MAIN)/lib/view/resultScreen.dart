import 'dart:io';
import 'dart:math';

import 'package:breed_coster/controller/classificationController.dart';
import 'package:breed_coster/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.imageFile});

  final File imageFile;
  String selectedBreed = "";
  String selectedGender = "";
  String selectedWeight = "";
  bool isLoading = false;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

List<String> breedList = ["Sahiwal", "Desi", "Dhanni", "Kamori", "Red Sindhi"];
List<String> genderList = ["Male", "Female"];
List<String> weightList = [
  "120 kg",
  "130 kg",
  "140 kg",
  "150 kg",
  "160 kg",
  "170 kg",
  "180 kg",
  "190 kg",
];

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      widget.isLoading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        widget.isLoading = false;
        // generateRandomInteger();
      });
    });
    super.initState();
  }

  // void generateRandomInteger() {
  //   // Use the Random class to generate a random index
  //   final random = Random();
  //   final breedIndex = random.nextInt(breedList.length);
  //   final genderIndex = random.nextInt(genderList.length);
  //   final wightIndex = random.nextInt(weightList.length);
  //
  //   // Retrieve the random integer from the list
  //   final breedInt = breedList[breedIndex];
  //   final genderInt = genderList[genderIndex];
  //   final weightInt = weightList[wightIndex];
  //
  //   // Update the state to trigger a rebuild with the new random integer
  //   setState(() {
  //     widget.selectedBreed = breedInt;
  //     widget.selectedGender = genderInt;
  //     widget.selectedWeight = weightInt;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ClassificationController controller = Get.put(ClassificationController());

    // Services().makeRequest(widget.imageFile);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Predicted Data Screen",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 28.sp),)
      ),
      body: Center(
        child: widget.isLoading
            ? Lottie.asset("assets/json/loading.json")
            : Container(
                height: 0.2.sh,
                width: 0.8.sw,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2.w),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          heading("Breed Detected"),
                          result("${controller.maxBreedKey.value.toString()}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          heading("Gender Detected"),
                          result("${controller.maxGenderKey.value.toString()}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          heading("Weight Detected"),
                          result("${controller.maxWeightKey.value.toString()}"),
                        ],
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }

  Widget heading(String headingText) {
    return Text(
      headingText,
      style: TextStyle(
        fontSize: 23.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget result(String resultText) {
    return Text(
      resultText,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19.sp),
    );
  }
}
