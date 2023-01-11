import 'dart:math';

import 'package:dakshattendance/const/global.dart';
import 'package:dakshattendance/provider/EmployeeInfoProvider/EmployeeInfoProvider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:intl/intl.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
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
                    icon: Icon(CupertinoIcons.cart),
                    title: 'Employee Profile',
                    lineText: 'Add Education',
                  ),
                  EasyStep(
                    icon: Icon(CupertinoIcons.cart),
                    title: 'Dependencies',
                    lineText: 'Multi Forms',
                  ),
                  EasyStep(
                    icon: Icon(CupertinoIcons.info),
                    title: 'Education',
                    lineText: 'Employment Info',
                  ),
                  EasyStep(
                    icon: Icon(CupertinoIcons.cart_fill_badge_plus),
                    title: 'Employment Details',
                    lineText: 'Add Reference',
                  ),
                  EasyStep(
                    icon: Icon(CupertinoIcons.money_dollar),
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
                                            : SizedBox(),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: floatingButtons(),
      );
    });
  }

  Padding floatingButtons() {
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
                if (validate != null && validate) {
                  setState(() {
                    activeStep++;
                  });
                }
              } else {
                setState(() {
                  activeStep++;
                });
              }
            },
            label: Text(activeStep != 5 ? 'Next' : '📤 Update'),
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
        fieldControle: [
          ['First Name', emp.firstNm ?? '', false, true],
          ['Middle Name', emp.middleNm ?? '', false, false],
          ['Last Name', emp.lastNm ?? '', false, false],
          ['Employee Code', emp.empCode ?? '', true, false],
          ['Password', emp.password ?? '', true, false],
          ['Email Id', emp.email ?? '', false, false],
          ['Official Email Id', emp.officialemail ?? '', false, false],
          ['Alternate Email Id', emp.altemail ?? '', false, false],
          ['Official Mobile No.', '', false, false],
          ['Alternate Mobile No.', emp.altmobileno ?? '', false, false],
          ['Current Address', emp.curaddress ?? '', false, false],
          ['Grade', emp.grade ?? '', false, false],
          ['PF No', emp.panNo ?? '', false, false],
          ['ESIC No', emp.esicNo ?? '', false, false],
          ['Education', emp.education ?? '', false, false],
          ['DOB', emp.dob, false, false, 'date'],
          ['Age', emp.age ?? '', false, false],
          ['Contract End Date', emp.cenddt ?? '', true, false, 'date'],
          // ['State', emp.state ?? '', false, false],
          ['Designation', emp.designation ?? '', true, false],
          ['Joining Date', emp.joindt, true, false, 'date'],
          ['Resignation Date', emp.resigndt, false, false, 'date'],
          ['Leave Date', emp.leavedt, false, false, 'date'],
          ['Location', emp.location ?? '', false, false],
          ['Bank Name', emp.banknm ?? '', false, false],
          ['Account No', emp.accno ?? '', false, false],
          ['Bank City', emp.bankcity ?? '', false, false],
          ['Branch', emp.branch ?? '', false, false],
          ['IFSC Code', emp.ifsc ?? '', false, false],
          ['Aadhar Card No', emp.aadharno ?? '', false, false],
          ['Remarks', emp.remarks ?? '', false, false],
          ['Supervisor', emp.supervisor ?? '', false, false],
          ['UAN No', '', false, false],
          ['PAN NO', emp.panNo ?? '', false, false],
          ['Reporting HR Name', emp.rephrName ?? '', false, false],
          ['NUMBER', '', false, false],
          ['Nominee Name', emp.nomiName ?? '', false, false],
          ['Nominee Mobile No', emp.nomiNo ?? '', false, false],
          ['Nominee Relationship', emp.nomiRel ?? '', false, false],
          ['Nominee Date of proof', emp.nomineedt, false, false, 'date'],
          ['Nominee Address', emp.nomiAdd ?? '', false, false],
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
          true,
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
          true,
          ep.zones,
        ],
        [
          'Account Status',
          ep.profileData!.employee!.accountStatus != null
              ? DropDownValueModel(
                  name: ep.profileData!.employee!.accountStatus ?? "",
                  value: ep.profileData!.employee!.accountStatus ?? '')
              : null,
          false,
          true,
          ['Active', 'Deactive'],
        ],
      ],
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

