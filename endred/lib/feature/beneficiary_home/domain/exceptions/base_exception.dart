import 'package:dio/dio.dart';

abstract class EdenRedBeneficiaryException implements Exception {
  final Response? response;

  const EdenRedBeneficiaryException({
    this.response,
  });

  @override
  String toString() {
    if (response == null) {
      return "Network error";
    } else {
      return "${response?.statusCode} ${response?.statusMessage} ${response?.data?.toString()}";
    }
  }
}
