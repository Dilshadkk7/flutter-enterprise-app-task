import 'package:equatable/equatable.dart';

// Base class for handling failures in Clean Architecture
abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {
  CacheFailure({String? message}) : super(message: message);
}

class NetworkFailure extends Failure {}