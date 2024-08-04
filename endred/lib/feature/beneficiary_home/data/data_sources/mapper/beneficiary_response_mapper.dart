import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';

abstract class BeneficiaryResponseMapper {
  UserData map(Map<String, dynamic> response);
}

class BeneficiaryResponseMapperImpl implements BeneficiaryResponseMapper {
  @override
  UserData map(Map<String, dynamic> response) {
    return UserData(
      balance: double.tryParse((response['balance'] ?? 0).toString()) ?? 0.0,
      beneficiaries: _mapBeneficiaries(response['numbers']),
      availableBalance:
          double.tryParse((response['availableBalance'] ?? 0).toString()) ??
              0.0,
      maxNumberOfBeneficiariesAllowed:
          response['maxNumberOfBeneficiariesAllowed'] ?? 5,
    );
  }

  List<BeneficiaryModel> _mapBeneficiaries(List<dynamic>? beneficiariesList) {
    List<BeneficiaryModel> beneficiaries = [];

    if (beneficiariesList == null || beneficiariesList.isEmpty) {
      return beneficiaries;
    }

    for (var beneficiaryMap in beneficiariesList) {
      if (beneficiaryMap is Map<String, dynamic> &&
          beneficiaryMap['id'] != null) {
        try {
          beneficiaries.add(BeneficiaryModel(
            id: beneficiaryMap['id'],
            availableBalance: double.tryParse(
                    (beneficiaryMap['availableBalance'] ?? 0.0).toString()) ??
                0.0,
            nickname: beneficiaryMap['nickname'],
            phoneNumber: beneficiaryMap['phoneNumber'],
          ));
        } catch (e) {
          /// should log the error or report to an observability tool
        }
      }
    }
    return beneficiaries;
  }
}
