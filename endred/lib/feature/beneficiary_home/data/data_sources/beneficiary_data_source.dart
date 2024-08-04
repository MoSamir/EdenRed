import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';

abstract class BeneficiaryDataSource {
  Future<UserData?> getBeneficiaries();
  Future<UserData?> addNewBeneficiary({
    required String beneficiaryName,
    required String phoneNumber,
  });
  Future<UserData?> topUpBeneficiary({
    required BeneficiaryModel beneficiary,
    required double amount,
  });
}
