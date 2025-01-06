import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCustomerDeatils extends StatefulWidget {
  const CreateCustomerDeatils({
    super.key,
  });

  @override
  State<CreateCustomerDeatils> createState() => _CreateCustomerDeatilsState();
}

class _CreateCustomerDeatilsState extends State<CreateCustomerDeatils> {
  bool _isSwitchOnForGromoreVegetables = true;
  bool _isSwitchedOnNewsPaperRead = false;
  bool _isSwitchedOnMilk = false;
  bool _fifteendaysFreeEenaduNewspaper = true;
  bool _employmentStatus = true;
  bool _isLoading = false;
  String? selectedJobType;
  String? selectedGovtJobType;
  final TextEditingController _vegetableController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _newspaperController = TextEditingController();
  final TextEditingController _reasonForNotReadingNewsPaper =
      TextEditingController();
  final TextEditingController _offerdeclinedController =
      TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _privateCompanyController =
      TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _houseNoController = TextEditingController();

  final _streetController = TextEditingController();

  final _cityController = TextEditingController();

  final _pincodeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setInitialTime();

    //set initial date to current state
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  void _setInitialTime() {
    final now = TimeOfDay.now();
    _timeController.text = now.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final applocalizations = AppLocalizations.of(context);
    if (applocalizations == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blueAccent,
        title: Text(
          applocalizations.customerform,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reusableFormField(
                    controller: _agencyNameController,
                    labelText: applocalizations.agencyname,
                    labelTextSize: 16,
                    keyboardType: TextInputType.text),
                const height(),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // onTap: () => _selectDate(context),

                        readOnly: true,
                        controller: _dateController,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Colors.black, // Border color when focused
                                width:
                                    2.0, // Increased border width when focused
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: applocalizations.date,
                            // errorText: _dateError ? 'Please select a date' : null,
                            labelStyle: const TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        // onTap: () => _selectDate(context),

                        readOnly: true,
                        controller: _timeController,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Colors.black, // Border color when focused
                                width:
                                    2.0, // Increased border width when focused
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: applocalizations.time,
                            // errorText: _dateError ? 'Please select a date' : null,
                            labelStyle: const TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
                const height(),
                Text(
                  applocalizations.familyDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableFormField(
                  controller: _nameController,
                  labelText: applocalizations.name,
                  labelTextSize: 16,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return applocalizations.pleaseEnterName;
                    }
                    return null;
                  },
                ),

                const height(),
                // reusableFormField(
                //     controller: _fatherNameController,
                //     labelText: applocalizations.fathersname,
                //     labelTextSize: 14,
                //     keyboardType: TextInputType.text),
                //const height(),
                reusableFormField(
                    controller: motherNameController,
                    labelText: applocalizations.mothername,
                    labelTextSize: 14,
                    keyboardType: TextInputType.text),
                const height(),
                // reusableFormField(
                //     controller: _spouseNameController,
                //     labelText: applocalizations.spousename,
                //     labelTextSize: 14,
                //     keyboardType: TextInputType.text),
                //const height(),
                Text(
                  applocalizations.addressDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: reusableFormField(
                          controller: _houseNoController,
                          labelText: applocalizations.houseNumber,
                          labelTextSize: 14,
                          keyboardType: TextInputType.text),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: reusableFormField(
                          controller: _streetController,
                          labelText: applocalizations.streetNo,
                          labelTextSize: 14,
                          keyboardType: TextInputType.text),
                    ),
                  ],
                ),
                const height(),
                Row(
                  children: [
                    Expanded(
                      child: reusableFormField(
                          controller: _cityController,
                          labelText: applocalizations.city,
                          labelTextSize: 14,
                          keyboardType: TextInputType.text),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: reusableFormField(
                          maxLength: 6,
                          controller: _pincodeController,
                          labelText: applocalizations.pinCode,
                          labelTextSize: 14,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const height(),
                reusableFormField(
                    controller: _addressController,
                    labelText: applocalizations.address,
                    labelTextSize: 14,
                    keyboardType: TextInputType.text),
                const height(),
                reusableFormField(
                    maxLength: 10,
                    controller: _mobileNumberController,
                    labelText: applocalizations.mobilenumber,
                    labelTextSize: 14,
                    keyboardType: TextInputType.number),
                // const height(),
                Text(
                  applocalizations.vegetablesDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      applocalizations.gromoreOraganicFreshVegetables,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _isSwitchOnForGromoreVegetables
                        ? Text(
                            applocalizations.yes,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            applocalizations.no,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _isSwitchOnForGromoreVegetables,
                      activeColor: Colors.green,
                      trackColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                         _isSwitchOnForGromoreVegetables = !_isSwitchOnForGromoreVegetables;
                        });
                      },
                    ),
                  ],
                ),
                const height(),
                _isSwitchOnForGromoreVegetables
                    ? 
                    reusableFormField(
                        controller: _feedbackController,
                        labelText: applocalizations.feedbacktoimprovepaper,
                        labelTextSize: 16,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return applocalizations.pleaseenterfeedback;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        lines: null,
                      )
                    :
                    //  Text("Others colum")
                    Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                applocalizations.takingVegetables,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _isSwitchedOnNewsPaperRead
                                  ? Text(
                                      applocalizations.yes,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      applocalizations.no,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              const Spacer(),
                              CupertinoSwitch(
                                value: _isSwitchedOnNewsPaperRead,
                                activeColor: Colors.green,
                                trackColor: Colors.red,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isSwitchedOnNewsPaperRead =
                                        !_isSwitchedOnNewsPaperRead;
                                  });
                                },
                              ),
                            ],
                          ),
                          const height(),
                          _isSwitchedOnNewsPaperRead
                              ? Column(
                                  children: [
                                    reusableFormField(
                                      controller: _vegetableController,
                                      labelText:
                                          applocalizations.currentnVegetables,
                                      labelTextSize: 16,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please provide current Newspaper name';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      lines: null,
                                      onTap: () {
                                        _showNewspaperDropdown(context);
                                      },
                                    ),
                                    const height(),
                                    // height(),
                                    reusableFormField(
                                      controller: _reasonController,
                                      labelText: applocalizations
                                          .reasonForNotTakingGromoreVegetables,
                                      labelTextSize: 16,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please provide reason';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      lines: null,
                                    ),
                                  ],
                                )
                              : reusableFormField(
                                  controller: _reasonForNotReadingNewsPaper,
                                  labelText: applocalizations
                                      .reasonfornotreadingnewspaper,
                                  labelTextSize: 16,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please provide reason';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  lines: null,
                                ),
                        ],
                      ),
               _isSwitchOnForGromoreVegetables ? const height() : const SizedBox(),
                height(),

                // Thise is  New for milk Customer
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          applocalizations.currentnMilk,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _isSwitchedOnMilk
                            ? Text(
                                applocalizations.yes,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                applocalizations.no,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: _isSwitchedOnMilk,
                          activeColor: Colors.green,
                          trackColor: Colors.red,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitchedOnMilk =
                                  !_isSwitchedOnMilk;
                            });
                          },
                        ),
                      ],
                    ),
                    const height(),
                    _isSwitchedOnMilk
                        ? Column(
                            children: [
                              reusableFormField(
                                controller: _milkController,
                                labelText: applocalizations.currentnMilk,
                                labelTextSize: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please provide current Milk name';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                lines: null,
                                onTap: () {
                                  _showMilkDropdown(context);
                                },
                              ),
                              const height(),
                              // height(),
                              reusableFormField(
                                controller: _reasonController,
                                labelText: applocalizations
                                    .reasonForNotTakingGromoreMilk,
                                labelTextSize: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please provide reason';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                lines: null,
                              ),
                            ],
                          )
                        : reusableFormField(
                            controller: _reasonForNotReadingNewsPaper,
                            labelText:
                                applocalizations.reasonForNotTakingGromoreMilk,
                            labelTextSize: 16,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide reason';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            lines: null,
                          ),
                  ],
                ),
                       _isSwitchOnForGromoreVegetables ? const height() : const SizedBox(),

                // !_isSwitchOnForEenadu
                //     ? Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text(
                //                 applocalizations.daysforeenaduoffer,
                //                 style: const TextStyle(
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               _fifteendaysFreeEenaduNewspaper
                //                   ? Text(
                //                       applocalizations.yes,
                //                       style: const TextStyle(
                //                         fontSize: 18,
                //                         color: Colors.green,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     )
                //                   : Text(
                //                       applocalizations.no,
                //                       style: const TextStyle(
                //                         fontSize: 18,
                //                         color: Colors.red,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //               const Spacer(),
                //               CupertinoSwitch(
                //                 value: _fifteendaysFreeEenaduNewspaper,
                //                 activeColor: Colors.green,
                //                 trackColor: Colors.red,
                //                 onChanged: (bool value) {
                //                   setState(() {
                //                     _fifteendaysFreeEenaduNewspaper =
                //                         !_fifteendaysFreeEenaduNewspaper;
                //                   });
                //                 },
                //               ),
                //             ],
                //           ),
                //           _isSwitchOnForEenadu
                //               ? const SizedBox()
                //               : const height(),
                //           !_fifteendaysFreeEenaduNewspaper
                //               ? reusableFormField(
                //                   controller: _offerdeclinedController,
                //                   labelText:
                //                       applocalizations.reasonfornottakingoffer,
                //                   labelTextSize: 16,
                //                   keyboardType: TextInputType.text)
                //               : const SizedBox()
                //         ],
                //       )
                //     : const SizedBox(),
                // _fifteendaysFreeEenaduNewspaper
                //     ? const SizedBox()
                //     : const height(),
                const height(),
                Text(
                  applocalizations.employmentDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      applocalizations.employed,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _employmentStatus
                        ? Text(
                            applocalizations.yes,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            applocalizations.no,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _employmentStatus,
                      activeColor: Colors.green,
                      trackColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          _employmentStatus = !_employmentStatus;
                        });
                      },
                    ),
                  ],
                ),
                const height(),
                _employmentStatus
                    ? DropdownButtonFormField<String>(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.all(25),
                          labelText: applocalizations.jobtype,
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Colors.red),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        value: selectedJobType,
                        items: [
                          DropdownMenuItem(
                            value: 'Govt',
                            child: Text(
                              applocalizations.governmentjob,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Private',
                            child: Text(
                              applocalizations.privatejob,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedJobType = newValue!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a Job type' : null,
                      )
                    : reusableFormField(
                        controller: _professionController,
                        labelText: applocalizations.profession,
                        labelTextSize: 14,
                        keyboardType: TextInputType.text),
                _employmentStatus ? const height() : const SizedBox(),
                (selectedJobType == "Govt" && _employmentStatus)
                    ? Column(
                        children: [
                          DropdownButtonFormField<String>(
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              // contentPadding: EdgeInsets.all(25),
                              labelText: applocalizations.jobtype,
                              labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                              ),
                            ),
                            value: selectedGovtJobType,
                            items: [
                              DropdownMenuItem(
                                value: 'Central',
                                child: Text(
                                  applocalizations.centraljob,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              const DropdownMenuItem(
                                value: 'PSU',
                                child: Text(
                                  'PSU',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'State',
                                child: Text(
                                  applocalizations.statejob,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGovtJobType = newValue!;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a Job type'
                                : null,
                          ),
                          const height(),
                          (selectedGovtJobType == "Central" ||
                                  selectedGovtJobType == "PSU" ||
                                  selectedGovtJobType == "State")
                              ? Column(
                                  children: [
                                    reusableFormField(
                                        controller: _professionController,
                                        labelText:
                                            applocalizations.jobprofession,
                                        labelTextSize: 14,
                                        keyboardType: TextInputType.text),
                                    const height(),
                                    reusableFormField(
                                        controller: _designationController,
                                        labelText:
                                            applocalizations.jobdesignation,
                                        labelTextSize: 14,
                                        keyboardType: TextInputType.text),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      )
                    : (selectedJobType == "Private" && _employmentStatus)
                        ? Column(
                            children: [
                              reusableFormField(
                                  controller: _privateCompanyController,
                                  labelText: applocalizations.companyname,
                                  labelTextSize: 14,
                                  keyboardType: TextInputType.text),
                              const height(),
                              reusableFormField(
                                  controller: _professionController,
                                  labelText: applocalizations.profession,
                                  labelTextSize: 14,
                                  keyboardType: TextInputType.text),
                              const height(),
                              reusableFormField(
                                  controller: _designationController,
                                  labelText: applocalizations.jobdesignation,
                                  labelTextSize: 14,
                                  keyboardType: TextInputType.text)
                            ],
                          )
                        : const SizedBox(),
                const height(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 80,
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              setState(() {
                _isLoading = true;
              });

              if (_formKey.currentState?.validate() ?? false) {
                await _getCurrentLocation();
                await Future.delayed(const Duration(milliseconds: 1000));

                await _saveDetails(); // Save details to SharedPreferences
                // Navigator.pop(context); // Pop the page and go back
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          radius: 20,
                          color: Colors.white,
                        )
                      : Text(
                          applocalizations.submit,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
            ),
          )),
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );

  //   setState(() {
  //     _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
  //   });
  // }

// Function to show the dropdown
  // void _showNewspaperDropdown(BuildContext context) {
  //   final List<String> newspapers = [
  //     'आठवडी बाजार',
  //     'दारावर',
  //   ];

  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoActionSheet(
  //         title: const Text(
  //           'Select Current Vegetables',
  //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  //         ),
  //         // message: const Text('Choose one of the newspapers below.'),
  //         actions: newspapers.map((newspaper) {
  //           return CupertinoActionSheetAction(
  //             child: Text(newspaper),
  //             onPressed: () {
  //               _newspaperController.text = newspaper;
  //               Navigator.pop(context);
  //             },
  //           );
  //         }).toList(),
  //         cancelButton: CupertinoActionSheetAction(
  //           isDefaultAction: true,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Cancel'),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showNewspaperDropdown(BuildContext context) {
  final List<String> newspapers = [
    'आठवडी बाजार',
    'दारावर',
  ];

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: const Text(
          'Select Current Vegetables',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: newspapers.map((newspaper) {
          return CupertinoActionSheetAction(
            child: Text(newspaper),
            onPressed: () {
              _vegetableController.text = newspaper;
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      );
    },
  );
}


// This is Milk Drop
//  void _showMilkDropdown(BuildContext context) {
//     final List<String> newspapers = [
//       'दुसऱ्याकडून',
//       'दूध पॅकेट',
//     ];

//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoActionSheet(
//           title: const Text(
//             'Select Current Vegetables',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           // message: const Text('Choose one of the newspapers below.'),
//           actions: newspapers.map((newspaper) {
//             return CupertinoActionSheetAction(
//               child: Text(newspaper),
//               onPressed: () {
//                 _newspaperController.text = newspaper;
//                 Navigator.pop(context);
//               },
//             );
//           }).toList(),
//           cancelButton: CupertinoActionSheetAction(
//             isDefaultAction: true,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//         );
//       },
//     );
//   }
void _showMilkDropdown(BuildContext context) {
  final List<String> options = [
    'दुसऱ्याकडून',
    'दूध पॅकेट',
  ];

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: const Text(
          'Select Current Milk Source',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: options.map((option) {
          return CupertinoActionSheetAction(
            child: Text(option),
            onPressed: () {
              _milkController.text = option;
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      );
    },
  );
}

//   // REUSEABLE TEXT FORM FEILD
  Widget reusableFormField({
    required TextEditingController controller,
    required String? labelText,
    required double? labelTextSize,
    String? Function(String?)? validator,
    required TextInputType keyboardType,
    int? maxLength,
    int? lines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: lines,
      controller: controller,
      // inputFormatters: [UpperCaseTextInputFormatter()],
      style: TextStyle(
        fontSize: labelTextSize,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        // contentPadding: const EdgeInsets.all(20),
        labelText: labelText,
        labelStyle: const TextStyle(
            fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      readOnly: onTap != null,
      onTap: onTap,
    );
  }

  // Save details to SharedPreferences
  // Function to save data into SharedPreferences
  Future<void> _saveDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get existing lists from SharedPreferences, if any
    List<String> names = prefs.getStringList('names') ?? [];
    List<String> mobiles = prefs.getStringList('mobiles') ?? [];

    // Add the new name and mobile number
    names.add(_nameController.text);
    mobiles.add(_mobileNumberController.text);

    // Save updated lists back to SharedPreferences
    await prefs.setStringList('names', names);
    await prefs.setStringList('mobiles', mobiles);
    // Save latitude and longitude
    double? latitude = _latitude; // Replace with the actual latitude value
    double? longitude = _longitude; // Replace with the actual longitude value

    await prefs.setDouble('latitude', latitude!);
    await prefs.setDouble('longitude', longitude!);

    Navigator.pop(context);
  }

  double? _latitude;
  double? _longitude;
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue accessing the position
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }
}

class height extends StatelessWidget {
  const height({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}
