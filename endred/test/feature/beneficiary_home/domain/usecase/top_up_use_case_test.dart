import 'package:endred/feature/beneficiary_home/data/repository/beneficiary_repository.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/top_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock
class MockBeneficiaryRepository extends Mock implements BeneficiaryRepository {}

void main() {
  late TopUpUseBeneficiaryCaseImpl useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = TopUpUseBeneficiaryCaseImpl(
      beneficiaryRepository: mockRepository,
    );
  });

  const beneficiary = BeneficiaryModel(
    id: '1',
    nickname: 'nickname1',
    phoneNumber: '+201013615170',
    availableBalance: 1000,
  );

  const userData = UserData(
    balance: 1300,
    beneficiaries: [
      BeneficiaryModel(
        id: '1',
        nickname: 'nickname1',
        phoneNumber: '+201013615170',
        availableBalance: 2000,
      ),
    ],
    availableBalance: 800,
  );

  group('TopUpUseBeneficiaryCaseImpl', () {
    test('should call topUpBeneficiary on repository and return the result',
        () async {
      // Arrange
      when(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).thenAnswer((_) async => userData);

      // Act
      final result = await useCase.topUp(
        beneficiary: beneficiary,
        amount: 500,
      );

      // Assert
      expect(result, equals(userData));
      verify(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).called(1);
    });

    test('should handle null response from repository', () async {
      // Arrange
      when(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).thenAnswer((_) async => null);

      // Act
      final result = await useCase.topUp(
        beneficiary: beneficiary,
        amount: 500,
      );

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).called(1);
    });

    test('should handle exception thrown by repository', () async {
      // Arrange
      when(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).thenThrow(Exception('Failed to top up beneficiary'));

      // Act & Assert
      expect(
          () async => await useCase.topUp(
                beneficiary: beneficiary,
                amount: 500,
              ),
          throwsA(isA<Exception>()));
      verify(() => mockRepository.topUpBeneficiary(
            beneficiary: beneficiary,
            amount: 500,
          )).called(1);
    });
  });
}
