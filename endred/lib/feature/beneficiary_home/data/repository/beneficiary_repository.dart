import 'dart:async';
import 'dart:math';

import 'package:endred/feature/beneficiary_home/data/data_sources/local_data_source/beneficiary_local_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/remote_data_source/beneficiary_remote_data_source.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/main.dart';

abstract class BeneficiaryRepository {
  Future<UserData?> topUpBeneficiary({
    required BeneficiaryModel beneficiary,
    required double amount,
  });

  Future<UserData?> getBeneficiaries();

  Future<UserData?> addNewBeneficiary({
    required String beneficiaryName,
    required String phoneNumber,
  });
}

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  BeneficiaryLocalDataSource localDataSource;
  BeneficiaryRemoteDataSource remoteDataSource;

  BeneficiaryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<UserData?> topUpBeneficiary({
    required BeneficiaryModel beneficiary,
    required double amount,
  }) async {
    if (localSourceOnly) {
      UserData? response = await getBeneficiaries();
      if (response == null) {
        throw Exception('No beneficiaries found');
      }
      response = response.copyWith(
        availableBalance: response.availableBalance - (amount + 1),
        beneficiaries: response.beneficiaries
            .map<BeneficiaryModel>((e) => e.id == beneficiary.id
                ? e.copyWith(availableBalance: e.availableBalance ?? 0 - amount)
                : e)
            .toList(),
      );

      await localDataSource.saveBeneficiaries(response: response);
      return localDataSource.getBeneficiaries();
    }

    final UserData? response = await remoteDataSource.topUpBeneficiary(
      beneficiary: beneficiary,
      amount: amount,
    );

    if (response != null) {
      localDataSource.saveBeneficiaries(response: response);
    }
    return response;
  }

  @override
  Future<UserData?> getBeneficiaries() async {
    UserData? response = await localDataSource.getBeneficiaries();

    if (localSourceOnly == true) {
      if (response == null) {
        return const UserData(
            balance: 10000, beneficiaries: [], availableBalance: 1000);
      }
      return response;
    }
    response ??= await remoteDataSource.getBeneficiaries();
    localDataSource.saveBeneficiaries(response: response);
    return response;
  }

  @override
  Future<UserData?> addNewBeneficiary({
    required String beneficiaryName,
    required String phoneNumber,
  }) async {
    UserData? response;
    if (localSourceOnly) {
      response = await getBeneficiaries();
      response ??= const UserData(
        balance: 1300,
        availableBalance: 800,
        beneficiaries: [],
      );
      response = response.copyWith(
        beneficiaries: [
          ...response.beneficiaries,
          BeneficiaryModel(
            id: Random().nextInt(100).toString(),
            nickname: beneficiaryName,
            phoneNumber: phoneNumber,
            availableBalance: 500,
          ),
        ],
      );
      await localDataSource.saveBeneficiaries(response: response);
      return localDataSource.getBeneficiaries();
    }

    response = await remoteDataSource.addNewBeneficiary(
        beneficiaryName: beneficiaryName, phoneNumber: phoneNumber);

    if (response != null) {
      localDataSource.saveBeneficiaries(response: response);
    }
    return response;
  }
}
