import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:pdf/widgets.dart' as pw;
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/helpers/body.dart';
import 'package:burnflow/helpers/print_html_content.dart';
import 'package:burnflow/utils/fc_logics.dart';
import 'package:burnflow/utils/printing.dart';
import 'package:waveui/waveui.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final othersCoMorbidities = TextEditingController();
  List<CheckBoxItem> items = [
    CheckBoxItem('O2 inhalation'),
    CheckBoxItem('Nebulization with', typedText: '...'),
    CheckBoxItem('NG feeding'),
    CheckBoxItem('Analgesic'),
    CheckBoxItem('Antibiotic'),
    CheckBoxItem('Antiulcerant'),
    CheckBoxItem('Tetanus Prophylaxis'),
    CheckBoxItem('Central Venous Catheter', typedText: '...'),
    CheckBoxItem('Urinary Catheter'),
    CheckBoxItem('Eye drop/Ointment'),
    CheckBoxItem('Dressing with', typedText: '...'),
    CheckBoxItem('Counselling'),
    CheckBoxItem('Referral to', typedText: '...'),
  ];

  var additional = [
    "Diabetes",
    "Hypertension",
    "Ischemic Heart Disease",
    "Bronchial",
    "Asthma",
    "COPD",
    "CKD",
    "Others"
  ];

  var selectedAdditional = <String>[];

  final doc = pw.Document();
  var nameC = TextEditingController();
  var dateOfAdmissionC = TextEditingController();
  var dateOfBurnC = TextEditingController();
  var dateCompletedC = TextEditingController();
  var completedByC = TextEditingController();
  var sex = "Male";
  var typeOfBurn = "Flame";

  Future<void> pickDateOfAdmission(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      dateOfAdmissionC.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  Future<void> pickDateOfBurn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      dateOfBurnC.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  Future<void> pickDateCompleted(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      dateCompletedC.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    dateOfAdmissionC.text = DateFormat('dd MMMM yyyy').format(DateTime.now());
    dateOfBurnC.text = DateFormat('dd MMMM yyyy').format(DateTime.now());
    dateCompletedC.text = DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  var imgC = WidgetsToImageController();
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      backgroundColor: Get.theme.cardColor,
      appBar: WaveAppBar(
        actions: [
          TextButton(
              onPressed: () async {
                try {
                  Fluttertoast.showToast(msg: "Please wait...");
                  var image = await imgC.capture();
                  var logoBase64 =
                      await rootBundle.load('assets/images/burnflow_logo.png');
                  convertHtmlToPdfAndPrint(
                    printHtmlContent(
                      items,
                      additional: selectedAdditional,
                      name: nameC.text,
                      typeOfBurn: typeOfBurn,
                      completedBy: completedByC.text,
                      dateOfAdmission: dateOfAdmissionC.text,
                      dateOfBurn: dateOfBurnC.text,
                      sex: sex,
                      others: othersCoMorbidities.text,
                      base64: base64Encode(image!),
                      logoBase64: base64Encode(logoBase64.buffer.asUint8List()),
                      dateCompleted: dateCompletedC.text,
                      result: md.markdownToHtml(
                          fcLogics(true) ?? 'Something went wrong'),
                    ),
                    nameC.text,
                  );
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error: $e");
                }
              },
              child: const Text("Print")),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Get.theme.cardColor,
            child: SizedBox(
              width: context.width > 800 ? 700 : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: WidgetsToImage(
                        controller: imgC,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 180,
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: SvgPicture.string(
                                  front(controller.selectedParts),
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: SvgPicture.string(
                                  back(controller.selectedParts),
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoSegmentedControl(
                        padding: EdgeInsets.zero,
                        groupValue: sex,
                        children: const {
                          "Male": Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text("Male"),
                          ),
                          "Female": Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text("Female"),
                          ),
                        },
                        onValueChanged: (value) {
                          sex = value;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Name"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameC,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: "Enter Patient Name",
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Type of Burn"),
                    const SizedBox(height: 8),
                    DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                          value: "Flame",
                          child: Text("Flame"),
                        ),
                        DropdownMenuItem(
                          value: "Electrical",
                          child: Text("Electrical"),
                        ),
                        DropdownMenuItem(
                          value: "Scald",
                          child: Text("Scald"),
                        ),
                        DropdownMenuItem(
                          value: "Chemical",
                          child: Text("Chemical"),
                        ),
                        DropdownMenuItem(
                          value: "Inhalation Injury",
                          child: Text("Inhalation Injury"),
                        ),
                      ],
                      onChanged: (value) {
                        typeOfBurn = value!;
                      },
                      style: Get.textTheme.bodyMedium,
                      hint: const Text("Select Type of Burn"),
                    ),
                    const SizedBox(height: 16),
                    const Text("Date of Burn"),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => pickDateOfBurn(context),
                      child: TextFormField(
                        controller: dateOfBurnC,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Date of Admission"),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => pickDateOfAdmission(context),
                      child: TextFormField(
                        controller: dateOfAdmissionC,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Date Completed"),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => pickDateCompleted(context),
                      child: TextFormField(
                        controller: dateCompletedC,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Completed By"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: completedByC,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(hintText: 'Enter Completed By'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    const Text("Co Morbidities"),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: additional.length,
                      itemBuilder: (context, index) {
                        final item = additional[index];
                        return Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item),
                              value: selectedAdditional.contains(item),
                              onChanged: (newValue) {
                                log(selectedAdditional.toString());
                                if (!(newValue ?? false)) {
                                  selectedAdditional.remove(item);
                                } else {
                                  selectedAdditional.add(item);
                                }
                                if (!(selectedAdditional.contains("Others"))) {
                                  othersCoMorbidities.clear();
                                }
                                setState(() {});
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            if (item == 'Others' &&
                                selectedAdditional.contains("Others"))
                              TextFormField(
                                controller: othersCoMorbidities,
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Have you checked these?"),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.label),
                          value: item.isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              item.isChecked = newValue!;
                            });
                          },
                          subtitle: item.isChecked
                              ? item.typedText.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.only(top: 12),
                                      width: 200,
                                      child: TextField(
                                        onChanged: (value) {
                                          item.typedText = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: '...'),
                                      ),
                                    )
                                  : null
                              : null, // Show typed text next to checkbox
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBoxItem {
  final String label;
  bool isChecked;
  String typedText;

  CheckBoxItem(
    this.label, {
    this.isChecked = false,
    this.typedText = '',
  });
}
