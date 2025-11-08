abstract class AuthRemoteDataSource {
  Future<void> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would make an API call here.
    // For this mock, we assume the login is always successful.
  }
}
