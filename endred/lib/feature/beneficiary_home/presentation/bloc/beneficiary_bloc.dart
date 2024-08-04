import 'dart:async';

import 'package:endred/feature/beneficiary_home/domain/exceptions/base_exception.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/add_beneficiary_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/get_beneficiaries_use_case.dart';
import 'package:endred/feature/beneficiary_home/domain/usecase/top_up_use_case.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_events.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  GetBeneficiariesUseCase getBeneficiariesUseCase;
  AddNewBeneficiaryUseCase addNewBeneficiariesUseCase;
  TopUpUseBeneficiaryCase topUpBeneficiaryUseCase;
  late UserData beneficiaryData;

  BeneficiaryBloc({
    required this.getBeneficiariesUseCase,
    required this.addNewBeneficiariesUseCase,
    required this.topUpBeneficiaryUseCase,
  }) : super(BeneficiaryLoadingState()) {
    on<LoadBeneficiaries>(_handleBeneficiariesLoading);

    on<AddNewBeneficiaryRequestEvent>(_handleAddBeneficiaryRequestEvent);
    on<AddBeneficiary>(_handleAddNewBeneficiary);

    on<TopUpBeneficiaryRequestEvent>(_handleTopUpRequestEvent);
    on<TopUpBeneficiaryEvent>(_handleTopUpEvent);
  }

  get canAddMoreBeneficiaries =>
      beneficiaryData.beneficiaries.length <
      (beneficiaryData.maxNumberOfBeneficiariesAllowed ?? 0);

  get maximumNumberOfBeneficiariesAllowed =>
      (beneficiaryData.maxNumberOfBeneficiariesAllowed ?? 0);

  Future<void> _handleAddNewBeneficiary(
      AddBeneficiary event, Emitter<BeneficiaryState> emit) async {
    try {
      emit(BeneficiaryLoadingState());
      UserData? data = await addNewBeneficiariesUseCase.addBeneficiary(
        name: event.beneficiaryName,
        phoneNumber: event.phoneNumber,
      );

      print("BENEFICIARIES ==> $beneficiaryData");

      if (data != null) {
        beneficiaryData = data;
      }
      emit(BeneficiaryLoadedState(beneficiaries: beneficiaryData));
      return;
    } catch (e) {
      emit(AddBeneficiaryErrorState(message: e.toString()));
      emit(BeneficiaryLoadedState(beneficiaries: beneficiaryData));
      return;
    }
  }

  FutureOr<void> _handleBeneficiariesLoading(
      LoadBeneficiaries event, Emitter<BeneficiaryState> emit) async {
    emit(BeneficiaryLoadingState());
    try {
      UserData? beneficiariesResponse =
          await getBeneficiariesUseCase.getBeneficiaries();

      if (beneficiariesResponse != null) {
        beneficiaryData = beneficiariesResponse;
      }
      emit(BeneficiaryLoadedState(beneficiaries: beneficiaryData));
    } catch (exception) {
      if (exception is EdenRedBeneficiaryException) {
        emit(BeneficiaryErrorState(message: exception.toString()));
      } else {
        emit(BeneficiaryErrorState(message: exception.toString()));
      }
    }
  }

  Future<void> _handleAddBeneficiaryRequestEvent(
      AddNewBeneficiaryRequestEvent event,
      Emitter<BeneficiaryState> emit) async {
    emit(AddNewBeneficiaryShowDialogState());
  }

  Future<void> _handleTopUpRequestEvent(TopUpBeneficiaryRequestEvent event,
      Emitter<BeneficiaryState> emit) async {
    print("${event.beneficiary.availableBalance}");
    bool isUserHaveAllowedBalance = beneficiaryData.availableBalance > 0;
    bool isBeneficiaryHaveAllowedBalance =
        (event.beneficiary.availableBalance ?? 0) > 0 &&
            (event.beneficiary.availableBalance ?? 0) > 0;

    isUserHaveAllowedBalance && isBeneficiaryHaveAllowedBalance
        ? emit(
            TopUpCanBeProceeded(
              beneficiary: event.beneficiary,
            ),
          )
        : emit(
            TopUpMaxLimitsExceeded(),
          );

    emit(BeneficiaryLoadedState(beneficiaries: beneficiaryData));
  }

  Future<void> _handleTopUpEvent(
      TopUpBeneficiaryEvent event, Emitter<BeneficiaryState> emit) async {
    emit(BeneficiaryLoadingState());
    try {
      print(
          "Topping up => ${event.beneficiary.availableBalance} = ${event.amount + 1}");
      if ((event.beneficiary.availableBalance ?? 0) < (event.amount + 1)) {
        emit(
          TopUpMaxLimitsExceeded(),
        );
        return;
      }

      final topUpResponse = await topUpBeneficiaryUseCase.topUp(
          beneficiary: event.beneficiary,
          amount: double.parse(event.amount.toString()));
      if (topUpResponse != null) {
        beneficiaryData = topUpResponse;
        emit(BeneficiaryLoadedState(beneficiaries: beneficiaryData));
      }
    } catch (exception) {
      if (exception is EdenRedBeneficiaryException) {
        emit(BeneficiaryErrorState(message: exception.toString()));
      } else {
        emit(BeneficiaryErrorState(message: exception.toString()));
      }
    }
  }
}
