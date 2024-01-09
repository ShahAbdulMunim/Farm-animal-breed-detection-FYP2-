import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class Services{


  void makeRequest(File imageFile) async {
    String apiUrl = 'https://classify.roboflow.com/breed-gender-detection/2';
    String apiKey = 'ch1Sixwf6LzttzG4bbp0';

    // Construct the complete URL
    String completeUrl = '$apiUrl?api_key=$apiKey';

    // Read image file as bytes
    List<int> imageBytes =  File(imageFile.path).readAsBytesSync();

    // Convert bytes to base64
    String base64Image = base64.encode(imageBytes);

    // Make POST request
    final response = await http.post(
      Uri.parse(completeUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'api_key': apiKey,
        'image': base64Image,
      },
    );

    // Process the response
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode}');
      print('Error: ${response.body}');
      print('Image: ${base64Image}');
    }
  }

}