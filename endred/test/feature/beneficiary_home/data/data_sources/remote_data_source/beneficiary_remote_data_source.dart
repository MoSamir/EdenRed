import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/mapper/beneficiary_response_mapper.dart';
import 'package:endred/feature/beneficiary_home/data/data_sources/remote_data_source/beneficiary_remote_data_source.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/add_beneficiary_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/get_beneficiaries_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/exceptions/top_up_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/libraries/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockBeneficiaryResponseMapper extends Mock
    implements BeneficiaryResponseMapper {}

void main() {
  late MockApiClient mockApiClient;
  late MockBeneficiaryResponseMapper mockBeneficiaryResponseMapper;
  late BeneficiaryRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockBeneficiaryResponseMapper = MockBeneficiaryResponseMapper();
    dataSource = BeneficiaryRemoteDataSource(
      apiClient: mockApiClient,
      beneficiaryResponseMapper: mockBeneficiaryResponseMapper,
    );
  });

  group('getBeneficiaries', () {
    const tUserData = UserData(
      balance: 1300,
      beneficiaries: [],
      availableBalance: 800,
    );

    test('should return UserData when the response code is 200', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: jsonDecode(GET_DUMMY_RESPONSE),
        ),
      );
      when(() => mockBeneficiaryResponseMapper.map(any()))
          .thenReturn(tUserData);

      final result = await dataSource.getBeneficiaries();

      verify(() => mockApiClient.get('/beneficiaries'));
      expect(result, equals(tUserData));
    });

    test(
        'should throw FetchBeneficiariesException when the response code is not 200',
        () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      expect(() => dataSource.getBeneficiaries(),
          throwsA(isA<FetchBeneficiariesException>()));
    });
  });

  group('addNewBeneficiary', () {
    const tUserData = UserData(
      balance: 1300,
      beneficiaries: [
        BeneficiaryModel(
          id: '1',
          nickname: 'nickname1',
          phoneNumber: '+201013615170',
          availableBalance: 1000,
        ),
      ],
      availableBalance: 800,
    );

    test('should return UserData when the response code is 200', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: jsonDecode(ADD_DUMMY_RESPONSE),
        ),
      );
      when(() => mockBeneficiaryResponseMapper.map(any()))
          .thenReturn(tUserData);

      final result = await dataSource.addNewBeneficiary(
        beneficiaryName: 'nickname1',
        phoneNumber: '+201013615170',
      );

      verify(() => mockApiClient.post('/beneficiaries/add', data: {
            "name": 'nickname1',
            "phone": '+201013615170',
          }));
      expect(result, equals(tUserData));
    });

    test(
        'should throw AddBeneficiaryException when the response code is not 200',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      expect(
        () => dataSource.addNewBeneficiary(
          beneficiaryName: 'nickname1',
          phoneNumber: '+201013615170',
        ),
        throwsA(isA<AddBeneficiaryException>()),
      );
    });
  });

  group('topUpBeneficiary', () {
    const tUserData = UserData(
      balance: 1300,
      beneficiaries: [
        BeneficiaryModel(
          id: '1',
          nickname: 'nickname1',
          phoneNumber: '+201013615170',
          availableBalance: 1000,
        ),
      ],
      availableBalance: 800,
    );

    test('should return UserData when the response code is 200', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: jsonDecode(ADD_DUMMY_RESPONSE),
        ),
      );
      when(() => mockBeneficiaryResponseMapper.map(any()))
          .thenReturn(tUserData);

      final result = await dataSource.topUpBeneficiary(
        beneficiary: tUserData.beneficiaries.first,
        amount: 100.0,
      );

      verify(() => mockApiClient.post('/beneficiaries/top_up', data: {
            "name": 'nickname1',
            "phone": '+201013615170',
            "amount": '100.0',
          }));
      expect(result, equals(tUserData));
    });

    test(
        'should throw TopUpBeneficiaryException when the response code is not 200',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      expect(
        () => dataSource.topUpBeneficiary(
          beneficiary: const BeneficiaryModel(
            id: '1',
            nickname: 'nickname1',
            phoneNumber: '+201013615170',
            availableBalance: 1000,
          ),
          amount: 100.0,
        ),
        throwsA(isA<TopUpBeneficiaryException>()),
      );
    });
  });
}
