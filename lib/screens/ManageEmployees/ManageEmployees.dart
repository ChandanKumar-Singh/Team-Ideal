import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dakshattendance/Model/ProfileModel.dart';
import 'package:dakshattendance/const/global.dart';
import 'package:dakshattendance/provider/EmployeeInfoProvider/EmployeeInfoProvider.dart';
import 'package:dakshattendance/screens/homepage.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ManageEmployees extends StatefulWidget {
  const ManageEmployees({Key? key}) : super(key: key);

  @override
  State<ManageEmployees> createState() => _ManageEmployeesState();
}

class _ManageEmployeesState extends State<ManageEmployees> {
  int activeStep = 0;
  TextEditingController fncontroller = TextEditingController();

  ///ScrollControllers
  // ScrollController step1ScrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var ep = Provider.of<EmployeeInfoProvider>(context, listen: false);
    ep.getProfileData();
    ep.getStates();
    ep.getPrincipalCompanies();
    ep.getWorkingFor();
  }

  ///Form Keys
  final GlobalKey<FormState> step1FormKey = GlobalKey();
  final GlobalKey<FormState> step2FormKey = GlobalKey();
  final GlobalKey<FormState> step3FormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willExit = false;

        return AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            autoHide: Duration(seconds: 3),
            title: '\n\n  Form Saved? \n',
            autoDismiss: true,
            btnCancelText: 'No',
            btnOkText: 'Yes',
            btnCancelOnPress: () {
              willExit = false;
            },
            btnOkOnPress: () {
              var ep =
                  Provider.of<EmployeeInfoProvider>(context, listen: false);
              ep.educations.clear();
              ep.fieldControl2.clear();
              ep.fieldControl6.clear();
              ep.form1controllers.clear();
              ep.form1controllers.clear();
              ep.field2controllers.clear();
              ep.emergencies.clear();
              ep.employees.clear();
              willExit = true;
            }).show().then((value) => willExit);
        debugPrint('willExit $willExit');
      },
      child: Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                EasyStepper(
                  activeStep: activeStep,
                  lineLength: 100,
                  lineDotRadius: 3,
                  lineSpace: 5,
                  lineType: LineType.normal,
                  lineColor: AppColor.appColor2.withOpacity(0.7),
                  borderThickness: 5,
                  padding: 15,
                  loadingAnimation: 'assets/loading_cicle.json',
                  steps: const [
                    EasyStep(
                      icon: Icon(CupertinoIcons.person),
                      title: 'Employee Profile',
                      lineText: 'Add Education',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.drop),
                      title: 'Dependencies',
                      lineText: 'Multi Forms',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.book),
                      title: 'Education',
                      lineText: 'Employment Info',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.info),
                      title: 'Employment Details',
                      lineText: 'Add Reference',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.money_dollar_circle),
                      title: 'References',
                      lineText: 'Add Documents',
                    ),
                    EasyStep(
                      icon: Icon(Icons.file_present_rounded),
                      title: 'Document Uploads',
                    ),
                  ],
                  onStepReached: (index) => setState(() => activeStep = index),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ep.loadingProfileData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: activeStep == 0
                              ? step1FieldControl(ep)
                              : activeStep == 1
                                  ? step2FieldControl(ep)
                                  : activeStep == 2
                                      ? EducationCard()
                                      : activeStep == 3
                                          ? PreviousJobCard()
                                          : activeStep == 4
                                              ? ReferencesForm()
                                              : activeStep == 5
                                                  ? step6FieldControl(ep)
                                                  : SizedBox(),
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: floatingButtons(ep),
        );
      }),
    );
  }

  Padding floatingButtons(EmployeeInfoProvider ep) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: activeStep != 0
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (activeStep != 0)
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  activeStep--;
                });
              },
              label: Text('Back'),
            ),
          FloatingActionButton.extended(
            onPressed: () async {
              if (activeStep == 0) {
                bool? validate = step1FormKey.currentState?.validate();
                if (validate != null && validate) {
                  setState(() {
                    activeStep++;
                  });
                }
              } else if (activeStep == 1) {
                bool? validate = step2FormKey.currentState?.validate();
                print('$activeStep validate $validate');
                if (ep.approved) {
                  await ep.uploadField1andForm2Docs();
                }
                setState(() {
                  activeStep++;
                });
                // }
              } else if (activeStep == 2) {
                // bool? validate = step2FormKey.currentState?.validate();
                // print('$activeStep validate $validate');
                // if (validate != null && validate) {
                if (ep.approved) {
                  await ep.uploadField3();
                }
                setState(() {
                  activeStep++;
                });
                // }
              } else if (activeStep == 3) {
                // bool? validate = step2FormKey.currentState?.validate();
                // print('$activeStep validate $validate');
                // if (validate != null && validate) {
                if (ep.approved) {
                  await ep.uploadField4();
                }
                setState(() {
                  activeStep++;
                });
                // }
              } else if (activeStep == 4) {
                // bool? validate = step2FormKey.currentState?.validate();
                // print('$activeStep validate $validate');
                // if (validate != null && validate) {
                if (ep.approved) {
                  await ep.uploadField5();
                }
                setState(() {
                  activeStep++;
                });
                // }
              } else if (activeStep == 5) {
                // bool? validate = step2FormKey.currentState?.validate();
                if (ep.approved) {
                  await ep.uploadField6Docs();
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomepage()));
                }
              } else {
                setState(() {
                  activeStep < 6 ? activeStep++ : null;
                });
              }
            },
            label: Text(activeStep != 5
                ? 'Next'
                : ep.approved
                    ? '📤 Update'
                    : 'Go Back'),
          ),
        ],
      ),
    );
  }

  Widget step1FieldControl(EmployeeInfoProvider ep) {
    if (ep.loadingProfileData) {
      return Center(child: CircularProgressIndicator());
    } else {
      var emp = ep.profileData!.employee!;
      return FieldControl(
        formKey: step1FormKey,
        fieldControl: [
          ['First Name', emp.firstNm ?? '', false, true, 'first_nm', ''],
          ['Middle Name', emp.middleNm ?? '', false, false, 'middle_nm', ''],
          ['Last Name', emp.lastNm ?? '', false, false, 'last_nm', ''],
          ['Employee Code', emp.empCode ?? '', true, false, 'emp_code', ''],
          ['Password', emp.password ?? '', true, false, 'fdfhdsds', ''],
          ['Email Id', emp.email ?? '', false, false, 'email', ''],
          [
            'Official Email Id',
            emp.officialemail ?? '',
            false,
            false,
            'officialemail',
            ''
          ],
          [
            'Alternate Email Id',
            emp.altemail ?? '',
            false,
            false,
            'altemail',
            ''
          ],
          ['Official Mobile No.', '', false, false, 'off_mob_no', ''],
          [
            'Alternate Mobile No.',
            emp.altmobileno ?? '',
            false,
            false,
            'altmobileno',
            ''
          ],
          [
            'Current Address',
            emp.curaddress ?? '',
            false,
            false,
            'curaddress',
            ''
          ],
          ['Grade', emp.grade ?? '', false, false, 'grade', ''],
          ['PF No', emp.panNo ?? '', false, false, 'pfno', ''],
          ['ESIC No', emp.esicNo ?? '', false, false, 'esic_no', ''],
          ['Education', emp.education ?? '', false, false, 'education', ''],
          ['DOB', emp.dob, false, false, 'dob', ''],
          ['Age', emp.age ?? '', false, false, 'age', ''],
          ['Contract End Date', emp.cenddt ?? '', true, false, 'cenddt', ''],
          // ['State', emp.state ?? '', false, false,'erefefced,'],
          [
            'Designation',
            emp.designation ?? '',
            true,
            false,
            'designation',
            ''
          ],
          ['Joining Date', emp.joindt, true, false, 'joindt', 'date'],
          ['Resignation Date', emp.resigndt, false, false, 'resigndt', ''],
          ['Leave Date', emp.leavedt, false, false, 'leavedt', ''],
          ['Location', emp.location ?? '', false, false, 'location', ''],
          ['Bank Name', emp.banknm ?? '', false, false, 'banknm', ''],
          ['Account No', emp.accno ?? '', false, false, 'accno', ''],
          ['Bank City', emp.bankcity ?? '', false, false, 'bankcity', ''],
          ['Branch', emp.branch ?? '', false, false, 'branch', ''],
          ['IFSC Code', emp.ifsc ?? '', false, false, 'ifsc', ''],
          ['Aadhar Card No', emp.aadharno ?? '', false, false, 'aadharno', ''],
          ['Remarks', emp.remarks ?? '', false, false, 'remarks', ''],
          ['Supervisor', emp.supervisor ?? '', false, false, 'supervisor', ''],
          ['UAN No', 'uan_no', false, false, 'uan_no', ''],
          ['PAN NO', emp.panNo ?? '', false, false, 'pan_no', ''],
          [
            'Reporting HR Name',
            emp.rephrName ?? '',
            false,
            false,
            'rephr_name',
            ''
          ],
          ['NUMBER', emp.mobileno, false, false, 'mobileno', ''],
          ['Nominee Name', emp.nomiName ?? '', false, false, 'nomi_name', ''],
          ['Nominee Mobile No', emp.nomiNo ?? '', false, false, 'nomi_no', ''],
          [
            'Nominee Relationship',
            emp.nomiRel ?? '',
            false,
            false,
            'nomi_rel',
            ''
          ],
          [
            'Nominee Date of proof',
            emp.nomineedt,
            false,
            false,
            'nomineedt',
            ''
          ],
          ['Nominee Address', emp.nomiAdd ?? '', false, false, 'nomi_add', ''],
        ],
      );
    }
  }

  FieldControl2 step2FieldControl(EmployeeInfoProvider ep) {
    return FieldControl2(
      formKey: step2FormKey,
      fieldControl: [
        [
          'State',
          ep.profileData!.employee!.state != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.state ?? "",
                  value: ep.profileData!.employee!.state ?? '')
              : null,
          false,
          true,
          ep.states,
        ],
        [
          'Principle Company',
          ep.profileData!.employee!.principalComp != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.principalComp ?? "",
                  value: ep.profileData!.employee!.principalComp ?? '')
              : null,
          false,
          true,
          ep.principalCompanies,
        ],
        [
          'Company Waiting For',
          ep.profileData!.employee!.workingFor != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.workingFor ?? "",
                  value: ep.profileData!.employee!.workingFor ?? '')
              : null,
          false,
          false,
          ep.workingForCompanies,
        ],
        [
          'Zone',
          ep.profileData!.employee!.zone != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.zone ?? "",
                  value: ep.profileData!.employee!.zone ?? '')
              : null,
          false,
          false,
          ep.workingForCompanies,
        ],
        [
          'Account Status',
          ep.profileData!.employee!.accountStatus != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.accountStatus ?? "",
                  value: ep.profileData!.employee!.accountStatus ?? '')
              : null,
          false,
          false,
          ['Active', 'Deactive'],
        ],
      ],
    );
  }

  Widget step6FieldControl(EmployeeInfoProvider ep) {
    return FieldControl6(
      formKey: step3FormKey,
      docs: ep.profileData!.documents!,
    );
  }

  // Widget step2Form() {
  //   return CustomDropDownField(
  //     title: 'Select Principle Company',
  //     options: [],
  //     onChange: (val) {},
  //     label: 'Select',
  //     required: true,
  //     controller: TextEditingController(),
  //   );
  // }
}

