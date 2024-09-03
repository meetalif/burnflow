import 'package:flutter/cupertino.dart';
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/helpers/constants.dart';
import 'package:burnflow/pages/frcu_page.dart';
import 'package:burnflow/pages/result_page.dart';
import 'package:burnflow/utils/body_logics.dart';
import 'package:burnflow/utils/utils.dart';
import 'package:burnflow/widgets/body_view.dart';
import 'package:burnflow/widgets/footer.dart';
import 'package:waveui/waveui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  var controller = Get.put(AppController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/buet_logo.png",
          height: 65,
        ),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 70,
        actions: [
          Image.asset(
            "assets/images/burnflow_logo.png",
            height: 50,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: context.width > 800 ? 700 : null,
              child: ListTile(
                tileColor: Get.theme.cardColor,
                title: Text(
                  "BurnFlow: A Comprehensive Analysis Of Burn Fluid Management Using An Interactive Mobile App",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleMedium,
                ),
              ),
            ),
            SizedBox(
              width: context.width > 800 ? 700 : null,
              child: ListTile(
                tileColor: Colors.red.withOpacity(0.1),
                title: const Center(
                  child: Text(
                    """Developed based on:
Practical Guidelines For Comprehensive Burn Care
Please note that, the app will only work for patients under 24 hours burn time.""",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: context.width > 800 ? 700 : null,
              child: ListTile(
                tileColor: Colors.green.withOpacity(0.1),
                title: const Text(
                  "Fluid Flow Rate Decision Making Based on Urine Output",
                  style: TextStyle(color: Colors.green),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.green,
                ),
                onTap: () {
                  Get.to(() => const FRCUPage());
                },
              ),
            ),
            const SizedBox(height: 4),
            const BodyView(),
            _buildPC(),
            const Footer(),
          ],
        ),
      ),
    );
  }

  _buildPC() {
    return Container(
      width: context.width > 800 ? 700 : null,
      color: Get.theme.cardColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => CupertinoSegmentedControl(
                  padding: EdgeInsets.zero,
                  groupValue: controller.childOrAdult.value,
                  children: const {
                    "Child": Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text("Child"),
                    ),
                    "Adult": Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text("Adult"),
                    ),
                  },
                  onValueChanged: (value) {
                    controller.childOrAdult.value = value;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Age"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.yearsWeighController,
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
                      var kg = (int.tryParse(value ?? "0") ?? 0);
                      if (kg < 0) {
                        return "Years Must be Positive Number.";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Years",
                      suffixText: "Years",
                    ),
                    onChanged: (value) {
                      controller.tbsa.value =
                          calculateValues(controller.selectedParts);
                      if (getAge() > 15) {
                        controller.childOrAdult.value = "Adult";
                      } else {
                        controller.childOrAdult.value = "Child";
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.monthsWeighController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    textInputAction: TextInputAction.next,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return const SizedBox.shrink();
                    },
                    validator: (value) {
                      var gm = (int.tryParse(value ?? "0") ?? 0);
                      if (gm < 0) {
                        return "Months Must be Positive Number.";
                      } else if (gm > 12) {
                        return "Must be below 12";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Months",
                      suffixText: "Months",
                    ),
                    onChanged: (value) {
                      controller.tbsa.value =
                          calculateValues(controller.selectedParts);
                      if (getAge() > 15) {
                        controller.childOrAdult.value = "Adult";
                      } else {
                        controller.childOrAdult.value = "Child";
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("TBSA"),
            const SizedBox(height: 8),
            Tooltip(
              message:
                  "Age must be valid to calculate TBSA. Not manually editable.",
              child: MouseRegion(
                cursor: SystemMouseCursors.forbidden,
                child: TextFormField(
                  controller: controller.tbsaController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  enabled: false,
                  buildCounter: (context,
                      {required currentLength, required isFocused, maxLength}) {
                    return const SizedBox.shrink();
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return "TBSA is Required.";
                    } else if ((double.tryParse(value ?? "0") ?? 0) <= 0 ||
                        (double.tryParse(value ?? "0") ?? 0) > 100) {
                      return "TBSA Must be Valid (0-100 %).";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    hintText: "Enter Age To Calculate",
                    suffixText: "%",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Parkland Formula Constant"),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.parklandController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                var parklandConstant = double.tryParse(value!) ?? 0;
                if (parklandConstant >= 3 && parklandConstant <= 4) {
                  return null;
                }
                return "Liquid Amount Must be Between 3 to 4 mL";
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Enter Liquid Amount Between 3 to 4 mL",
                suffixText: "mL/kg/TBSA",
              ),
            ),
            const SizedBox(height: 16),
            const Text("Body Weight"),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.bodyWeightC,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              maxLength: 6,
              textInputAction: TextInputAction.next,
              buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) {
                return const SizedBox.shrink();
              },
              validator: (value) {
                var kg = (double.tryParse(value ?? "0") ?? 0);
                if (kg <= 0) {
                  return "Body Weight Must be valid.";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Enter Body Weight",
                suffixText: "KG",
              ),
            ),
            const SizedBox(height: 16),
            const Text("Fluid Already Given"),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.fluidController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              textInputAction: TextInputAction.next,
              buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) {
                return const SizedBox.shrink();
              },
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return "Given Fluid Amount is Required.";
                } else if ((int.tryParse(value ?? "0") ?? 0) < 0) {
                  return "Given Fluid Amount Must be Positive Number.";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Enter Given Fluid Amount",
                suffixText: "mL",
              ),
            ),
            const SizedBox(height: 16),
            const Text("Time Since Burn"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.hoursController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    textInputAction: TextInputAction.next,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return const SizedBox.shrink();
                    },
                    validator: (value) {
                      var hrs = (int.tryParse(value ?? "0") ?? 0);
                      if (hrs < 0) {
                        return "Value Must be Positive Number.";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Enter Hours",
                      suffixText: "Hours",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.minsController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    textInputAction: TextInputAction.next,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return const SizedBox.shrink();
                    },
                    validator: (value) {
                      var mins = (int.tryParse(value ?? "0") ?? 0);
                      if (mins < 0) {
                        return "Value Must be Positive Number.";
                      } else if (mins > 59) {
                        return "Timeframe should be below 60 minutes.";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Enter Minutes",
                      suffixText: "Minutes",
                    ),
                  ),
                ),
              ],
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
              value: controller.dropFactor.value,
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
                controller.dropFactor.value = value!;
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (controller.tbsa.value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    width: context.width > 700 ? 500 : null,
                    content: const Text(SELECT_BODY_AREAS),
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ));
                  return;
                }

                if (_formKey.currentState!.validate()) {
                  Get.to(() => const ResultPage());
                }
              },
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
