abstract class GetIsUserVerified {
  Future<bool> isUserVerified();
}

class GetIsUserVerifiedImpl implements GetIsUserVerified {
  /// mock the response from BE in the login or the logic to define verification process
  /// this is stub for the verification

  GetIsUserVerifiedImpl();

  @override
  Future<bool> isUserVerified() async => Future.value(true);
}