///step1
class FieldControl extends StatefulWidget {
  const FieldControl(
      {Key? key, required this.fieldControl, required this.formKey})
      : super(key: key);
  final List<List> fieldControl;
  final GlobalKey<FormState> formKey;

  @override
  State<FieldControl> createState() => _FieldControlState();
}

class _FieldControlState extends State<FieldControl> {
  List<List> fieldControl = [];
  bool _isLoading = false;
  ScrollController scrollController = ScrollController();

  List<TextInputType> inputTypes = [];

  void initFields() {
    var ep = Provider.of<EmployeeInfoProvider>(context, listen: false);
    ep.form1controllers.clear();

    for (var element in fieldControl) {
      print(element);
      ep.form1controllers.add(MapEntry(
          '${element[4]}', TextEditingController(text: '${element[1] ?? ''}')));
      if (element[1] != null) {
        inputTypes.add(element[1].runtimeType == 0.runtimeType
            ? TextInputType.number
            : TextInputType.name);
      }
    }
    _isLoading = false;
    setState(() {});
    print('Field count is ${ep.form1controllers.length}  ${inputTypes.length}');
  }

  @override
  void initState() {
    super.initState();
    fieldControl = widget.fieldControl;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return Scrollbar(
        controller: scrollController,
        thickness: 10,
        showTrackOnHover: true,
        thumbVisibility: true,
        interactive: true,
        radius: const Radius.circular(10),
        child: Form(
          key: widget.formKey,
          child: ListView(
            controller: scrollController,
            children: [
              ...fieldControl.map((e) {
                int i = fieldControl.indexOf(e);
                debugPrint('fieldControl length is ${fieldControl.length}');
                debugPrint('form type is ${fieldControl[i][4]}');
                debugPrint('form type is ${fieldControl[i].length}');

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: CustomTextField(
                    readOnly: fieldControl[i][2] ?? true,
                    onChange: (val) {
                      print(fieldControl[i][0].toString() +
                          '  ---  $val ---' +
                          ep.form1controllers[i].value.text);
                    },
                    titleStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 20),
                    lableStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    title: fieldControl[i][0],
                    label: fieldControl[i][0],
                    required: fieldControl[i][3],
                    controller: ep.form1controllers[i].value,
                    // inputType: inputTypes[i],
                    formType:
                        fieldControl[i].length >= 5 ? fieldControl[i][5] : null,
                  ),
                );
              }),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      );
    });
  }
}

