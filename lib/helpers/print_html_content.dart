import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/pages/print_page.dart';
import 'package:burnflow/utils/utils.dart';

printHtmlContent(
  List<CheckBoxItem> items, {
  String name = "",
  String sex = "Male",
  String result = "Something went wrong!",
  String dateOfAdmission = "",
  String dateOfBurn = "",
  String completedBy = '',
  required List<String> additional,
  String dateCompleted = "",
  String typeOfBurn = "",
  String base64 = "",
  String logoBase64 = '',
  String others = '',
}) {
  return """<html>
<style>
    body {
        background-color: #FFFFFF;
        
        ${kIsWeb ? "" : "padding: 24px"}
    }

    #mymain {
        width: 100%;
        display: flex;
    }
</style>

<body>   <script>
        window.onload = function() {
            window.print();
        };
    </script>
${kIsWeb ? "" : "</br>"}

    <center>
        <img src="data:image/png;base64,$logoBase64" alt="Logo" style="height: 65px;"> 
    </center></br>
</br>
    <div id="myDIV">
        <div id="mymain">
            <div id="bluediv">
                <img src="data:image/png;base64,$base64" alt="Placeholder image" style="width: 420px; height: 370px;"> 
         </br>
         </br>
        <p>$result</p>
        </br>      </div>
            <div style="padding: 0px 0px 0px 20px;width:350px"><b>Name:</b> $name </br>
                <b>Age:</b> ${doubleToAge(getAge())} </br>
                <b>TBSA:</b> ${removeTrailingZeros(double.parse(controller.tbsa.value.toStringAsFixed(2)))} % </br>
                <b>Patient Type:</b> ${controller.childOrAdult.value}</br>
                <b>Body Weight:</b> ${removeTrailingZeros(getBodyWeight())} KG </br>
                <b>Fluid Already Given:</b> ${controller.fluidController.text} mL </br>
                <b>Sex:</b> $sex </br>
                <b>Date of Admission:</b> $dateOfAdmission </br>
                <b>Type of Burn:</b> $typeOfBurn </br>
                <b>Date of Burn:</b> $dateOfBurn </br>
                <b>Date Completed:</b> $dateCompleted </br>
                <b>Completed by:</b> $completedBy </br>
                <b>Co Morbidities:</b>
                ${listToHtmlList(additional, others)}
              
                </br>
                </br>

                <div>
                    <input type="checkbox" ${(items.where((element) => element.label == "O2 inhalation").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    O2 inhalation
                </div>
                <div>
                    <input type="checkbox" ${(items.where((element) => element.label == "Nebulization with").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Nebulization with <b>${items.where((element) => element.label == "Nebulization with").firstOrNull?.typedText}</b>
                </div>
                <div>
                    <input type="checkbox" ${(items.where((element) => element.label == "Analgesic").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Analgesic
                </div>
                <div>
                    <input type="checkbox" ${(items.where((element) => element.label == "NG feeding").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    NG Feeding
                </div>
                <div>
                    <input type="checkbox" ${(items.where((element) => element.label == "Antibiotic").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Antibiotic
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Antiulcerant").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Antiulcerant
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Tetanus Prophylaxis").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Tetanus Prophylaxis
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Central Venous Catheter").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Central Venous Catheter <b>${items.where((element) => element.label == "Central Venous Catheter").firstOrNull?.typedText}</b>
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Urinary Catheter").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Urinary Catheter
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Eye drop/Ointment").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Eye Drop/Ointment
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Dressing with").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Dressing with <b>${items.where((element) => element.label == "Dressing with").firstOrNull?.typedText}</b>
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Counselling").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Counseling
                </div>
                <div>
                    <input type="checkbox"${(items.where((element) => element.label == "Referral to").firstOrNull?.isChecked ?? false) ? "checked" : ''}>
                    Referral to <b>${items.where((element) => element.label == "Referral to").firstOrNull?.typedText}</b>
                </div>
            </div>
        </div>

        <br/>
       ${generateTable()}
        <br/>
        <center>
            <p><img alt="" src="https://firebasestorage.googleapis.com/v0/b/shikha-meetalif.appspot.com/o/line.png?alt=media&token=812cd16b-b152-49fa-a51c-4cd2aa20ed26" style="width: 645.58px; height: 3.00px;"></p>
            <p><img src="data:image/png;base64,$logoBase64" alt="Placeholder image" style="width: 57px; height: 57px;"> </p>
            <p>BurnFlow App</p>
            <p>All rights reserved.</p>
        </center>
</body>

</html>""";
}

String generateTable() {
  var htmlTable = '<table style="width:100%; border:1px solid black;">';
  htmlTable +=
      '<tr><th>Time</th><th>Flow Rate</th><th>Time</th><th>Flow Rate</th><th>Time</th><th>Flow Rate</th></tr>';

  List<String> times = generateTimes();

  for (int i = 0; i < 8; i++) {
    htmlTable += '<tr>';
    for (int j = 0; j < 6; j++) {
      if (j % 2 == 0) {
        htmlTable +=
            '<td style="border:1px solid black; padding:10px;">${times[(i + (j ~/ 2 * 8)) % 24]}</td>';
      } else {
        if (i == 0 && j == 1) {
          htmlTable +=
              '<td style="border:1px solid black; padding:10px;">${controller.flowRate}</td>';
        } else {
          htmlTable +=
              '<td style="border:1px solid black; padding:10px;"></td>';
        }
      }
    }
    htmlTable += '</tr>';
  }
  htmlTable += '</table>';
  return htmlTable;
}

List<String> generateTimes() {
  DateTime now = DateTime.now();
  var formatter = DateFormat('hh:mm a');

  List<String> times = List<String>.generate(24, (int index) {
    if (controller.remainHours > index) {
      DateTime nextHour = now.add(Duration(hours: index));
      return formatter.format(nextHour);
    } else {
      return '';
    }
  });

  return times;
}

String listToHtmlList(List<String> items, String others) {
  if (items.isEmpty) {
    return ''; // Return an empty string if the list is empty
  }

  final listItems = items.map((item) {
    if (item == "Others") {
      return '<li>$item <ul>${others.split(', ').map((e) => "<li>$e</li>").join()}</ul></li>';
    }
    return '<li>$item</li>';
  }).join('\n');
  final htmlList = '<ul>\n$listItems\n</ul>';

  return htmlList;
}
