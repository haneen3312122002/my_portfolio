import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AppErrorMessage {
  final String title;
  final String message;

  const AppErrorMessage({required this.title, required this.message});
}

class AppErrorMapper {
  static AppErrorMessage map(Object error) {
    // Firebase Storage
    if (error is FirebaseException && error.plugin == 'firebase_storage') {
      switch (error.code) {
        case 'unauthorized':
          return const AppErrorMessage(
            title: 'Permission denied',
            message: 'You are not allowed to upload files.',
          );
        case 'canceled':
          return const AppErrorMessage(
            title: 'Canceled',
            message: 'Upload was canceled.',
          );
        default:
          return AppErrorMessage(
            title: 'Upload error',
            message: error.message ?? 'Something went wrong during upload.',
          );
      }
    }

    // Firestore
    if (error is FirebaseException && error.plugin == 'cloud_firestore') {
      switch (error.code) {
        case 'permission-denied':
          return const AppErrorMessage(
            title: 'Permission denied',
            message: 'You are not allowed to update this data.',
          );
        case 'unavailable':
          return const AppErrorMessage(
            title: 'Network issue',
            message:
                'Service unavailable. Check your connection and try again.',
          );
        default:
          return AppErrorMessage(
            title: 'Database error',
            message: error.message ?? 'Something went wrong.',
          );
      }
    }

    // Firebase Auth
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'network-request-failed':
          return const AppErrorMessage(
            title: 'Network issue',
            message: 'Check your connection and try again.',
          );
        default:
          return AppErrorMessage(
            title: 'Auth error',
            message: error.message ?? 'Authentication failed.',
          );
      }
    }

    // Timeout
    if (error is TimeoutException) {
      return const AppErrorMessage(
        title: 'Timeout',
        message: 'The request took too long. Please try again.',
      );
    }

    // Fallback
    return AppErrorMessage(title: 'Error', message: error.toString());
  }
}
