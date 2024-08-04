import 'package:equatable/equatable.dart';

/// For simplicity will use the data entities as the domain entities
/// for larger projects data entity should represent the network API data and mapped to domain entity
class BeneficiaryModel extends Equatable {
  final String id;
  final String nickname;
  final String phoneNumber;
  final double? availableBalance;

  const BeneficiaryModel({
    required this.id,
    required this.nickname,
    required this.phoneNumber,
    required this.availableBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'availableBalance': availableBalance,
    };
  }

  @override
  List<Object?> get props => [
        id,
        nickname,
        phoneNumber,
        availableBalance,
      ];

  copyWith(
      {double? availableBalance,
      String? nickname,
      String? phoneNumber,
      String? id}) {
    return BeneficiaryModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      availableBalance: availableBalance ?? this.availableBalance,
    );
  }
}

class UserData extends Equatable {
  final List<BeneficiaryModel> beneficiaries;
  final double balance, availableBalance;
  final int? maxNumberOfBeneficiariesAllowed;

  const UserData({
    required this.balance,
    required this.beneficiaries,
    required this.availableBalance,
    this.maxNumberOfBeneficiariesAllowed = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'numbers':
          beneficiaries.map((beneficiary) => beneficiary.toJson()).toList(),
      'balance': balance,
      'maxNumberOfBeneficiariesAllowed': maxNumberOfBeneficiariesAllowed,
      'availableBalance': availableBalance,
    };
  }

  @override
  List<Object?> get props => [
        balance,
        beneficiaries,
        maxNumberOfBeneficiariesAllowed,
        availableBalance,
      ];

  @override
  bool? get stringify => true;

  UserData copyWith({
    double? availableBalance,
    List<BeneficiaryModel>? beneficiaries,
    int? maxNumberOfBeneficiariesAllowed,
    double? balance,
  }) {
    return UserData(
      balance: balance ?? this.balance,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      availableBalance: availableBalance ?? this.availableBalance,
      maxNumberOfBeneficiariesAllowed: maxNumberOfBeneficiariesAllowed ??
          this.maxNumberOfBeneficiariesAllowed,
    );
  }
}
