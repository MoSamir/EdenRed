import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';

abstract class AddNewBeneficiaryUseCase {
  Future<UserData?> addBeneficiary({
    required String name,
    required String phoneNumber,
  });
}

class AddNewBeneficiaryUseCaseImpl extends AddNewBeneficiaryUseCase {
  final BeneficiaryRepository beneficiaryRepository;

  AddNewBeneficiaryUseCaseImpl({
    required this.beneficiaryRepository,
  });

  @override
  Future<UserData?> addBeneficiary({
    required String name,
    required String phoneNumber,
  }) async {
    return beneficiaryRepository.addNewBeneficiary(
      beneficiaryName: name,
      phoneNumber: phoneNumber,
    );
  }
}
