import 'dart:developer';
import 'dart:io';

import 'package:breed_coster/services/services.dart';
import 'package:breed_coster/view/resultScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> weightAndConfidence = <String, dynamic>{}.obs;
  RxMap<String, dynamic> breedAndConfidence = <String, dynamic>{}.obs;
  RxMap<String, dynamic> genderAndConfidence = <String, dynamic>{}.obs;
  RxString maxBreedKey = ''.obs;
  RxDouble maxBreed = double.negativeInfinity.obs;
  RxString maxWeightKey = ''.obs;
  RxDouble maxWeight = double.negativeInfinity.obs;
  RxString maxGenderKey = ''.obs;
  RxDouble maxGender = double.negativeInfinity.obs;

  // RxDouble maxwigh = double.negativeInfinity.obs;

  detectAnimal(File imageFile) async {
    isLoading.value = true;
    var result = await Services().detectAnimal(imageFile);
    log(result.toString());
    if (result["predictions"].isNotEmpty) {
      if (result["predictions"][0]["class"] == "Cow-Goat") {
        getPredictedData(imageFile);
      } else {
        Get.snackbar('Error', "Choose a valid image",
            backgroundColor: Colors.red.withOpacity(0.8),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
            colorText: Colors.black);
        isLoading.value = false;
      }
    } else {
      if (result["predictions"].toString() == "[]") {
        await getPredictedData(imageFile);
      } else {
        Get.snackbar('Error', "Choose a valid image",
            backgroundColor: Colors.red.withOpacity(0.8),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
            colorText: Colors.black);
      }
      isLoading.value = false;
    }
  }

  getPredictedData(File imageFile) async {
    weightAndConfidence.value = {};
    breedAndConfidence.value = {};
    genderAndConfidence.value = {};
    // maxBreedKey.value ="";
    maxBreedKey.value = "";
    maxWeightKey.value = "";
    maxGenderKey.value = "";
    maxBreed.value = double.negativeInfinity;
    maxGender.value = double.negativeInfinity;
    maxWeight.value = double.negativeInfinity;
    // breedAndConfidence.clear();
    // genderAndConfidence.clear();
    isLoading.value = true;
    var result = await Services().makeRequest(imageFile);

    /// ispr kaam krenge
    var weightResult = await Services().makeWeightRequest(imageFile);
    Map<String, dynamic> predictions = result['predictions'];
    Map<String, dynamic> weightPredictions = weightResult['predictions'];



    predictions.forEach((key, value) {
      // if (key.contains('Kgs')) {
      //   var confidence = value['confidence'];
      //   weightAndConfidence[key] = confidence;
      // }
      // else {
      if (key == "Male" || key == "Female") {
        var confidence = value['confidence'];
        // breedAndConfidence.removeWhere((key, value) => key == "Male" || key == "Female");
        genderAndConfidence[key] = confidence;
      } else if (!key.contains('Kgs')) {
        var confidence = value['confidence'];
        breedAndConfidence[key] = confidence;
      }
      // }
    });
    weightPredictions.forEach((key, value) {
      if (key.contains('Kg')) {
        var confidence = value['confidence'];
        log("CONFIDENCE   "+confidence.toString());

        weightAndConfidence[key] = confidence;
        log("-------------------" + weightAndConfidence[key].toString());
      }
      // else {
      // if (key == "Male" || key == "Female") {
      //   var confidence = value['confidence'];
      //   // breedAndConfidence.removeWhere((key, value) => key == "Male" || key == "Female");
      //   genderAndConfidence[key] = confidence;
      // } else {
      //   var confidence = value['confidence'];
      //   breedAndConfidence[key] = confidence;
      // }
      // }
    });

    breedAndConfidence.forEach((key, value) {
      if (value > maxBreed.value) {
        maxBreedKey.value = key;
        maxBreed.value = value;
      }
    });
    weightAndConfidence.forEach((key, value) {
      if (value > maxWeight.value) {
        maxWeightKey.value = key;
        maxWeight.value = value;
      }
    });
    genderAndConfidence.forEach((key, value) {
      if (value > maxGender.value) {
        maxGenderKey.value = key;
        maxGender.value = value;
      }
    });
    log("----------------------------------------------------------");
    log("max Breed" + maxBreed.toString() + maxBreedKey.toString());
    log("----------------------------------------------------------");
    log("Max weight" + maxWeight.toString() + maxWeightKey.toString());
    log("----------------------------------------------------------");
    log("max gender" + maxGender.toString() + maxGenderKey.toString());

    /// This is done to handle that the uploaded image should be valid
    // if (maxBreed < 0.3 || maxGender < 0.3) {
    //   Get.snackbar('Error', "Choose a valid image",
    //       backgroundColor: Colors.red.withOpacity(0.8),
    //       snackPosition: SnackPosition.BOTTOM,
    //       duration: Duration(seconds: 5),
    //       colorText: Colors.black);
    // } else {
    Get.to(() => ResultScreen(
          imageFile: imageFile,
        ));
    // }

    // log("----------------------------------------------------------");
    // log("another predictionsssssssssssssssssssssss" +
    //     breedAndConfidence.toString());
    // log("another predictionsssssssssssssssssssssss" +
    //     breedAndConfidence.keys.length.toString());
    // // breedAndConfidence.forEach((key, value) {
    //
    // // });
    // log("----------------------------------------------------------");
    // log("another gender" + genderAndConfidence.toString());
    // log("another gender" + genderAndConfidence.keys.length.toString());
    isLoading.value = false;
  }
}