///step2

class FieldControl2 extends StatefulWidget {
  const FieldControl2(
      {Key? key, required this.fieldControl, required this.formKey})
      : super(key: key);
  final List<List> fieldControl;
  final GlobalKey<FormState> formKey;

  @override
  State<FieldControl2> createState() => _FieldControl2State();
}

class _FieldControl2State extends State<FieldControl2> {
  bool _isLoading = false;
  ScrollController scrollController = ScrollController();

  void initFields(EmployeeInfoProvider ep) {
    for (var element in ep.fieldControl2) {
      print(element);
      ep.field2controllers.add(
        SingleValueDropDownController(
          data: element[1] != null
              ? DropDownValueModel(
                  name: element[1].name, value: element[1].value)
              : null,
        ),
      );
    }
    ep.profileData!.employee!.state != null
        ? ep.selectedState = ep.profileData!.employee!.state
        : null;
    ep.profileData!.employee!.principalComp != null
        ? ep.selectedPC = ep.profileData!.employee!.principalComp
        : null;
    ep.profileData!.employee!.workingFor != null
        ? ep.selectedWorkingCompany = ep.profileData!.employee!.workingFor
        : null;
    ep.profileData!.employee!.zone != null
        ? ep.selectedZone = ep.profileData!.employee!.zone
        : null;
    ep.profileData!.employee!.accountStatus != null
        ? ep.selectedAccStatus = ep.profileData!.employee!.accountStatus
        : null;
    _isLoading = false;
    setState(() {});
    if (ep.profileData!.employee!.gender != null) {
      ep.selectGender = ep.profileData!.employee!.gender;
    }
    if (ep.profileData!.employee!.interviewed != null) {
      ep.interviewed = ep.profileData!.employee!.interviewed;
    }
    if (ep.profileData!.employee!.treatment != null) {
      ep.treatment = ep.profileData!.employee!.treatment;
    }
  }

