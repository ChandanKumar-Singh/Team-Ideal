import 'package:dakshattendance/const/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

class ManageEmployees extends StatefulWidget {
  const ManageEmployees({Key? key}) : super(key: key);

  @override
  State<ManageEmployees> createState() => _ManageEmployeesState();
}

class _ManageEmployeesState extends State<ManageEmployees> {
  int activeStep = 0;
  TextEditingController fncontroller = TextEditingController();

  ///ScrollControllers
  ScrollController step1ScrollController = ScrollController();

  ///Form Keys
  final GlobalKey<FormState> step1Form = GlobalKey();
  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: activeStep == 0 ? step1FieldControl() : SizedBox(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
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
                if (activeStep == 4) {
                  step1Form.currentState?.validate();
                } else {
                  setState(() {
                    activeStep++;
                  });
                }
              },
              label: Text(activeStep != 4 ? 'Next' : '📤 Update'),
            ),
          ],
        ),
      ),
    );
  }

  FieldControl step1FieldControl() {
    return FieldControl(
      formKey: step1Form,
      fieldControle: [
        [
          'First Name',
          ' lp.lead!.month',
          false,
          true,
        ],
        [
          'Middle Name',
          '',
          false,
          false,
        ],
        [
          'Last Name',
          '',
          false,
          false,
        ],
        [
          'Employee Code',
          '',
          false,
          false,
        ],
        [
          'Password',
          '',
          false,
          false,
        ],
        [
          'Email Id',
          '',
          false,
          false,
        ],
        [
          'Official Email Id',
          '',
          false,
          false,
        ],
        [
          'Alternate Email Id',
          '',
          false,
          false,
        ],
        [
          'Official Mobile No.',
          '',
          false,
          false,
        ],
        [
          'Alternate Mobile No.',
          '',
          false,
          false,
        ],
        [
          'Current Address',
          '',
          false,
          false,
        ],
        [
          'Grade',
          '',
          false,
          false,
        ],
        [
          'PF No',
          '',
          false,
          false,
        ],
        [
          'ESIC No',
          '',
          false,
          false,
        ],
        [
          'Education',
          '',
          false,
          false,
        ],
        [
          'Age',
          '',
          false,
          false,
        ],
        [
          'Select State',
          '',
          false,
          false,
        ],
        [
          'Designation',
          '',
          false,
          false,
        ],
        [
          'Joining Date',
          '',
          false,
          false,
        ],
        [
          'Resignation Date',
          '',
          false,
          false,
        ],
        [
          'Leave Date',
          '',
          false,
          false,
        ],
        [
          'Location',
          '',
          false,
          false,
        ],
        [
          'Bank Name',
          '',
          false,
          false,
        ],
        [
          'Account No',
          '',
          false,
          false,
        ],
        [
          'Bank City',
          '',
          false,
          false,
        ],
        [
          'Branch',
          '',
          false,
          false,
        ],
        [
          'IFSC Code',
          '',
          false,
          false,
        ],
        [
          'Aadhar Card No',
          '',
          false,
          false,
        ],
        [
          'Remarks',
          '',
          false,
          false,
        ],
        [
          'Supervisor',
          '',
          false,
          false,
        ],
        [
          'UAN No',
          '',
          false,
          false,
        ],
        [
          'PAN NO',
          '',
          false,
          false,
        ],
        [
          'Reporting HR Name',
          '',
          false,
          false,
        ],
        [
          'NUMBER',
          '',
          false,
          false,
        ],
        [
          'Nominee Name',
          '',
          false,
          false,
        ],
        [
          'Nominee Mobile No',
          '',
          false,
          false,
        ],
        [
          'Nominee Relationship',
          '',
          false,
          false,
        ],
        [
          'Nominee Address',
          '',
          false,
          false,
        ],
      ],
    );
  }
}

// class CustomTextField extends StatefulWidget {
//   const CustomTextField({
//     Key? key,
//     required this.fncontroller, required this.onChanged,
//   }) : super(key: key);
//
//   final TextEditingController fncontroller;
//   final void Function(String val) onChanged;
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: widget.fncontroller,
//             onChanged: (val){
//               widget.onChanged(val);
//             },
//             decoration: InputDecoration(
//               labelText: 'First Name',
//               labelStyle: TextStyle(
//                 fontWeight: FontWeight.normal,
//                 color: Colors.grey[400],
//                 fontSize: 18,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(
//                   color:
//                       Theme.of(context).colorScheme.background,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(
//                   color:
//                       Theme.of(context).colorScheme.background,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(
//                   color:
//                       Theme.of(context).colorScheme.background,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

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
                        '  ---  ' +
                        controllers[i].text);
                  },
                  titleStyle: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 20),
                  lableStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  title: fieldControl[i][0],
                  label: fieldControl[i][0],
                  required: fieldControl[i][3],
                  controller: controllers[i],
                  inputType: inputTypes[i],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
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
    // required this.formKey,
  }) : super(key: key);
  final void Function(String val) onChange;
  final String? title;
  final String label;
  final bool required;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxline;
  final TextStyle? titleStyle;
  final TextStyle? lableStyle;
  final bool? readOnly;

  // final GlobalKey<FormState> formKey;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: titleStyle ??
                      const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            ],
          ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                // key: formKey,
                // focusNode: focusNode,
                controller: controller,
                keyboardType: inputType,
                maxLines: maxline,
                readOnly: readOnly ?? false,
                enabled: readOnly != null ? !readOnly! : true,
                decoration: InputDecoration(
                  helperStyle: lableStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: label,
                ),
                onChanged: (val) {
                  onChange(val);
                },
                validator: (val) {
                  if (required) {
                    print(val);

                    if (val!.isEmpty) {
                      return '$title is required';
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
            )
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
