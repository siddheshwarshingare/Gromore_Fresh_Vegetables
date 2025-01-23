import 'package:cloud_firestore/cloud_firestore.dart';
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
  //instance...
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //form key declare
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //fields declare...
  bool _intestedToTakeGromoreVegetables = true;
  bool _isSwitchedOnGromoreVegetables = false;
  bool _isSwitchedOnMilk = false;
  bool _employmentStatus = true;
  bool _isLoading = false;
  String? selectedJobType;
  String? selectedGovtJobType;
  String currentusername = '';

  //controllers...

  final TextEditingController _vegetableController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vegetablesReasonController =
      TextEditingController();
  final TextEditingController _milkReasonController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _privateCompanyController =
      TextEditingController();
  final TextEditingController govermentJobController = TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _streetController = TextEditingController();

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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 222),
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 70,
        backgroundColor: Colors.orange.shade300,
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2),
                  ),
                  child: Text(
                    "$currentusername Agency",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const height(),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 240, 236, 222),
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
                        readOnly: true,
                        controller: _timeController,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 240, 236, 222),
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
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: applocalizations.time,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableFormField(
                  controller: _nameController,
                  labelText: applocalizations.familyHeadName,
                  labelTextSize: 16,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return applocalizations.pleaseEnterFamilyName;
                    }
                    return null;
                  },
                ),

                const height(),

                Text(
                  applocalizations.addressDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 17),
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return applocalizations.pleaseEnterHouseNumber;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: reusableFormField(
                        controller: _streetController,
                        labelText: applocalizations.streetNo,
                        labelTextSize: 14,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return applocalizations.pleaseEnterStreetNumber;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const height(),

                reusableFormField(
                  controller: _addressController,
                  labelText: applocalizations.address,
                  labelTextSize: 14,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return applocalizations.pleaseEnterAddress;
                    }
                    return null;
                  },
                ),
                const height(),
                reusableFormField(
                  maxLength: 10,
                  controller: _mobileNumberController,
                  labelText: applocalizations.mobilenumber,
                  labelTextSize: 14,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return applocalizations.pleaseEnterMobileNumber;
                    }
                    return null;
                  },
                ),
                const height(),
                Text(
                  applocalizations.vegetablesDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 18),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _intestedToTakeGromoreVegetables
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
                      value: _intestedToTakeGromoreVegetables,
                      activeColor: Colors.green,
                      trackColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          _intestedToTakeGromoreVegetables =
                              !_intestedToTakeGromoreVegetables;
                        });
                      },
                    ),
                  ],
                ),
                const height(),
                !_intestedToTakeGromoreVegetables
                    ? reusableFormField(
                        controller: _vegetablesReasonController,
                        labelText: applocalizations
                            .reasonForNotTakingGromoreVegetables,
                        labelTextSize: 16,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return applocalizations
                                .reasonForNotTakingGromoreVegetables;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        lines: null,
                      )
                    : SizedBox(),

                !_intestedToTakeGromoreVegetables
                    ? Column(
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
                              _isSwitchedOnGromoreVegetables
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
                                value: _isSwitchedOnGromoreVegetables,
                                activeColor: Colors.green,
                                trackColor: Colors.red,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isSwitchedOnGromoreVegetables =
                                        !_isSwitchedOnGromoreVegetables;
                                  });
                                },
                              ),
                            ],
                          ),
                          const height(),
                          _isSwitchedOnGromoreVegetables
                              ? Column(
                                  children: [
                                    reusableFormField(
                                      controller: _vegetableController,
                                      labelText:
                                          applocalizations.currentnVegetables,
                                      labelTextSize: 16,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return applocalizations
                                              .currentnVegetables;
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      lines: null,
                                      onTap: () {
                                        _showCurrentVegetableDropdown(context);
                                      },
                                    ),
                                    const height(),
                                  ],
                                )
                              : reusableFormField(
                                  controller: _milkReasonController,
                                  labelText: applocalizations
                                      .reasonfornotreadingnewspaper,
                                  labelTextSize: 16,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return applocalizations
                                          .pleaseEnterTheReasonForNotTakingGromoreVegetables;
                                      ;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  lines: null,
                                ),
                        ],
                      )
                    : SizedBox(),

                // Thise is  New for milk Customer
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          applocalizations.currentnMilk,
                          style: const TextStyle(
                            fontSize: 16,
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
                              _isSwitchedOnMilk = !_isSwitchedOnMilk;
                            });
                          },
                        ),
                      ],
                    ),
                    !_isSwitchedOnMilk ? const height() : SizedBox(),
                    !_isSwitchedOnMilk
                        ? Column(
                            children: [
                              reusableFormField(
                                controller: _milkController,
                                labelText: applocalizations.currentnMilk,
                                labelTextSize: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return applocalizations.currentTakingMilk;
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                lines: null,
                                onTap: () {
                                  _showMilkDropdown(context);
                                },
                              ),
                              height(),
                              reusableFormField(
                                controller: _milkReasonController,
                                labelText: applocalizations
                                    .reasonForNotTakingGromoreMilk,
                                labelTextSize: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return applocalizations
                                        .pleaseEnterTheReasonForNotTakingGromoreMilk;
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                lines: null,
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),

                const height(),
                Text(
                  applocalizations.employmentDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20),
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
                        borderRadius: BorderRadius.circular(14),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: applocalizations.jobtype,
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                          fillColor: const Color.fromARGB(255, 240, 236, 222),
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
        color: const Color.fromARGB(255, 240, 236, 222),
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
              storeDataToFirebase();
              await _saveDetails();
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade300,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const CupertinoActivityIndicator(
                      radius: 70,
                    )
                  : Text(
                      applocalizations.submit,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCurrentVegetableDropdown(BuildContext context) {
    final List<String> vegetable = [
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
          actions: vegetable.map((vegetable) {
            return CupertinoActionSheetAction(
              child: Text(vegetable),
              onPressed: () {
                _vegetableController.text = vegetable;
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
      style: TextStyle(
        fontSize: labelTextSize,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: const Color.fromARGB(255, 240, 236, 222),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.pink.shade100),
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

  Future<void> storeDataToFirebase() async {
    String name = currentusername.toString();
    String headname = _nameController.text;
    String fathersName = _fatherNameController.text;
    String vegetablesReason = _vegetablesReasonController.text;
    String milkReason = _milkReasonController.text;

    String jobType = selectedJobType.toString();
    String govtJobtype = selectedGovtJobType.toString();
    String designaton = _designationController.text;
    String privateCompany = _privateCompanyController.text;
    String mothersName = motherNameController.text;
    String address = _addressController.text;
    String mobileNumber = _mobileNumberController.text;
    String date = _dateController.text;
    String time = _timeController.text;
    String houseNo = _houseNoController.text;
    String street = _streetController.text;
    bool intrestedToTakeGromoreVegetables = _intestedToTakeGromoreVegetables;
    bool intrestedToTakeOutMilk = _isSwitchedOnMilk;
    bool employmentType = _employmentStatus;
    String employmentTypeProfession = _professionController.text;
    String privatejobprofssion = _privateCompanyController.text;
    double? lattitude = _latitude;
    double? longitude = _longitude;

    try {
      print("Name   ====== >$name");
      await firestore.collection('UserData').add({
        'name': headname,
        "fathersName": fathersName,

        "jobType": jobType,
        "govtJobType": govtJobtype,
        "employmentTypeProffession": employmentTypeProfession,
        "privateJobProfession": privatejobprofssion,
        //"govtJobProfession": govtJobProffession,
        "designaton": designaton,
        "privateCompany": privateCompany,
        "mothersName": mothersName,
        "address": address,
        "mobileNumber": mobileNumber,
        "date": date,
        "time": time,
        "agencyName": name,
        "houseNo": houseNo,
        "street": street,
        "intrestedToTakeOurVegetables": intrestedToTakeGromoreVegetables,
        "resonForNotTakingOurVegetables": vegetablesReason,
        "intrestedToTakeOurMilk": intrestedToTakeOutMilk,
        "reasonForNotTakingOutMilk": milkReason,
        "employmentType": employmentType,
        "latitude": lattitude,
        "longitude": longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add data: $e')),
      );
    }
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
    double? latitude = _latitude;
    double? longitude = _longitude;

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
