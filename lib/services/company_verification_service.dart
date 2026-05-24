import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyVerificationResult {
  final bool verified;
  final String? nationalNumber;
  final String? companyName;
  final String? status;
  final String? type;
  final String? source;
  final String? message;

  CompanyVerificationResult({
    required this.verified,
    this.nationalNumber,
    this.companyName,
    this.status,
    this.type,
    this.source,
    this.message,
  });

  factory CompanyVerificationResult.fromJson(Map<String, dynamic> json) {
    return CompanyVerificationResult(
      verified: json['verified'] == true,
      nationalNumber: json['nationalNumber'],
      companyName: json['companyName'],
      status: json['status'],
      type: json['type'],
      source: json['source'],
      message: json['message'],
    );
  }
}

class CompanyVerificationService {
  // Android emulator uses 10.0.2.2 to reach your computer localhost.
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<CompanyVerificationResult> verifyCompany(
      String nationalNumber,
      ) async {
    final url = Uri.parse('$baseUrl/verify-company');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nationalNumber': nationalNumber,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 400) {
      return CompanyVerificationResult.fromJson(data);
    }

    throw Exception(data['message'] ?? 'Verification failed');
  }
}