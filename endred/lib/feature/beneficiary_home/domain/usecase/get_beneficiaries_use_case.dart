import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';

abstract class GetBeneficiariesUseCase {
  Future<UserData?> getBeneficiaries();
}

class GetBeneficiariesUseCaseImpl extends GetBeneficiariesUseCase {
  final BeneficiaryRepository beneficiaryRepository;

  GetBeneficiariesUseCaseImpl({
    required this.beneficiaryRepository,
  });

  @override
  Future<UserData?> getBeneficiaries() async {
    return beneficiaryRepository.getBeneficiaries();
  }
}
