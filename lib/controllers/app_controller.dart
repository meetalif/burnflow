import 'package:waveui/waveui.dart';

AppController controller = Get.find();

class AppController extends GetxController {
  var tbsa = 0.0.obs;
  var remainHours = 0;
  var selectedParts = <String>[].obs;

  var childOrAdult = "Child".obs;
  var flowRate = '';
  var dropFactor = "15 drops = 1 mL (Commonly Used)".obs;
  var tbsaController = TextEditingController();
  var parklandController = TextEditingController(text: "4");
  var fluidController = TextEditingController(text: '0');
  var hoursController = TextEditingController();
  var minsController = TextEditingController();
  var bodyWeightC = TextEditingController();
  var yearsWeighController = TextEditingController();
  var monthsWeighController = TextEditingController();
}
