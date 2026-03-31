// lib/dio_config.dart
import 'package:dio/dio.dart';

final dioClient = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 10),
));