class FieldControl extends StatefulWidget {
  const FieldControl(
      {Key? key, required this.fieldControle, required this.formKey})
      : super(key: key);
  final List<List> fieldControle;
  final GlobalKey<FormState> formKey;

  @override
  State<FieldControl> createState() => _FieldControlState();
}

class _FieldControlState extends State<FieldControl> {
  List<List> fieldControl = [];
  bool _isLoading = false;
  ScrollController scrollController = ScrollController();

  List<TextEditingController> controllers = [];
  List<TextInputType> inputTypes = [];

  void initFields() {
    for (var element in fieldControl) {
      print(element);
      controllers.add(TextEditingController(text: '${element[1] ?? ''}'));
      if (element[1] != null) {
        inputTypes.add(element[1].runtimeType == 0.runtimeType
            ? TextInputType.number
            : TextInputType.name);
      }
    }
    _isLoading = false;
    setState(() {});
    print('Field count is ${controllers.length}  ${inputTypes.length}');
  }

  @override
  void initState() {
    super.initState();
    fieldControl = widget.fieldControle;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thickness: 15,
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: CustomTextField(
                  readOnly: fieldControl[i][2] ?? true,
                  onChange: (val) {
                    print(fieldControl[i][0].toString() +
                        '  ---  $val ---' +
                        controllers[i].text);
                  },
                  titleStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 20),
                  lableStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  title: fieldControl[i][0],
                  label: fieldControl[i][0],
                  required: fieldControl[i][3],
                  controller: controllers[i],
                  inputType: inputTypes[i],
                  formType:
                      fieldControl[i].length > 4 ? fieldControl[i][4] : null,
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
  }
}

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

  String selectGender = 'male';
  bool interviewed = false;
  bool treatment = false;

  void initFields(EmployeeInfoProvider ep) {
    for (var element in ep.fieldControl) {
      print(element);
      ep.controllers.add(
        SingleValueDropDownController(
          data: element[1] != null
              ? DropDownValueModel(
                  name: element[1].name, value: element[1].value)
              : null,
        ),
      );
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var ep = Provider.of<EmployeeInfoProvider>(context, listen: false);
    ep.fieldControl = widget.fieldControl;
    initFields(ep);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.fieldControl[1][4]);
    return Consumer<EmployeeInfoProvider>(builder: (context, ep, _) {
      return Scrollbar(
        controller: scrollController,
        thickness: 15,
        showTrackOnHover: true,
        thumbVisibility: true,
        interactive: true,
        radius: const Radius.circular(10),
        child: Form(
          key: widget.formKey,
          child: ListView(
            controller: scrollController,
            children: [
              ...ep.fieldControl.map((e) {
                int i = ep.fieldControl.indexOf(e);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: SizedBox(
                    height: 110,
                    child: CustomDropDownField(
                      title: ep.fieldControl[i][0],
                      options: <DropDownValueModel>[
                        if (i == 0)
                          ...ep.fieldControl[i][4].map((state) =>
                              DropDownValueModel(name: state, value: state)),
                        if (i == 1)
                          ...ep.fieldControl[i][4].map((company) =>
                              DropDownValueModel(
                                  name: company, value: company)),
                        if (i == 2)
                          ...ep.fieldControl[i][4].map((company) =>
                              DropDownValueModel(
                                  name: company.compNm, value: company.id)),
                        if (i == 3)
                          ...ep.zones.map((zone) =>
                              DropDownValueModel(name: zone, value: zone)),
                        if (i == 4)
                          ...ep.fieldControl[i][4].map((status) =>
                              DropDownValueModel(name: status, value: status)),
                      ],
                      onChange: (val) {
                        debugPrint(
                            '${ep.fieldControl[i][0]}  ${ep.controllers[i].dropDownValue}  $val');
                        if (i == 2) {
                          ep.getZones();
                        }
                      },
                      isEnabled: i == 3 ? ep.zones.length != 0 : null,
                      label: 'Select',
                      required: ep.fieldControl[i][3],
                      controller: ep.controllers[i],
                    ),
                  ),
                );
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile<String>(
                      value: 'male',
                      title: Text('Male'),
                      groupValue: selectGender,
                      onChanged: (val) {
                        setState(() {
                          selectGender = val!;
                        });
                      }),
                  RadioListTile<String>(
                      value: 'female',
                      title: Text('Female'),
                      groupValue: selectGender,
                      onChanged: (val) {
                        setState(() {
                          selectGender = val!;
                        });
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you been interviewed previously for employment in this company? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile<bool>(
                      value: true,
                      title: Text('Yes'),
                      groupValue: interviewed,
                      onChanged: (val) {
                        setState(() {
                          interviewed = val!;
                        });
                      }),
                  RadioListTile<bool>(
                      value: false,
                      title: Text('No'),
                      groupValue: interviewed,
                      onChanged: (val) {
                        setState(() {
                          interviewed = val!;
                        });
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Treatment by any psychotropic drug for long / short term, history of mental illness, if any (self / family) or any major illness in previous two years.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile<bool>(
                      value: true,
                      title: Text('Yes'),
                      groupValue: treatment,
                      onChanged: (val) {
                        setState(() {
                          treatment = val!;
                        });
                      }),
                  RadioListTile<bool>(
                      value: false,
                      title: Text('No'),
                      groupValue: treatment,
                      onChanged: (val) {
                        setState(() {
                          treatment = val!;
                        });
                      }),
                  Text(
                      'Declaration:\n I certify that the facts stated by me in this application are true. I understand that any misrepresentation or suppression of any information will render me liable for summary dismissal forthwith from the services of the company.\nI give my consent to TEAM IDEAL to conduct a CIBIL / any other check on my profile basis the information furnished below with utmost accuracy.'),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
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
                  readOnly: widget.readOnly ?? false,
                  // style:widget.titleStyle,
                  enabled: widget.readOnly != null ? !widget.readOnly! : true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixIcon:
                        widget.formType != null && widget.formType == 'date'
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
            )
          ],
        ),
        SizedBox(height: 15),
      ],
    );
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
    return Scaffold(
      body: Column(
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
            isEnabled: widget.isEnabled ?? true,
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
              print(val.runtimeType);
            },
          ),
        ],
      ),
    );
  }
}

class EducationCard extends StatefulWidget {
  const EducationCard({Key? key}) : super(key: key);

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  Set<EducationBoxModel> educations = {};
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...educations.map((e) {
          return SizedBox(
            // height: 300,
            child: Card(
              // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              elevation: 5,
              shadowColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '# ${e.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                educations.removeWhere(
                                    (element) => element.id == e.id);
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
                        onChange: (val) {},
                        title: 'Examination Passed',
                        label: 'Examination Passed',
                        required: true,
                        controller: TextEditingController(text: e.id ?? ''),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'Institution Name',
                        label: 'Institution Name',
                        required: true,
                        controller: TextEditingController(text: e.id),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'Year of Passing',
                        label: 'Year of Passing',
                        required: true,
                        inputType: TextInputType.number,
                        controller: TextEditingController(),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'Passed % Obtained	',
                        label: 'Passed % Obtained	',
                        required: true,
                        inputType: TextInputType.number,
                        controller: TextEditingController(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 20),
        Row(
          children: [
            FloatingActionButton.extended(
                onPressed: () {
                  educations.add(
                    EducationBoxModel(
                      id: Random().nextInt(1000).toString(),
                      examPassed: Random().nextInt(1000).toString(),
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
  }
}

class EducationBoxModel {
  String id;
  String? examPassed;
  String? insName;
  String? yearOfPass;
  String? passPercentage;
  EducationBoxModel({
    required this.id,
    this.examPassed,
    this.insName,
    this.yearOfPass,
    this.passPercentage,
  });
}

class PreviousJobCard extends StatefulWidget {
  const PreviousJobCard({Key? key}) : super(key: key);

  @override
  State<PreviousJobCard> createState() => _PreviousJobCardState();
}

class _PreviousJobCardState extends State<PreviousJobCard> {
  Set<PreviousJobModel> jobs = {};
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...jobs.map((e) {
          return SizedBox(
            // height: 300,
            child: Card(
              // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              elevation: 5,
              shadowColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '# ${e.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                jobs.removeWhere(
                                    (element) => element.id == e.id);
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
                        onChange: (val) {},
                        title: 'PREVIOUS ORGANISATION',
                        label: 'PREVIOUS ORGANISATION',
                        required: true,
                        controller: TextEditingController(text: e.preOrg ?? ''),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'PREVIOUS POSITION',
                        label: 'PREVIOUS POSITION',
                        required: true,
                        controller: TextEditingController(text: e.id),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'PREVIOUS POSITION',
                        label: 'PREVIOUS POSITION',
                        required: true,
                        inputType: TextInputType.number,
                        controller: TextEditingController(),
                      ),
                      CustomTextField(
                        onChange: (val) {},
                        title: 'REASON FOR LEAVING',
                        label: 'REASON FOR LEAVING',
                        required: true,
                        inputType: TextInputType.number,
                        controller: TextEditingController(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 20),
        Row(
          children: [
            FloatingActionButton.extended(
                onPressed: () {
                  jobs.add(
                    PreviousJobModel(
                      id: Random().nextInt(1000).toString(),
                      preOrg: Random().nextInt(1000).toString(),
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
  }
}

class PreviousJobModel {
  String id;
  String? preOrg;
  String? prePosition;
  String? preSalary;
  String? reason;
  String? periodOfEmployeement;
  PreviousJobModel({
    required this.id,
    this.preOrg,
    this.prePosition,
    this.preSalary,
    this.reason,
    this.periodOfEmployeement,
  });
}

class ReferencesForm extends StatefulWidget {
  const ReferencesForm({Key? key}) : super(key: key);

  @override
  State<ReferencesForm> createState() => _ReferencesFormState();
}

class _ReferencesFormState extends State<ReferencesForm> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Emergency contact (Family Member Only):',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#734',
                    style: TextStyle(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Name',
                    label: 'Name',
                    required: true,
                    controller: TextEditingController(text: '' ?? ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Relation',
                    label: 'Relation',
                    required: true,
                    controller: TextEditingController(text: ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Number',
                    label: 'Number',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '#734',
                    style: TextStyle(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Name',
                    label: 'Name',
                    required: true,
                    controller: TextEditingController(text: '' ?? ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Relation',
                    label: 'Relation',
                    required: true,
                    controller: TextEditingController(text: ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Number',
                    label: 'Number',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'References (persons mentioned should hold responsible positions and should not be relatives):',
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#734',
                    style: TextStyle(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Name',
                    label: 'Name',
                    required: true,
                    controller: TextEditingController(text: '' ?? ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Address & Contact Number/ email address',
                    label: 'Address & Contact Number/ email address',
                    required: true,
                    controller: TextEditingController(text: ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Occupation',
                    label: 'Occupation',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Years of Acquaintance',
                    label: 'Years of Acquaintance',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '#734',
                    style: TextStyle(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Name',
                    label: 'Name',
                    required: true,
                    controller: TextEditingController(text: '' ?? ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Address & Contact Number/ email address',
                    label: 'Address & Contact Number/ email address',
                    required: true,
                    controller: TextEditingController(text: ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Occupation',
                    label: 'Occupation',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Years of Acquaintance',
                    label: 'Years of Acquaintance',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '#734',
                    style: TextStyle(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Name',
                    label: 'Name',
                    required: true,
                    controller: TextEditingController(text: '' ?? ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Address & Contact Number/ email address',
                    label: 'Address & Contact Number/ email address',
                    required: true,
                    controller: TextEditingController(text: ''),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Occupation',
                    label: 'Occupation',
                    required: true,
                    inputType: TextInputType.number,
                    controller: TextEditingController(),
                  ),
                  CustomTextField(
                    onChange: (val) {},
                    title: 'Years of Acquaintance',
                    label: 'Years of Acquaintance',
                    required: true,
                    inputType: TextInputType.number,
                    // titleStyle: const TextStyle(
                    //     fontWeight: FontWeight.normal,
                    //     color: Colors.grey,
                    //     fontSize: 20),
                    // lableStyle: const TextStyle(
                    //     color: Colors.grey,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 20),
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 150),
      ],
    );
  }
}
