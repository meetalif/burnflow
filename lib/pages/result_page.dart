import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/pages/print_page.dart';
import 'package:burnflow/utils/fc_logics.dart';
import 'package:burnflow/utils/nutritional_factors.dart';
import 'package:burnflow/utils/utils.dart';
import 'package:waveui/waveui.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      appBar: WaveAppBar(
        title: "Result",
        actions: [
          TextButton(
            onPressed: () => Get.to(() => const PrintPage()),
            child: const Text("Next"),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            color: Get.theme.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width > 800 ? 700 : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.red.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Summary",
                                textAlign: TextAlign.left,
                                style: Get.textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              title: const Text("TBSA"),
                              trailing: Text(
                                  "${removeTrailingZeros(double.parse(controller.tbsa.value.toStringAsFixed(2)))} %"),
                            ),
                            ListTile(
                              title: const Text("Patient Type"),
                              trailing: Text(controller.childOrAdult.value),
                            ),
                            ListTile(
                              title: const Text("Age"),
                              trailing: Text(doubleToAge(getAge())),
                            ),
                            ListTile(
                              title: const Text("Body Weight"),
                              trailing: Text(
                                  "${removeTrailingZeros(getBodyWeight())} KG"),
                            ),
                            ListTile(
                              title: const Text("Fluid Already Given"),
                              trailing:
                                  Text("${controller.fluidController.text} mL"),
                            ),
                            ListTile(
                              title: const Text("Parkland Formula Constant"),
                              trailing: Text(
                                  "${controller.parklandController.text} mL/kg/TBSA"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.green.shade50,
                        child: fcLogics(false),
                      ),
                      Container(
                        color: Colors.yellow.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Nutritional Factors',
                                style: Get.textTheme.titleLarge,
                              ),
                            ),
                            calculateNutritionalFactors(false) ??
                                "Fill all the blanks",
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
