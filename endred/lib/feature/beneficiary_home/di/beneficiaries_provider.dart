import 'package:dio/dio.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/local_data_source/beneficiary_local_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/remote_data_source/beneficiary_remote_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/add_beneficiary_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/get_beneficiaries_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/top_up_use_case.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_bloc.dart';
import 'package:endred/libraries/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

BeneficiaryBloc initBeneficiaryBloc() {
  return BeneficiaryBloc(
    getBeneficiariesUseCase: _getBeneficiariesUseCase(),
    addNewBeneficiariesUseCase: _addBeneficiariesUseCase(),
    topUpBeneficiaryUseCase: _topUpBeneficiaryUseCase(),
  );
}

AddNewBeneficiaryUseCase _addBeneficiariesUseCase() {
  return AddNewBeneficiaryUseCaseImpl(
    beneficiaryRepository: _beneficiaryRepository(),
  );
}

TopUpUseBeneficiaryCase _topUpBeneficiaryUseCase() {
  return TopUpUseBeneficiaryCaseImpl(
    beneficiaryRepository: _beneficiaryRepository(),
  );
}

GetBeneficiariesUseCase _getBeneficiariesUseCase() {
  return GetBeneficiariesUseCaseImpl(
    beneficiaryRepository: _beneficiaryRepository(),
  );
}

BeneficiaryRepository _beneficiaryRepository() {
  return BeneficiaryRepositoryImpl(
    localDataSource: _beneficiaryLocalDataSource(),
    remoteDataSource: _beneficiaryRemoteDataSource(),
  );
}

BeneficiaryLocalDataSource _beneficiaryLocalDataSource() {
  return BeneficiaryLocalDataSource(
    sharedPreferences: SharedPreferences.getInstance(),
    beneficiaryResponseMapper: BeneficiaryResponseMapperImpl(),
  );
}

BeneficiaryRemoteDataSource _beneficiaryRemoteDataSource() {
  return BeneficiaryRemoteDataSource(
    apiClient: _apiClient(),
    beneficiaryResponseMapper: BeneficiaryResponseMapperImpl(),
  );
}

ApiClient _apiClient() {
  return ApiClientImpl(
    dio: Dio(),
  );
}
