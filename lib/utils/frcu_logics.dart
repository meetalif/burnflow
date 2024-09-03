frcuLogics(
  String targetUrineOutput,
  num urineOutput,
  double previousFlowRate,
  String dropFactor,
  double bodyWeight,
) {
  double? lowerLimit;
  int? upperLimit;
  var dropFactorDps = dropFactor == "15 drops = 1 mL (Commonly Used)" ? 15 : 60;
  if (targetUrineOutput == '0.5 - 1 mL/hour/kg') {
    lowerLimit = 0.5;
    upperLimit = 1;
  } else {
    lowerLimit = 1;
    upperLimit = 2;
  }
  num? Z;
  num Z1;
  num? z;
  num? z1;

  if (urineOutput < lowerLimit * bodyWeight) {
    Z = previousFlowRate + previousFlowRate / 3;
  } else if (urineOutput >= lowerLimit * bodyWeight &&
      urineOutput <= upperLimit * bodyWeight) {
    Z = previousFlowRate;
  } else {
    Z = previousFlowRate - previousFlowRate / 3;
  }
  Z1 = Z * dropFactorDps / 60;
  z = Z.round();
  z1 = Z1.round();
  return ("""New IV Fluid Flow rate: **$z mL/hour** or **$z1 drops/minute**""");
}
