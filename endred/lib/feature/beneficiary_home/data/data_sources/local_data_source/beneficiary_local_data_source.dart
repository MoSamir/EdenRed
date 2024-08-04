import 'dart:convert';

import 'package:endred/feature/beneficiary_home/data/data_sources/beneficiary_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryLocalDataSource extends BeneficiaryDataSource {
  final Future<SharedPreferences> sharedPreferences;
  final BeneficiaryResponseMapper beneficiaryResponseMapper;
  static const CACHED_BENEFICIARY = 'CACHED_BENEFICIARY';

  BeneficiaryLocalDataSource({
    required this.sharedPreferences,
    required this.beneficiaryResponseMapper,
  });

  Future<void> saveBeneficiaries({
    required UserData response,
  }) async {
    (await sharedPreferences).setString(
      CACHED_BENEFICIARY,
      json.encode(response.toJson()),
    );
    (await sharedPreferences).commit();
  }

  @override
  Future<UserData?> getBeneficiaries() async {
    (await sharedPreferences).reload();
    final jsonString = (await sharedPreferences).getString(CACHED_BENEFICIARY);
    if (jsonString != null) {
      return beneficiaryResponseMapper.map(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<UserData?> addNewBeneficiary({
    required String beneficiaryName,
    required String phoneNumber,
  }) async {
    // TODO: implement topUpBeneficiary
    throw UnimplementedError();
  }

  @override
  Future<UserData> topUpBeneficiary(
      {required BeneficiaryModel beneficiary, required double amount}) {
    // TODO: implement topUpBeneficiary
    throw UnimplementedError();
  }
}