  @override
  void initState() {
    super.initState();
    var ep = Provider.of<EmployeeInfoProvider>(context, listen: false);
    ep.fieldControl2 = widget.fieldControl;
    initFields(ep);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.fieldControl[1][4]);
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      // debugPrint('${ep.profileData!.employee!.gender}');
      // debugPrint('${ep.profileData!.employee!.interviewed}');
      // debugPrint('${ep.profileData!.employee!.treatment}');
      return Scrollbar(
        controller: scrollController,
        thickness: 10,
        showTrackOnHover: true,
        thumbVisibility: true,
        interactive: true,
        radius: const Radius.circular(10),
        child: Form(
          key: widget.formKey,
          child: ListView(
            controller: scrollController,
            children: [
              ...ep.fieldControl2.map((e) {
                int i = ep.fieldControl2.indexOf(e);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: SizedBox(
                    height: 110,
                    child: CustomDropDownField(
                      title: ep.fieldControl2[i][0],
                      options: <DropDownValueModel>[
                        if (i == 0)
                          ...ep.fieldControl2[i][4].map((state) =>
                              DropDownValueModel(name: state, value: state)),
                        if (i == 1)
                          ...ep.fieldControl2[i][4].map((company) =>
                              DropDownValueModel(
                                  name: company, value: company)),
                        if (i == 2)
                          ...ep.fieldControl2[i][4].map((company) =>
                              DropDownValueModel(
                                  name: company.compNm, value: company.id)),
                        if (i == 3)
                          ...ep.zones.map((zone) =>
                              DropDownValueModel(name: zone, value: zone)),
                        if (i == 4)
                          ...ep.fieldControl2[i][4].map((status) =>
                              DropDownValueModel(name: status, value: status)),
                      ],
                      onChange: (val) {
                        debugPrint(
                            '${ep.fieldControl2[i][0]}  ${ep.field2controllers[i].dropDownValue}  $val');
                        if (i == 0) {
                          ep.selectedState = val.value;
                        }

                        if (i == 1) {
                          ep.selectedPC = val.value;
                        }

                        if (i == 2) {
                          ep.getZones();
                          ep.selectedZone = null;
                          ep.field2controllers[3].dropDownValue = null;
                        }

                        if (i == 3) {
                          ep.selectedZone = val.value;
                        }

                        if (i == 4) {
                          ep.selectedAccStatus = val.value;
                        }
                      },
                      isEnabled: i == 3 ? ep.zones.length != 0 : null,
                      label: 'Select',
                      required: ep.fieldControl2[i][3],
                      controller: ep.field2controllers[i],
                    ),
                  ),
                );
              }),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Gender:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile<String>(
                          value: 'male',
                          title: Text('Male'),
                          groupValue: ep.selectGender,
                          onChanged: (val) {
                            setState(() {
                              ep.selectGender = val!;
                              ep.profileData!.employee!.gender =
                                  ep.selectGender;
                            });
                          }),
                      RadioListTile<String>(
                          value: 'female',
                          title: Text('Female'),
                          groupValue: ep.selectGender,
                          onChanged: (val) {
                            setState(() {
                              ep.selectGender = val!;
                              ep.profileData!.employee!.gender =
                                  ep.selectGender;
                            });
                          }),
                    ],
                  ),
                  if (!ep.approved)
                    Container(
                      color: Colors.transparent,
                      height: 150,
                      width: double.maxFinite,
                    )
                ],
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Have you been  ep.interviewed previously for employment in this company? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile<String>(
                          value: 'Yes',
                          title: Text('Yes'),
                          groupValue: ep.interviewed,
                          onChanged: (val) {
                            setState(() {
                              ep.interviewed = val!;
                              ep.profileData!.employee!.interviewed =
                                  ep.interviewed;
                            });
                          }),
                      RadioListTile<String>(
                          value: 'No',
                          title: Text('No'),
                          groupValue: ep.interviewed,
                          onChanged: (val) {
                            setState(() {
                              ep.interviewed = val!;
                              ep.profileData!.employee!.interviewed =
                                  ep.interviewed;
                            });
                          }),
                    ],
                  ),
                  if (!ep.approved)
                    Container(
                      color: Colors.transparent,
                      height: 150,
                      width: double.maxFinite,
                    )
                ],
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Treatment by any psychotropic drug for long / short term, history of mental illness, if any (self / family) or any major illness in previous two years.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile<String>(
                          value: 'Yes',
                          title: Text('Yes'),
                          groupValue: ep.treatment,
                          onChanged: (val) {
                            setState(() {
                              ep.treatment = val!;
                              ep.profileData!.employee!.treatment =
                                  ep.treatment;
                            });
                          }),
                      RadioListTile<String>(
                          value: 'No',
                          title: Text('No'),
                          groupValue: ep.treatment,
                          onChanged: (val) {
                            setState(() {
                              ep.treatment = val!;
                              ep.profileData!.employee!.treatment =
                                  ep.treatment;
                            });
                          }),
                      Text(
                          'Declaration:\n I certify that the facts stated by me in this application are true. I understand that any misrepresentation or suppression of any information will render me liable for summary dismissal forthwith from the services of the company.\nI give my consent to TEAM IDEAL to conduct a CIBIL / any other check on my profile basis the information furnished below with utmost accuracy.'),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                  if (!ep.approved)
                    Container(
                      color: Colors.transparent,
                      height: 150,
                      width: double.maxFinite,
                    )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

