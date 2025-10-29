import 'package:equatable/equatable.dart';

// Base class for handling failures in Clean Architecture
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure {}