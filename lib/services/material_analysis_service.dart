import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MaterialAnalysisResult {
  final String materialType;
  final String condition;
  final String urgency;
  final String recoveryPath;
  final String suggestedReceiver;
  final String expectedPoints;
  final String generatedDescription;
  final String impactEstimate;

  MaterialAnalysisResult({
    required this.materialType,
    required this.condition,
    required this.urgency,
    required this.recoveryPath,
    required this.suggestedReceiver,
    required this.expectedPoints,
    required this.generatedDescription,
    required this.impactEstimate,
  });

  factory MaterialAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MaterialAnalysisResult(
      materialType: json['materialType']?.toString() ?? 'Needs review',
      condition: json['condition']?.toString() ?? 'Needs review',
      urgency: json['urgency']?.toString() ?? 'Medium urgency',
      recoveryPath: json['recoveryPath']?.toString() ?? 'Manual review',
      suggestedReceiver:
      json['suggestedReceiver']?.toString() ?? 'Recovery partner',
      expectedPoints:
      json['expectedPoints']?.toString() ?? 'Pending estimate',
      generatedDescription:
      json['generatedDescription']?.toString() ??
          'No description generated.',
      impactEstimate:
      json['impactEstimate']?.toString() ?? 'Impact estimate unavailable.',
    );
  }
}

class MaterialAnalysisService {
  // Android emulator uses 10.0.2.2 to reach your laptop localhost.
  // If you test on a real phone, replace this with your laptop IP:
  // Example: http://192.168.1.20:5000
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<MaterialAnalysisResult> analyzeMaterial({
    required File imageFile,
    required String quantity,
    required String pickupTime,
  }) async {
    final url = Uri.parse('$baseUrl/analyze-material');

    try {
      final request = http.MultipartRequest('POST', url);

      request.fields['quantity'] =
      quantity.trim().isEmpty ? 'unknown' : quantity.trim();

      request.fields['pickupTime'] =
      pickupTime.trim().isEmpty ? 'not specified' : pickupTime.trim();

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 45),
      );

      final response = await http.Response.fromStream(streamedResponse);

      Map<String, dynamic> data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        throw Exception('Invalid server response');
      }

      if (response.statusCode == 200 && data['success'] == true) {
        return MaterialAnalysisResult.fromJson(data['result']);
      }

      throw Exception(data['message'] ?? 'Material analysis failed');
    } on SocketException {
      throw Exception('Cannot connect to backend server');
    } on HttpException {
      throw Exception('HTTP error while analyzing material');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}