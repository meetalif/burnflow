import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/utils/utils.dart';
import 'package:waveui/waveui.dart';

dynamic fcLogics(bool isMarkdown) {
  var tbsa = controller.tbsa.value;
  var patientType = controller.childOrAdult.value;
  var bodyWeight = getBodyWeight().round();
  var parklandConstant =
      double.tryParse(controller.parklandController.text) ?? 4;
  double timeInHours = (double.tryParse(controller.hoursController.text) ?? 0) +
      (double.tryParse(controller.minsController.text) ?? 0) / 60;

  int? fluidToBeGiven, maintainanceFluid;
  var givenFluid = int.tryParse(controller.fluidController.text) ?? 0;

  controller.flowRate = "0 mL/hour";
  controller.remainHours = 0;

  if (bodyWeight <= 0 || givenFluid < 0 || timeInHours > 24) {
    return isMarkdown
        ? ("The 24 hours golden hour has already passed. Please use clinical judgment to proceed further.")
        : ListTile(
            title: const Text(
              "The 24 hours golden hour has already passed. Please use clinical judgment to proceed further.",
            ),
          );
  }

  if ((patientType == 'Adult' && tbsa <= 15) ||
      (patientType == 'Child' && tbsa <= 10)) {
    return isMarkdown
        ? ("This patient may not need fluid resuscitation. Please use clinical judgement to proceed further.")
        : ListTile(
            title: const Text(
              "This patient may not need fluid resuscitation. Please use clinical judgement to proceed further.",
            ),
          );
  }

  fluidToBeGiven = (parklandConstant * bodyWeight * tbsa - givenFluid).round();

  if (fluidToBeGiven <= 0) {
    return isMarkdown
        ? ("The Necessary amount of fluid is already given. Please use clinical judgement to proceed further.")
        : ListTile(
            title: const Text(
              "The Necessary amount of fluid is already given. Please use clinical judgement to proceed further.",
            ),
          );
  }
  var resusFluidNextHours = (fluidToBeGiven / 2).round();
  var resusFluidFurtherHours =
      timeInHours > 8 ? resusFluidNextHours : (fluidToBeGiven / 2).round();

  maintainanceFluid = bodyWeight <= 10
      ? bodyWeight * 100
      : bodyWeight <= 20
          ? 1000 + (bodyWeight - 10) * 50
          : 1500 + (bodyWeight - 20) * 20;
  var m = maintainanceFluid.round();
  double pendingTime = (8 - timeInHours) < 0 ? 0 : 8 - timeInHours;

  var dropFactor =
      controller.dropFactor.value == "15 drops = 1 mL (Commonly Used)"
          ? 15
          : 60;

  int? flowRateStart;
  int? flowRateStartDrops;
  int? flowRateAfter16;
  int? flowRateAfter16Drops;
  double remainingTime = 24 - timeInHours;
  controller.remainHours = remainingTime.round();

  if (timeInHours < 8) {
    flowRateStart = (fluidToBeGiven / (2 * pendingTime)).round();
    flowRateStartDrops = ((flowRateStart * dropFactor) / 60).round();
    flowRateAfter16 = (fluidToBeGiven / 32).round();
    flowRateAfter16Drops = (flowRateAfter16 * dropFactor / 60).round();
    controller.flowRate = "$flowRateStart mL/hour";
  } else {
    flowRateAfter16 = (fluidToBeGiven / remainingTime).round();
    flowRateAfter16Drops = (flowRateAfter16 * dropFactor / 60).round();
    controller.flowRate = "$flowRateAfter16 mL/hour";
  }

  if (isMarkdown) {
    return """
## Resuscitation Fluid
The Total Amount of Resuscitation Fluid to be given: **$fluidToBeGiven mL**

${pendingTime <= 0 ? '' : """

### Next **${convertDecimalToHoursMinutes(pendingTime)}**

Resuscitation Fluid to be given: **$resusFluidNextHours mL**

Starting IV Flow Rate: **$flowRateStart mL/hour** or **$flowRateStartDrops drops/minute**
"""}

### ${remainingTime <= 16 ? "Next ${convertDecimalToHoursMinutes(remainingTime)}" : "Further 16 hours"}

Resuscitation Fluid to be given: **$resusFluidFurtherHours mL**

IV Flow Rate: **$flowRateAfter16 mL/hour** or **$flowRateAfter16Drops drops/minute**

***The given flow rate may need to be updated based on urine output. Please use clinical judgement.***

${patientType == 'Child' ? """
---
## Maintenance Fluid

The Amount of Maintenance Fluid to be given in next 24 hours: **$m mL**

***This flow rate is only applicable for Resuscitation fluid. For Maintenance fluid flow rate, please use clinical judgement.***""" : ""}

""";
  } else {
    // Build Column widget for Flutter UI
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Resuscitation Fluid',
            style: Get.textTheme.titleLarge,
          ),
        ),
        ListTile(
          title: const Text(
            "The Total Amount of Resuscitation Fluid to be given",
          ),
          trailing: Text(
            "$fluidToBeGiven mL",
            textAlign: TextAlign.right,
          ),
        ),

        // Next Resuscitation Fluid to be given
        if (pendingTime > 0) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Next ${convertDecimalToHoursMinutes(pendingTime)}',
              style: Get.textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text("Resuscitation Fluid to be given"),
            trailing: Text("$resusFluidNextHours mL"),
          ),
          ListTile(
            title: const Text("Starting IV Flow Rate"),
            trailing: Text(
              "$flowRateStart mL/hour or\n $flowRateStartDrops drops/minute",
            ),
          )
        ],

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${remainingTime <= 16 ? 'Next' : 'Further 16 hours'}',
            style: Get.textTheme.titleMedium,
          ),
        ),
        ListTile(
          title: const Text(
            "Resuscitation Fluid to be given",
          ),
          trailing: Text("$resusFluidFurtherHours mL"),
        ),

        ListTile(
          title: const Text("IV Flow Rate"),
          trailing: Text(
            "$flowRateAfter16 mL/hour or\n $flowRateAfter16Drops drops/minute",
          ),
        ),

        // Maintenance Fluid (only for child patient)
        if (patientType == 'Child')
          Container(
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Maintenance Fluid',
                    style: Get.textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  title: const Text(
                    "The Amount of Maintenance Fluid to be given in next 24 hours",
                  ),
                  trailing: Text(
                    "$m mL",
                    textAlign: TextAlign.right,
                  ),
                ),
                ListTile(
                  title: Text(
                    "This flow rate is only applicable for Resuscitation fluid. For Maintenance fluid flow rate, please use clinical judgement.",
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String convertDecimalToHoursMinutes(double decimal) {
  int hours = decimal.toInt();
  int minutes = ((decimal - hours) * 60).toInt();

  String hoursText = hours > 1 ? 'hours' : 'hour';
  String minutesText = minutes > 1 ? 'minutes' : 'minute';

  String result = '$hours $hoursText';

  if (minutes > 0) {
    result += ' $minutes $minutesText';
  }

  return result;
}
