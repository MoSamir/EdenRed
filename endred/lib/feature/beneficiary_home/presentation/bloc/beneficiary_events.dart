import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:equatable/equatable.dart';

class BeneficiaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddBeneficiary extends BeneficiaryEvent {
  final String beneficiaryName;
  final String phoneNumber;

  AddBeneficiary({
    required this.beneficiaryName,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        beneficiaryName,
        phoneNumber,
      ];
}

class LoadBeneficiaries extends BeneficiaryEvent {}

class AddNewBeneficiaryRequestEvent extends BeneficiaryEvent {}

class TopUpBeneficiaryEvent extends BeneficiaryEvent {
  final BeneficiaryModel beneficiary;
  final int amount;

  TopUpBeneficiaryEvent({
    required this.beneficiary,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        beneficiary,
        amount,
      ];
}

class TopUpBeneficiaryRequestEvent extends BeneficiaryEvent {
  final BeneficiaryModel beneficiary;

  TopUpBeneficiaryRequestEvent({
    required this.beneficiary,
  });

  @override
  List<Object?> get props => [
        beneficiary,
      ];
}
