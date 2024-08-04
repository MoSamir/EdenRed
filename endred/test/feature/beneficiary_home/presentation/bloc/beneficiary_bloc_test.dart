import 'package:bloc_test/bloc_test.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/add_beneficiary_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/get_beneficiaries_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/top_up_use_case.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_bloc.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_events.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBeneficiariesUseCase extends Mock
    implements GetBeneficiariesUseCase {}

class MockAddNewBeneficiaryUseCase extends Mock
    implements AddNewBeneficiaryUseCase {}

class MockTopUpUseBeneficiaryCase extends Mock
    implements TopUpUseBeneficiaryCase {}

void main() {
  late BeneficiaryBloc bloc;
  late MockGetBeneficiariesUseCase mockGetBeneficiariesUseCase;
  late MockAddNewBeneficiaryUseCase mockAddNewBeneficiaryUseCase;
  late MockTopUpUseBeneficiaryCase mockTopUpUseBeneficiaryCase;

  setUp(() {
    mockGetBeneficiariesUseCase = MockGetBeneficiariesUseCase();
    mockAddNewBeneficiaryUseCase = MockAddNewBeneficiaryUseCase();
    mockTopUpUseBeneficiaryCase = MockTopUpUseBeneficiaryCase();

    bloc = BeneficiaryBloc(
      getBeneficiariesUseCase: mockGetBeneficiariesUseCase,
      addNewBeneficiariesUseCase: mockAddNewBeneficiaryUseCase,
      topUpBeneficiaryUseCase: mockTopUpUseBeneficiaryCase,
    );
  });

  group('BeneficiaryBloc', () {
    test('initial state is BeneficiaryLoadingState', () {
      expect(bloc.state, equals(BeneficiaryLoadingState()));
    });

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoadingState, BeneficiaryLoadedState] when GetBeneficiariesUseCase succeeds',
      build: () {
        when(() => mockGetBeneficiariesUseCase.getBeneficiaries()).thenAnswer(
            (_) async => const UserData(
                beneficiaries: [],
                maxNumberOfBeneficiariesAllowed: 10,
                balance: 500,
                availableBalance: 100));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadBeneficiaries()),
      expect: () => [
        BeneficiaryLoadingState(),
        BeneficiaryLoadedState(
            beneficiaries: const UserData(
                beneficiaries: [],
                maxNumberOfBeneficiariesAllowed: 10,
                balance: 500,
                availableBalance: 100)),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoadingState, AddBeneficiaryErrorState] when AddNewBeneficiaryUseCase fails',
      build: () {
        when(
          () => mockAddNewBeneficiaryUseCase.addBeneficiary(
            name: 'John Doe',
            phoneNumber: '1234567890',
          ),
        ).thenThrow(Exception('Failed to add beneficiary'));
        return bloc;
      },
      act: (bloc) => bloc.add(AddBeneficiary(
          beneficiaryName: 'John Doe', phoneNumber: '1234567890')),
      expect: () => [
        BeneficiaryLoadingState(),
        AddBeneficiaryErrorState(
            message: 'Exception: Failed to add beneficiary'),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoadingState, BeneficiaryLoadedState] when AddNewBeneficiaryUseCase succeeds',
      build: () {
        when(
          () => mockAddNewBeneficiaryUseCase.addBeneficiary(
              name: 'John Doe', phoneNumber: '1234567890'),
        ).thenAnswer((_) async => const UserData(
                beneficiaries: [
                  BeneficiaryModel(
                      id: '1',
                      nickname: 'John Doe',
                      availableBalance: 500,
                      phoneNumber: '1234567890')
                ],
                maxNumberOfBeneficiariesAllowed: 10,
                balance: 500,
                availableBalance: 100));
        return bloc;
      },
      act: (bloc) => bloc.add(AddBeneficiary(
          beneficiaryName: 'John Doe', phoneNumber: '1234567890')),
      expect: () => [
        BeneficiaryLoadingState(),
        BeneficiaryLoadedState(
            beneficiaries: const UserData(
                beneficiaries: [
              BeneficiaryModel(
                  id: '1',
                  nickname: 'John Doe',
                  availableBalance: 500,
                  phoneNumber: '1234567890')
            ],
                maxNumberOfBeneficiariesAllowed: 10,
                balance: 500,
                availableBalance: 100)),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoadingState, TopUpCanBeProceeded] when TopUpBeneficiaryRequestEvent succeeds',
      build: () {
        bloc.beneficiaryData = const UserData(
            beneficiaries: [],
            maxNumberOfBeneficiariesAllowed: 10,
            balance: 500,
            availableBalance: 100);
        return bloc;
      },
      act: (bloc) => bloc.add(TopUpBeneficiaryRequestEvent(
          beneficiary: const BeneficiaryModel(
              id: '1',
              nickname: 'John Doe',
              availableBalance: 500,
              phoneNumber: '1234567890'))),
      expect: () => [
        TopUpCanBeProceeded(
            beneficiary: const BeneficiaryModel(
                id: '1',
                nickname: 'John Doe',
                availableBalance: 500,
                phoneNumber: '1234567890')),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoadingState, BeneficiaryErrorState] when TopUpBeneficiaryUseCase fails',
      build: () {
        when(
          () => mockTopUpUseBeneficiaryCase.topUp(
            beneficiary: const BeneficiaryModel(
                id: '1',
                nickname: 'John Doe',
                availableBalance: 500,
                phoneNumber: '1234567890'),
            amount: any(named: 'amount'),
          ),
        ).thenThrow(Exception('Failed to top up beneficiary'));
        return bloc;
      },
      act: (bloc) => bloc.add(TopUpBeneficiaryEvent(
          beneficiary: const BeneficiaryModel(
              id: '1',
              nickname: 'John Doe',
              availableBalance: 500,
              phoneNumber: '1234567890'),
          amount: 100)),
      expect: () => [
        BeneficiaryLoadingState(),
        BeneficiaryErrorState(
            message: 'Exception: Failed to top up beneficiary'),
      ],
    );

    group('BeneficiaryBloc Getters', () {
      test(
          'canAddMoreBeneficiaries returns true when the number of beneficiaries is less than the maximum allowed',
          () {
        bloc.beneficiaryData = const UserData(
          beneficiaries: [
            BeneficiaryModel(
                id: '1',
                nickname: 'John Doe',
                availableBalance: 500,
                phoneNumber: '1234567890')
          ],
          maxNumberOfBeneficiariesAllowed: 2,
          balance: 500,
          availableBalance: 100,
        );
        expect(bloc.canAddMoreBeneficiaries, isTrue);
      });

      test(
          'canAddMoreBeneficiaries returns false when the number of beneficiaries is equal to the maximum allowed',
          () {
        bloc.beneficiaryData = const UserData(
          beneficiaries: [
            BeneficiaryModel(
                id: '1',
                nickname: 'John Doe',
                availableBalance: 500,
                phoneNumber: '1234567890'),
            BeneficiaryModel(
                id: '2',
                nickname: 'Jane Doe',
                availableBalance: 500,
                phoneNumber: '0987654321')
          ],
          maxNumberOfBeneficiariesAllowed: 2,
          balance: 500,
          availableBalance: 100,
        );
        expect(bloc.canAddMoreBeneficiaries, isFalse);
      });

      test(
          'canAddMoreBeneficiaries returns false when the maximum number of beneficiaries allowed is null',
          () {
        bloc.beneficiaryData = const UserData(
          beneficiaries: [
            BeneficiaryModel(
                id: '1',
                nickname: 'John Doe',
                availableBalance: 500,
                phoneNumber: '1234567890')
          ],
          maxNumberOfBeneficiariesAllowed: null,
          balance: 500,
          availableBalance: 100,
        );
        expect(bloc.canAddMoreBeneficiaries, isFalse);
      });

      test(
          'maximumNumberOfBeneficiariesAllowed returns the correct value when it is set',
          () {
        bloc.beneficiaryData = const UserData(
          beneficiaries: [],
          maxNumberOfBeneficiariesAllowed: 5,
          balance: 500,
          availableBalance: 100,
        );
        expect(bloc.maximumNumberOfBeneficiariesAllowed, equals(5));
      });

      test('maximumNumberOfBeneficiariesAllowed returns 0 when it is null', () {
        bloc.beneficiaryData = const UserData(
          beneficiaries: [],
          maxNumberOfBeneficiariesAllowed: null,
          balance: 500,
          availableBalance: 100,
        );
        expect(bloc.maximumNumberOfBeneficiariesAllowed, equals(0));
      });
    });
  });
}
