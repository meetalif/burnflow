import 'dart:developer';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:burnflow/utils/frcu_logics.dart';
import 'package:waveui/waveui.dart';

class FRCUPage extends StatefulWidget {
  const FRCUPage({super.key});

  @override
  State<FRCUPage> createState() => _FRCUPageState();
}

class _FRCUPageState extends State<FRCUPage> {
  String targetUrineOutput = '0.5 - 1 mL/hour/kg';
  int? result;
  String? output;
  String dropFactor = '15 drops = 1 mL (Commonly Used)';
  final _formKey = GlobalKey<FormState>();

  var weightController = TextEditingController();
  var urineOutputController = TextEditingController();
  var pFlowRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: WaveTheme(themeColor: Colors.green),
      child: WaveScaffold(
        appBar: const WaveAppBar(title: "Flow Rate Calculation - Urine Output"),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Get.theme.cardColor,
              child: SizedBox(
                width: context.width > 800 ? 700 : null,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "Summary",
                          textAlign: TextAlign.left,
                          style: Get.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        const Text("Body Weight"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textInputAction: TextInputAction.next,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return const SizedBox.shrink();
                          },
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return "Patient Body Weight is Required.";
                            } else if ((int.tryParse(value ?? "0") ?? 0) <= 0 ||
                                (int.tryParse(value ?? "0") ?? 0) > 500) {
                              return "Patient Body Weight Must be Valid (0-500 KG).";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: "Enter Patient Body Weight",
                            suffixText: "KG",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Current Urine Output"),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          textInputAction: TextInputAction.next,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return const SizedBox.shrink();
                          },
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return "Current Urine Output is Required.";
                            } else if ((int.tryParse(value ?? "0") ?? 0) < 0) {
                              return "Current Urine Output Must be Positive Number.";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: urineOutputController,
                          decoration: const InputDecoration(
                            hintText: "Enter Current Urine Output",
                            suffixText: "mL/hour",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Previous Flow Rate"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: pFlowRateController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          textInputAction: TextInputAction.next,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return const SizedBox.shrink();
                          },
                          validator: (value) {
                            var number = double.tryParse(value!) ?? 0;
                            if (value.isEmpty) {
                              return "Previous Flow Rate is Required.";
                            } else if (number < 0) {
                              return "Previous Flow Rate Must be Positive Number.";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: "Enter Previous Flow Rate",
                            suffixText: "mL/hour",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Drop Factor for IV Cannula Set"),
                        const SizedBox(height: 8),
                        DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(12),
                          style: Get.textTheme.bodyMedium!.copyWith(
                            fontSize: 17,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Drop Factor for IV Cannula Set is required";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hint: Text(
                            "Select Drop Factor for IV Cannula Set",
                            style: Get.textTheme.bodyMedium,
                          ),
                          value: dropFactor,
                          items: const [
                            "15 drops = 1 mL (Commonly Used)",
                            "60 drops = 1 mL (Micro burette)"
                          ]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            dropFactor = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text("Target Urine Output"),
                        const SizedBox(height: 8),
                        DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(12),
                          style: Get.textTheme.bodyMedium!.copyWith(
                            fontSize: 17,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hint: Text(
                            "Select Target Urine Output",
                            style: Get.textTheme.bodyMedium,
                          ),
                          value: targetUrineOutput,
                          items: ["0.5 - 1 mL/hour/kg", "1 - 2 mL/hour/kg"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            targetUrineOutput = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                output = frcuLogics(
                                  targetUrineOutput,
                                  double.tryParse(urineOutputController.text) ??
                                      0,
                                  double.tryParse(pFlowRateController.text) ??
                                      0,
                                  dropFactor,
                                  double.tryParse(weightController.text) ?? 0,
                                );
                              } catch (e) {
                                log(e.toString());
                              }
                              setState(() {});
                            }
                          },
                          child: const Text("Calculate"),
                        ),
                        const SizedBox(height: 16),
                        if (output != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.1),
                              border: Border.all(
                                color: Get.theme.dividerColor.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: MarkdownBody(data: "$output"),
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
