import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/utils/utils.dart';
import 'package:waveui/waveui.dart';

dynamic calculateNutritionalFactors(bool isMarkdown) {
  var tbsa = controller.tbsa.value;
  var patientType = controller.childOrAdult.value;
  double bw = getBodyWeight();

  if (bw <= 0 || tbsa < 0) {
    return isMarkdown
        ? null
        : ListTile(
            title: Text(
              "Invalid input. Please check body weight and TBSA.",
            ),
          );
  }

  double? requiredCalorie;
  int? r;

  if (tbsa < 20) {
    return isMarkdown
        ? "Patient may not need calorie support. Please use clinical judgement to proceed further"
        : ListTile(
            title: Text(
            "Patient may not need calorie support. Please use clinical judgement to proceed further",
          ));
  } else {
    if (patientType == 'Adult') {
      requiredCalorie = (25 * bw) + (40 * tbsa);
    } else {
      requiredCalorie = (60 * bw) + (35 * tbsa);
    }
  }

  r = requiredCalorie.round();

  if (isMarkdown) {
    return "Required Calorie Support: **$r kcal**";
  } else {
    // Build Column widget for Flutter UI
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            "Required Calorie Support",
          ),
          trailing: Text(
            "$r kcal",
          ),
        ),
      ],
    );
  }
}
