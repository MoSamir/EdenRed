import 'package:endred/feature/beneficiary_home/domain/exceptions/base_exception.dart';

class FetchBeneficiariesException extends EdenRedBeneficiaryException {
  const FetchBeneficiariesException({required super.response});
}
