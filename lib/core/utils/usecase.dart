import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';

// Base class for UseCases in Clean Architecture
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Used when a UseCase doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}