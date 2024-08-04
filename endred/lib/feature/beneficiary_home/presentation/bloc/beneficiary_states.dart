import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:equatable/equatable.dart';

abstract class BeneficiaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BeneficiaryLoadedState extends BeneficiaryState {
  final UserData beneficiaries;

  BeneficiaryLoadedState({required this.beneficiaries});

  @override
  List<Object?> get props => [beneficiaries];
}

class BeneficiaryErrorState extends BeneficiaryState {
  final String message;

  BeneficiaryErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AddBeneficiaryErrorState extends BeneficiaryState {
  final String message;

  AddBeneficiaryErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class BeneficiaryEmptyState extends BeneficiaryState {}

class BeneficiaryLoadingState extends BeneficiaryState {}

class AddNewBeneficiaryShowDialogState extends BeneficiaryState {}

class TopUpMaxLimitsExceeded extends BeneficiaryState {}

class TopUpCanBeProceeded extends BeneficiaryState {
  final BeneficiaryModel beneficiary;

  TopUpCanBeProceeded({required this.beneficiary});

  @override
  List<Object?> get props => [beneficiary];
}