///step6
class FieldControl6 extends StatefulWidget {
  const FieldControl6({Key? key, required this.docs, required this.formKey})
      : super(key: key);
  final Documents docs;
  final GlobalKey<FormState> formKey;

  @override
  State<FieldControl6> createState() => _FieldControl6State();
}

class _FieldControl6State extends State<FieldControl6> {
  late Documents docs;
  ScrollController scrollController = ScrollController();

  void initFields(EmployeeInfoProvider ep) {
    // ep.fieldControl6.clear();
    // widget.docs.toJson().forEach((k, v) {
    //   ep.fieldControl6.addAll({k: v.toString()});
    // });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var ep = Provider.of<EmployeeInfoProvider>(context, listen: false);
    initFields(ep);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      // debugPrint('${ep.profileData!.employee!.gender}');
      // debugPrint('${ep.profileData!.employee!.interviewed}');
      // debugPrint('${ep.profileData!.employee!.treatment}');
      return Scrollbar(
        controller: scrollController,
        thickness: 10,
        showTrackOnHover: true,
        thumbVisibility: true,
        interactive: true,
        radius: const Radius.circular(10),
        child: Form(
          key: widget.formKey,
          child: ListView(
            controller: scrollController,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forms',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      DownloadAndUploadDoc(
                          title: 'ESIC Form Download',
                          field: 'esicupld',
                          type: 'sample',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'ESIC Form Download',
                          field: 'form2upld',
                          type: 'sample',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'ESIC Form Download',
                          field: 'form11upld',
                          type: 'sample',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'ESIC Form Download',
                          field: 'tiplinfo',
                          type: 'sample',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'ESIC Form Download',
                          field: 'tiplkit',
                          type: 'sample',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documents',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      DownloadAndUploadDoc(
                          title: 'Pan Card',
                          field: 'panupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'EAadhar Card',
                          field: 'aadharupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'Cancel Chq',
                          field: 'cchqupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'Relieving Letter of Last Employment	',
                          field: 'reletterupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'Last Past Examination Certificate	',
                          field: 'pastcerupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'Passport Size Photo	',
                          field: 'passportupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                      DownloadAndUploadDoc(
                          title: 'Address Proof	',
                          field: 'addproofupld',
                          type: 'doc',
                          url:
                              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      );
    });
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.onChange,
    this.title,
    required this.label,
    required this.required,
    required this.controller,
    this.inputType,
    this.maxline,
    this.titleStyle,
    this.readOnly,
    this.lableStyle,
    this.formType,
    this.onTap,
    // required this.formKey,
  }) : super(key: key);
  final void Function(String val) onChange;
  final VoidCallback? onTap;
  final String? title;
  final String label;
  final String? formType;
  final bool required;
  TextEditingController controller;
  final TextInputType? inputType;
  final int? maxline;
  final TextStyle? titleStyle;
  final TextStyle? lableStyle;
  final bool? readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // final GlobalKey<FormState> formKey;
  // final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      debugPrint('User has permission to edit ${ep.approved}');
      return Column(
        children: [
          if (widget.title != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title!,
                    style: widget.titleStyle ??
                        const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                  ),
                )
              ],
            ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    // key: formKey,
                    // focusNode: focusNode,
                    onTap: widget.onTap,
                    autovalidateMode: AutovalidateMode.always,
                    controller: widget.controller,
                    keyboardType: widget.inputType,
                    maxLines: widget.maxline,
                    readOnly: ep.approved ? false : true,
                    // readOnly: true,
                    // style:widget.titleStyle,
                    enabled: widget.readOnly != null ? !widget.readOnly! : true,
                    // enabled: widget.readOnly != null ? !widget.readOnly! : true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      suffixIcon: ep.approved &&
                              widget.formType != null &&
                              widget.formType == 'date'
                          ? IconButton(
                              onPressed: () async {
                                var dt = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 2 * 365),
                                  ),
                                );
                                if (dt != null) {
                                  setState(() {
                                    widget.controller.text =
                                        DateFormat('dd-MM-yyyy').format(dt);
                                    widget.onChange(widget.controller.text);
                                  });
                                }
                              },
                              icon: Icon(Icons.calendar_month),
                            )
                          : null,
                      hintStyle: widget.lableStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: widget.label,
                    ),
                    onChanged: (val) {
                      widget.onChange(val);
                    },
                    validator: (val) {
                      if (widget.required) {
                        print(val);

                        if (val!.isEmpty) {
                          return '${widget.title} is required';
                        }
                      } else {
                        print('No');
                      }
                    },
                    onEditingComplete: () {
                      // print('Editing completed');
                      // formKey.currentState?.validate();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      );
    });
  }
}

