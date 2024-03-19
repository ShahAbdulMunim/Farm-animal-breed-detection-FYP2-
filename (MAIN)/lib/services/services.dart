import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';


class Services{


  detectAnimal(File imageFile) async {
    String apiUrl =
        // 'https://classify.roboflow.com/breed-gender-detection/2';
    'https://detect.roboflow.com/animal-detection-88yph/1';
    String apiKey =
        // 'ch1Sixwf6LzttzG4bbp0';
    'nseADphIznUZ8K0xsNoU';
    String completeUrl = '$apiUrl?api_key=$apiKey';
    var request = http.MultipartRequest('POST', Uri.parse(completeUrl));
    var mediaType = mime(imageFile.path)!.split('/');
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path,
        contentType: MediaType(mediaType[0], mediaType[1])));
    request.headers.addAll({
    'Content-Type': 'multipart/form-data',
    });
    var response = await request.send();

    if (response.statusCode == 200) {
    var abc =  await response.stream.bytesToString();
    // makeRequest( imageFile);
    log(jsonDecode(abc).toString());
    return jsonDecode(abc);
    } else {
    log('Error: ${response.statusCode}');

    }
  }


   makeRequest(File imageFile) async {
    String apiUrl =
        'https://classify.roboflow.com/breed-gender-detection/2';
        // 'https://detect.roboflow.com/animal-detection-88yph/1';
    String apiKey =
        'ch1Sixwf6LzttzG4bbp0';
        // 'nseADphIznUZ8K0xsNoU';
    String completeUrl = '$apiUrl?api_key=$apiKey&confidence=70';
    var request = http.MultipartRequest('POST', Uri.parse(completeUrl));
    var mediaType = mime(imageFile.path)!.split('/');
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path,
        contentType: MediaType(mediaType[0], mediaType[1])));
    request.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });
    request.fields["confidence"] = "1";
    // request.fields.addAll(other)
    var response = await request.send();
    log("fields---------------------"+request.fields.toString());

    if (response.statusCode == 200) {
      // makeWeightRequest(imageFile);
      var abc =  await response.stream.bytesToString();
      log(jsonDecode(abc).toString());
      return jsonDecode(abc);
    } else {
      log('Error: ${response.statusCode}');

    }
  }
   makeWeightRequest(File imageFile) async {
    String apiUrl =
        'https://classify.roboflow.com/weight_gender-detection/1';
        // 'https://detect.roboflow.com/animal-detection-88yph/1';
    String apiKey =
        'RKDlR5KmshvTj7hbCT8V';
        // 'nseADphIznUZ8K0xsNoU';
    String completeUrl = '$apiUrl?api_key=$apiKey&confidence=70';
    var request = http.MultipartRequest('POST', Uri.parse(completeUrl));
    var mediaType = mime(imageFile.path)!.split('/');
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path,
        contentType: MediaType(mediaType[0], mediaType[1])));
    request.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });
    request.fields["confidence"] = "1";
    // request.fields.addAll(other)
    var response = await request.send();
    log("fields---------------------"+request.fields.toString());
    log("url---------------------"+apiUrl.toString());
    log("files---------------------"+request.files.toString());
    // log("fields---------------------"+request.fields.toString());

    if (response.statusCode == 200) {
      var abc =  await response.stream.bytesToString();
      log(jsonDecode(abc).toString());
      return jsonDecode(abc);
    } else {
      log('Error: ${response.statusCode}');

    }
  }

}