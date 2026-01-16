import 'package:dio/dio.dart';

class Failure {
  final String error;
  Failure(this.error);
}

class ServerFailure extends Failure {
  ServerFailure(super.error);

  factory ServerFailure.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad certificate');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceled');
      case DioExceptionType.connectionError:
        return ServerFailure('No Internet Connection');
      case DioExceptionType.unknown:
        return ServerFailure('Oops! There was an error, please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 422 && response is Map<String, dynamic>) {
      if (response['errors'] != null) {
        final errors = response['errors'] as Map<String, dynamic>;
        final message = extractFirstError(errors);
        return ServerFailure(message);
      }
    }

    if (response is Map<String, dynamic> && response['message'] != null) {
      return ServerFailure(response['message'].toString());
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return ServerFailure('Unauthorized request');
      case 404:
        return ServerFailure('Request not found');
      case 500:
        return ServerFailure('Internal server error, please try later');
      default:
        return ServerFailure('Oops! There was an error, please try again');
    }
  }

  static String extractFirstError(Map<String, dynamic> errors) {
    try {
      final firstKey = errors.keys.first;
      final messages = errors[firstKey];
      if (messages is List && messages.isNotEmpty) {
        return messages.first.toString();
      }
      return 'Validation error occurred';
    } catch (_) {
      return 'Validation error occurred';
    }
  }
}
