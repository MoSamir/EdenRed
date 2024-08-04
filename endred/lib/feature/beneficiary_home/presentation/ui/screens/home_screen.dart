import 'package:easy_localization/easy_localization.dart';
import 'package:endred/feature/beneficiary_home/domain/models/beneficiary.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_events.dart';
import 'package:endred/feature/beneficiary_home/presentation/bloc/beneficiary_states.dart';
import 'package:endred/feature/beneficiary_home/presentation/ui/widgets/empty_beneficiaries_list_widget.dart';
import 'package:endred/feature/beneficiary_home/presentation/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../bloc/beneficiary_bloc.dart';
import '../widgets/beneficiary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BeneficiaryBloc _bloc;
  int selectedAmount = 5;

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    _bloc.add(LoadBeneficiaries());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      body: BlocConsumer(
        bloc: _bloc,
        listenWhen: _listenWhen,
        buildWhen: _buildWhen,
        builder: (BuildContext context, BeneficiaryState state) {
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: const LoadingWidget(),
            inAsyncCall: state is BeneficiaryLoadingState,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Eden App'),
              ),
              body: _buildBody(state),
              floatingActionButton: (state is BeneficiaryLoadedState &&
                      state.beneficiaries.beneficiaries.isNotEmpty)
                  ? FloatingActionButton(
                      onPressed: () {
                        _bloc.canAddMoreBeneficiaries
                            ? _bloc.add(AddNewBeneficiaryRequestEvent())
                            : _showMaximumBeneficiariesReached();
                      },
                      child: const Icon(Icons.add),
                    )
                  : null,
            ),
          );
        },
        listener: (context, state) {
          if (state is BeneficiaryErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AddBeneficiaryErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AddNewBeneficiaryShowDialogState) {
            _showAddBeneficiaryDialog(context);
          } else if (state is TopUpMaxLimitsExceeded) {
            _showMaximumTopUpForBeneficiaryExceeded();
          } else if (state is TopUpCanBeProceeded) {
            _showTopUpDialog(beneficiary: state.beneficiary);
          }
        },
      ),
    );
  }

  Widget _buildBody(BeneficiaryState state) {
    if (state is BeneficiaryErrorState) {
      return Center(child: Text(state.message));
    } else if (state is BeneficiaryLoadedState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('home.balance_label').tr(namedArgs: {
                'balance': state.beneficiaries.availableBalance.toString()
              }),
            ),
            state.beneficiaries.beneficiaries.isNotEmpty
                ? Container(
                    height: 120,
                    color: Colors.white10,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: state.beneficiaries.beneficiaries.length,
                      itemBuilder: (context, index) {
                        return BeneficiaryCard(
                            onTopUpClick:
                                (BeneficiaryModel clickedBeneficiary) {
                              _bloc.add(TopUpBeneficiaryRequestEvent(
                                  beneficiary: clickedBeneficiary));
                            },
                            beneficiary:
                                state.beneficiaries.beneficiaries[index]);
                      },
                    ))
                : EmptyBeneficiaryWidget(
                    action: FloatingActionButton(
                      onPressed: () {
                        _bloc.canAddMoreBeneficiaries
                            ? _bloc.add(AddNewBeneficiaryRequestEvent())
                            : _showMaximumBeneficiariesReached();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _showAddBeneficiaryDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController beneficiaryNameController =
        TextEditingController();

    PhoneNumber number = PhoneNumber(isoCode: 'EG');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('home.dialog_add_beneficiary_title').tr(),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InternationalPhoneNumberInput(
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: phoneNumberController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onInputChanged: (PhoneNumber value) {},
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'home.dialog_add_beneficiary_name_error'.tr();
                        }
                        return null;
                      },
                      controller: beneficiaryNameController,
                      decoration: InputDecoration(
                          hintText:
                              'home.dialog_add_beneficiary_name_hint'.tr()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('home.dialog_add_beneficiary_cancel').tr()),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _bloc.add(AddBeneficiary(
                          phoneNumber: phoneNumberController.text,
                          beneficiaryName: beneficiaryNameController.text,
                        ));
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('home.dialog_add_beneficiary_add').tr()),
              ],
            ));
  }

  bool _listenWhen(BeneficiaryState previous, BeneficiaryState current) =>
      current is BeneficiaryErrorState ||
      current is AddBeneficiaryErrorState ||
      current is TopUpMaxLimitsExceeded ||
      current is TopUpBeneficiaryRequestEvent ||
      current is TopUpCanBeProceeded ||
      current is AddNewBeneficiaryShowDialogState;

  bool _buildWhen(BeneficiaryState previous, BeneficiaryState current) =>
      current is BeneficiaryLoadedState ||
      current is BeneficiaryErrorState ||
      current is TopUpMaxLimitsExceeded ||
      current is TopUpBeneficiaryRequestEvent;

  _showMaximumBeneficiariesReached() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('home.dialog_max_beneficiary_reached_title').tr(),
        content: Form(
          child: const Text('home.dialog_max_beneficiary_reached_content').tr(
            namedArgs: {
              'count': _bloc.maximumNumberOfBeneficiariesAllowed.toString()
            },
          ),
        ),
      ),
    );
  }

  void _showMaximumTopUpForBeneficiaryExceeded() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('home.dialog_max_limit_exceeded_title').tr(),
        content: Form(
          child: const Text('home.dialog_max_limit_exceeded_content').tr(),
        ),
      ),
    );
  }

  void _showTopUpDialog({required BeneficiaryModel beneficiary}) {
    final List<int> applicableAmounts = [5, 10, 20, 30, 50, 75, 100];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('home.dialog_add_beneficiary_title').tr(),
        content: DropdownButton<int>(
          value: selectedAmount,
          items: applicableAmounts
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text(
                    '$e AED',
                  ),
                ),
              )
              .toList(),
          onChanged: (int? value) {
            print("DROPPED $value");
            setState(() {
              selectedAmount = value!;
            });
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('home.dialog_add_beneficiary_cancel').tr()),
          TextButton(
              onPressed: () {
                _bloc.add(TopUpBeneficiaryEvent(
                    beneficiary: beneficiary, amount: selectedAmount));
                Navigator.of(context).pop();
              },
              child: const Text('home.dialog_add_beneficiary_add').tr()),
        ],
      ),
    );
  }
}
