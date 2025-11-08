import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });
}
