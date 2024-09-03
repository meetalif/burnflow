// Define a function to calculate based on selected paths and age
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/helpers/lb_list.dart';
import 'package:burnflow/models/lb_model.dart';
import 'package:burnflow/utils/utils.dart';

double calculateValues(List<String> selectedPaths) {
  double total = 0.0;
  var age = getAge();

  // Iterate through the selected paths
  for (String path in selectedPaths) {
    // Find the LBModel that corresponds to the selected path
    LBModel? selectedModel = list.firstWhere(
      (model) => model.partId!.contains(path),
    );

    if (age < 2) {
      total += selectedModel.d0to1 ?? 0.0;
    } else if (age < 5) {
      total += selectedModel.d1to4 ?? 0.0;
    } else if (age < 10) {
      total += selectedModel.d5to9 ?? 0.0;
    } else if (age < 15) {
      total += selectedModel.d10to14 ?? 0.0;
    } else if (age == 15) {
      total += selectedModel.d15 ?? 0.0;
    } else if (age > 15) {
      total += selectedModel.d15up ?? 0.0;
    }
  }
  controller.tbsa.value = total;

  if (age <= 0) {
    controller.tbsaController.clear();
  } else {
    controller.tbsaController.text = removeTrailingZeros(
        double.tryParse(controller.tbsa.value.toStringAsFixed(2)) ?? 0);
  }

  return total;
}
