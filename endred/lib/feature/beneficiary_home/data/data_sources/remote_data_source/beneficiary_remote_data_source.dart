import 'package:dio/dio.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/beneficiary_data_source.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/add_beneficiary_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/get_beneficiaries_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/top_up_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/libraries/api_client.dart';

class BeneficiaryRemoteDataSource extends BeneficiaryDataSource {
  final BeneficiaryResponseMapper beneficiaryResponseMapper;
  final ApiClient apiClient;

  BeneficiaryRemoteDataSource({
    required this.beneficiaryResponseMapper,
    required this.apiClient,
  });

  @override
  Future<UserData> getBeneficiaries() async {
    String url = 'https://edenred/beneficiaries';
    final Response? response = await apiClient.get(url);
    if (response != null && response.statusCode == 200) {
      return beneficiaryResponseMapper.map(response.data["result"]);
    } else {
      throw FetchBeneficiariesException(
        response: response,
      );
    }
  }

  @override
  Future<UserData?> addNewBeneficiary({
    required String beneficiaryName,
    required String phoneNumber,
  }) async {
    String url = 'https://edenred/beneficiaries/add';
    Map<String, String> addBeneficiaryData = {
      "name": beneficiaryName,
      "phone": phoneNumber,
    };
    final Response? response =
        await apiClient.post(url, data: addBeneficiaryData);
    if (response != null && response.statusCode == 200) {
      return beneficiaryResponseMapper.map(response.data["result"]);
    } else {
      throw AddBeneficiaryException(
        response: response,
      );
    }
  }

  @override
  Future<UserData?> topUpBeneficiary({
    required BeneficiaryModel beneficiary,
    required double amount,
  }) async {
    String url = 'https://edenred/beneficiaries/top_up';
    Map<String, String> addBeneficiaryData = {
      "name": beneficiary.nickname,
      "phone": beneficiary.phoneNumber,
      "amount": amount.toString(),
    };
    final Response? response =
        await apiClient.post(url, data: addBeneficiaryData);
    if (response != null && response.statusCode == 200) {
      return beneficiaryResponseMapper.map(response.data["result"]);
    } else {
      throw TopUpBeneficiaryException(
        response: response,
      );
    }
  }
}

const GET_DUMMY_RESPONSE = '{"result": {"balance": 1300, "numbers": []}}';

const ADD_DUMMY_RESPONSE =
    '{"result": {"balance": 1300, "numbers": [{"nickname": "nickname1", "phone_number": "+201013615170", "available_balance": 1000}, {"nickname": "nickname2", "phone_number": "+201013615171", "available_balance": 50}, {"nickname": "nickname2", "phone_number": "+201013615170", "available_balance": 0}]}}';
