import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';

abstract class TopUpUseBeneficiaryCase {
  Future<UserData?> topUp({
    required BeneficiaryModel beneficiary,
    required double amount,
  });
}

class TopUpUseBeneficiaryCaseImpl implements TopUpUseBeneficiaryCase {
  BeneficiaryRepository beneficiaryRepository;

  TopUpUseBeneficiaryCaseImpl({
    required this.beneficiaryRepository,
  });

  @override
  Future<UserData?> topUp({
    required BeneficiaryModel beneficiary,
    required double amount,
  }) async {
    return beneficiaryRepository.topUpBeneficiary(
      beneficiary: beneficiary,
      amount: amount,
    );
  }
}