class CustomDropDownField extends StatefulWidget {
  CustomDropDownField({
    Key? key,
    required this.title,
    required this.options,
    required this.onChange,
    required this.label,
    required this.required,
    required this.controller,
    this.maxline,
    this.titleStyle,
    this.lableStyle,
    this.readOnly,
    this.isEnabled,
  }) : super(key: key);
  final void Function(DropDownValueModel val) onChange;
  final String? title;
  final String label;
  final bool required;
  SingleValueDropDownController controller;
  final int? maxline;
  final TextStyle? titleStyle;
  final TextStyle? lableStyle;
  final bool? readOnly;
  final bool? isEnabled;
  final List<DropDownValueModel> options;

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // FocusNode searchFocusNode = FocusNode();
  // FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    _cnt = widget.controller;
    super.initState();
  }

  // @override
  // void dispose() {
  //   _cnt.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title!,
                          style: widget.titleStyle ??
                              const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 5),
                DropDownTextField(
                  // initialValue: "name4",
                  // readOnly: ep.approved ? false : true,
                  isEnabled: ep.approved ? true : widget.isEnabled ?? true,
                  controller: _cnt,
                  clearOption: true,
                  enableSearch: true,
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchDecoration: InputDecoration(hintText: widget.label),
                  validator: (value) {
                    debugPrint('validate $value');
                    if (value == null || value == '') {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 6,
                  autovalidateMode: AutovalidateMode.always,
                  dropDownList: widget.options,
                  onChanged: (val) {
                    widget.onChange(val);
                    ep.selectedWorkingCompany = val.name;
                    print(val.runtimeType);
                  },
                ),
              ],
            ),
            if (!ep.approved)
              Container(
                color: Colors.transparent,
              ),
          ],
        ),
      );
    });
  }
}

///step3
class EducationCard extends StatefulWidget {
  const EducationCard({Key? key}) : super(key: key);

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return ListView(
        children: [
          ...ep.educations.map((e) {
            print(e.examPassed);
            print(e.insName);
            print(e.passPercentage);
            print(e.yearOfPass);
            return SizedBox(
              // height: 300,
              child: EduCard(
                e: e,
                index: ep.educations.indexOf(e),
              ),
            );
          }),
          SizedBox(height: 20),
          if (ep.approved)
            Row(
              children: [
                FloatingActionButton.extended(
                    onPressed: () {
                      ep.educations.add(
                        EducationBoxModel(
                          id: (ep.educations.length + 1).toString(),
                        ),
                      );
                      setState(() {});
                    },
                    label: Text('Add New'),
                    icon: Icon(Icons.add)),
              ],
            ),
          SizedBox(height: 200),
        ],
      );
    });
  }
}

class EducationBoxModel {
  String id;
  String? emp_code;
  String? examPassed;
  String? insName;
  String? yearOfPass;
  String? passPercentage;
  EducationBoxModel({
    required this.id,
    this.examPassed,
    this.emp_code,
    this.insName,
    this.yearOfPass,
    this.passPercentage,
  });
}

class EduCard extends StatefulWidget {
  const EduCard({Key? key, required this.e, required this.index})
      : super(key: key);
  final EducationBoxModel e;
  final int index;
  @override
  State<EduCard> createState() => _EduCardState();
}

