import 'package:burnflow/controllers/app_controller.dart';

double getBodyWeight() {
  return (double.tryParse(controller.bodyWeightC.text) ?? 0);
}

double getAge() {
  return (double.tryParse(controller.yearsWeighController.text) ?? 0) +
      ((double.tryParse(controller.monthsWeighController.text) ?? 0) / 12);
}

String removeTrailingZeros(num value) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return value.toStringAsFixed(2).replaceAll(regex, '');
}

String doubleToAge(double age) {
  int years = age.floor();
  int months = ((age - years) * 12).round();

  String result = '$years years';
  if (months > 0) {
    result += ' $months months';
  }

  return result;
}