class _EduCardState extends State<EduCard> {
  EduDetail? eduDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eduDetail = EduDetail(
      id: widget.e.id,
      exampass: widget.e.examPassed,
      empCode: widget.e.emp_code,
      passyear: widget.e.yearOfPass,
      passperc: widget.e.passPercentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return Card(
        // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        elevation: 5,
        shadowColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Form ${widget.index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () async {
                        setState(() {
                          ep.educations.remove(widget.e);
                        });
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.educations[widget.index].examPassed = val;
                    // setState(() {});
                  },
                  title: 'Examination Passed',
                  label: '',
                  required: true,
                  controller:
                      TextEditingController(text: widget.e.examPassed ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.educations[widget.index].insName = val;
                    // setState(() {});
                  },
                  title: 'Institution Name',
                  label: '',
                  required: true,
                  controller:
                      TextEditingController(text: widget.e.insName ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.educations[widget.index].yearOfPass = val;
                    // setState(() {});
                  },
                  title: 'Year of Passing',
                  label: '',
                  required: true,
                  inputType: TextInputType.number,
                  controller:
                      TextEditingController(text: widget.e.yearOfPass ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.educations[widget.index].passPercentage = val;
                    // setState(() {});
                  },
                  title: 'Passed % Obtained	',
                  label: '',
                  required: true,
                  inputType: TextInputType.number,
                  controller: TextEditingController(
                      text: widget.e.passPercentage ?? ''),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

///step 4

class EmpDetailListCard extends StatefulWidget {
  const EmpDetailListCard({Key? key, required this.e, required this.index})
      : super(key: key);
  final EmpDetail e;
  final int index;
  @override
  State<EmpDetailListCard> createState() => _EmpDetailListCardState();
}

class _EmpDetailListCardState extends State<EmpDetailListCard> {
  late EmpDetail empDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    empDetail = widget.e;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return Card(
        // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        elevation: 5,
        shadowColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '# ${widget.index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () async {
                        setState(() {
                          ep.employees.remove(empDetail);
                        });
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.employees[widget.index].prevorg = val;
                  },
                  title: 'PREVIOUS ORGANISATION',
                  label: 'PREVIOUS ORGANISATION',
                  required: true,
                  controller:
                      TextEditingController(text: empDetail.prevorg ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.employees[widget.index].prevpos = val;
                  },
                  title: 'PREVIOUS POSITION',
                  label: 'PREVIOUS POSITION',
                  required: true,
                  controller:
                      TextEditingController(text: empDetail.prevpos ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.employees[widget.index].prevsal = val;
                  },
                  title: 'GROSS SALARY',
                  label: 'GROSS SALARY',
                  required: true,
                  inputType: TextInputType.number,
                  controller:
                      TextEditingController(text: empDetail.prevsal ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.employees[widget.index].reasonleave = val;
                  },
                  title: 'REASON FOR LEAVING',
                  label: 'REASON FOR LEAVING',
                  required: true,
                  inputType: TextInputType.text,
                  controller:
                      TextEditingController(text: empDetail.reasonleave ?? ''),
                ),
                CustomTextField(
                  onChange: (val) {
                    ep.employees[widget.index].periodofemp = val;
                  },
                  title: 'PERIOD OF EMPLOYEMENT',
                  label: 'PERIOD OF EMPLOYEMENT',
                  required: true,
                  inputType: TextInputType.text,
                  controller:
                      TextEditingController(text: empDetail.periodofemp ?? ''),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class PreviousJobCard extends StatefulWidget {
  const PreviousJobCard({Key? key}) : super(key: key);

  @override
  State<PreviousJobCard> createState() => _PreviousJobCardState();
}

class _PreviousJobCardState extends State<PreviousJobCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return ListView(
        children: [
          ...ep.employees.map((e) {
            return SizedBox(
              // height: 300,
              child: EmpDetailListCard(
                e: e,
                index: ep.employees.indexOf(e),
              ),
            );
          }),
          SizedBox(height: 20),
          if (ep.approved)
            Row(
              children: [
                FloatingActionButton.extended(
                    onPressed: () {
                      ep.employees.add(EmpDetail());
                      setState(() {});
                    },
                    label: Text('Add New'),
                    icon: Icon(Icons.add)),
              ],
            ),
          SizedBox(height: 200),
        ],
      );
    });
  }
}

///Step 5
class ReferencesForm extends StatefulWidget {
  const ReferencesForm({Key? key}) : super(key: key);

  @override
  State<ReferencesForm> createState() => _ReferencesFormState();
}

class _ReferencesFormState extends State<ReferencesForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return ListView(
        children: [
          Card(
            // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            elevation: 0,
            shadowColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency contact (Family Member Only):',
                      style: TextStyle(
                        // color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...ep.emergencies.map(
                      (e) {
                        var index = ep.emergencies.indexOf(e);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${index + 1}',
                              style: TextStyle(),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.emergencies[index].emergname = val;
                              },
                              title: 'Name',
                              label: 'Name',
                              required: true,
                              controller: TextEditingController(
                                  text: ep.emergencies[index].emergname ?? ''),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.emergencies[index].emergrel = val;
                              },
                              title: 'Relation',
                              label: 'Relation',
                              required: true,
                              controller: TextEditingController(
                                  text: ep.emergencies[index].emergrel ?? ''),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.emergencies[index].emergno = val;
                              },
                              title: 'Number',
                              label: 'Number',
                              required: true,
                              inputType: TextInputType.number,
                              controller: TextEditingController(
                                  text: ep.emergencies[index].emergno ?? ''),
                            ),
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            elevation: 5,
            shadowColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Form(
                child: Column(
                  children: [
                    Text(
                      'References (persons mentioned should hold responsible positions and should not be relatives):',
                      style: TextStyle(
                        // color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...ep.refPersons.map(
                      (e) {
                        var index = ep.refPersons.indexOf(e);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#$index',
                              style: TextStyle(),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.refPersons[index].refname = val;
                              },
                              title: 'Name',
                              label: 'Name',
                              required: true,
                              controller: TextEditingController(
                                  text: ep.refPersons[index].refname ?? ''),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.refPersons[index].addconemail = val;
                              },
                              title: 'Address & Contact Number/ email address',
                              label: 'Address & Contact Number/ email address',
                              required: true,
                              controller: TextEditingController(
                                  text: ep.refPersons[index].addconemail ?? ''),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.refPersons[index].occupation = val;
                              },
                              title: 'Occupation',
                              label: 'Occupation',
                              required: true,
                              inputType: TextInputType.number,
                              controller: TextEditingController(
                                  text: ep.refPersons[index].occupation ?? ''),
                            ),
                            CustomTextField(
                              onChange: (val) {
                                ep.refPersons[index].yrsofacq = val;
                              },
                              title: 'Years of Acquaintance',
                              label: 'Years of Acquaintance',
                              required: true,
                              inputType: TextInputType.number,
                              controller: TextEditingController(
                                  text: ep.refPersons[index].yrsofacq ?? ''),
                            ),
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 150),
        ],
      );
    });
  }
}

class DownloadAndUploadDoc extends StatefulWidget {
  const DownloadAndUploadDoc(
      {Key? key,
      required this.title,
      required this.url,
      required this.type,
      required this.field})
      : super(key: key);
  final String title;
  final String url;
  final String type;
  final String field;

  @override
  State<DownloadAndUploadDoc> createState() => _DownloadAndUploadDocState();
}

class _DownloadAndUploadDocState extends State<DownloadAndUploadDoc> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      bool selected = ep.fieldControl6.entries.any((element) {
        print(element);
        return element.key == widget.field &&
            element.value != null &&
            element.value != '';
      });
      bool uploaded =
          ep.profileData!.documents!.toJson().entries.firstWhere((element) {
                print(element);
                return element.key == widget.field;
              }).value !=
              ''&& ep.profileData!.documents!.toJson().entries.firstWhere((element) {
            print(element);
            return element.key == widget.field;
          }).value !=
              null;
      return Row(
        children: [
          Expanded(
            child: widget.type == 'doc'
                ? OutlinedButton(
                    onPressed: null,
                    child: Text(widget.title,
                        style: TextStyle(), overflow: TextOverflow.ellipsis),
                  )
                : ElevatedButton(
                    onPressed: ep.approved
                        ? () async {
                            downloadSample(widget.url);
                          }
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(widget.title,
                                style: TextStyle(),
                                overflow: TextOverflow.ellipsis)),
                        Icon(Icons.download),
                      ],
                    ),
                  ),
            flex: 4,
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selected || uploaded ? Colors.green : Colors.grey[500]),
              onPressed: ep.approved
                  ? () async {
                      await ep
                          .pickFiles(field: widget.field)
                          .then((value) => setState(() {}));
                    }
                  : null,
              child: Text(
                  selected
                      ? 'Img 34 34 dfewv g  fedd fdsfdgr edddf739.png'
                      : uploaded
                          ? 'Re-Upload'
                          : 'Upload',
                  style: TextStyle(),
                  overflow: TextOverflow.ellipsis),
            ),
            flex: 3,
          ),
        ],
      );
    });
  }
}

String? path;

void downloadSample(String url) async {
  try {
    path = await getDownloadPath();
    var filePath = '$path/${url.split('/').last}';
    if (path != null) {
      var response = await Dio().download(
        'http://www.google.com',
        filePath,
        // options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
        onReceiveProgress: ((pr, st) {
          debugPrint('downloading file $url at $filePath  $pr  $st');
        }),
      );
      print(response.data);
      print(response.statusCode);
      print(response.statusMessage);
      Fluttertoast.showToast(msg: 'Download completed ${url.split('/').last}');
    } else {
      Fluttertoast.showToast(msg: 'Couldn\'t get download path');
    }
  } catch (e) {
    print(e);
  }
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
  } catch (err, stack) {
    Fluttertoast.showToast(msg: "Cannot get download folder path");
  }
  return directory?.path;
}
