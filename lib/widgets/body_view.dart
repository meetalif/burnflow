import 'package:flutter_svg/flutter_svg.dart';
import 'package:burnflow/controllers/app_controller.dart';
import 'package:burnflow/helpers/body.dart';
import 'package:burnflow/helpers/constants.dart';
import 'package:burnflow/utils/body_logics.dart';
import 'package:waveui/waveui.dart';

class BodyView extends StatefulWidget {
  const BodyView({super.key});

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  var isFront = true;
  var hitListVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return SizedBox(
                      width: 800,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 400,
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: SvgPicture.string(
                                    front(controller.selectedParts),
                                    width: double.infinity,
                                  ),
                                ),
                                if (true) ...frontHitlist(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: SvgPicture.string(
                                    back(controller.selectedParts),
                                    width: double.infinity,
                                  ),
                                ),
                                if (true) ...backHitlist(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: 400,
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 9 / 16,
                            child: SvgPicture.string(
                              isFront
                                  ? front(controller.selectedParts)
                                  : back(controller.selectedParts),
                              width: double.infinity,
                            ),
                          ),
                          if (isFront) ...frontHitlist() else ...backHitlist()
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          hitListVisible = !hitListVisible;
                          setState(() {});
                        },
                        icon: Icon(hitListVisible
                            ? FluentIcons.eye_off_24_regular
                            : FluentIcons.eye_28_regular),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.selectedParts.clear();
                          controller.tbsa.value = 0;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            width: context.width > 700 ? 500 : null,
                            content:
                                const Text("Cleared all selected body parts"),
                            duration: const Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ));
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear_all),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            context.width > 800
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton(
                      child: const Icon(FluentIcons.cube_rotate_20_regular),
                      onPressed: () {
                        isFront = !isFront;
                        setState(() {});
                      },
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: context.width > 800 ? 700 : null,
          child: ListTile(
            tileColor: Colors.blue.withOpacity(0.1),
            title: const Center(
              child: Text(
                SELECT_BODY_AREAS,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _positioned(
      {double? l,
      double? r,
      double? t,
      double? b,
      required String tag,
      double height = 20,
      double width = 20}) {
    return Positioned(
      left: l,
      top: t,
      right: r,
      bottom: b,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            debugPrint("Selected part :$tag");
            if (controller.selectedParts.contains(tag)) {
              controller.selectedParts.remove(tag);
            } else {
              controller.selectedParts.add(tag);
            }
            controller.tbsa.value = calculateValues(controller.selectedParts);
            setState(() {});
          },
          child: Container(
            height: height,
            width: width,
            color: hitListVisible
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
            child: Center(
              child: Text(
                tag,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  color: hitListVisible ? Colors.black : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  frontHitlist() => [
        _positioned(tag: "H1", l: 160, width: 40, height: 50),
        _positioned(tag: "H2", l: 200, width: 40, height: 50),
        _positioned(tag: "H3", l: 160, t: 50, width: 40, height: 50),
        _positioned(tag: "H4", l: 200, t: 50, width: 40, height: 50),
        _positioned(tag: "N1", l: 175, t: 100, width: 25, height: 25),
        _positioned(tag: "N2", l: 200, t: 100, width: 25, height: 25),
        _positioned(tag: "A1", l: 120, t: 110, width: 55, height: 30),
        _positioned(tag: "A2", l: 175, t: 125, width: 50, height: 15),
        _positioned(tag: "A3", l: 225, t: 110, width: 55, height: 30),
        _positioned(tag: "A4", l: 135, t: 140, width: 40, height: 50),
        _positioned(tag: "A5", l: 175, t: 140, width: 50, height: 50),
        _positioned(tag: "A6", l: 225, t: 140, width: 40, height: 50),
        _positioned(tag: "A9", l: 225, t: 190, width: 40, height: 60),
        _positioned(tag: "A12", l: 225, t: 250, width: 40, height: 63),
        _positioned(tag: "A8", l: 175, t: 190, width: 50, height: 60),
        _positioned(tag: "A11", l: 175, t: 250, width: 50, height: 63),
        _positioned(tag: "A7", l: 135, t: 190, width: 40, height: 60),
        _positioned(tag: "A10", l: 135, t: 250, width: 40, height: 63),
        _positioned(tag: "A13", l: 135, t: 313, width: 65, height: 45),
        _positioned(tag: "R11", l: 135, t: 358, width: 30, height: 70),
        _positioned(tag: "R13", l: 135, t: 428, width: 32, height: 77),
        _positioned(tag: "R19", l: 145, t: 503, width: 32, height: 65),
        _positioned(tag: "R20", l: 177, t: 503, width: 25, height: 65),
        _positioned(tag: "R23", l: 145, t: 568, width: 32, height: 65),
        _positioned(tag: "R24", l: 177, t: 568, width: 25, height: 65),
        _positioned(tag: "R27", l: 160, t: 630, width: 35, height: 35),
        _positioned(tag: "R28", l: 160, t: 665, width: 35, height: 40),
        _positioned(tag: "R14", l: 167, t: 428, width: 32, height: 77),
        _positioned(tag: "L13", l: 200, t: 428, width: 30, height: 77),
        _positioned(tag: "L14", l: 227, t: 428, width: 32, height: 77),
        _positioned(tag: "L19", l: 200, t: 500, width: 30, height: 70),
        _positioned(tag: "L20", l: 227, t: 500, width: 32, height: 70),
        _positioned(tag: "L23", l: 200, t: 570, width: 30, height: 60),
        _positioned(tag: "L27", l: 200, t: 630, width: 40, height: 30),
        _positioned(tag: "L28", l: 200, t: 660, width: 40, height: 50),
        _positioned(tag: "L24", l: 227, t: 570, width: 32, height: 60),
        _positioned(tag: "R12", l: 165, t: 358, width: 30, height: 70),
        _positioned(tag: "L11", l: 205, t: 358, width: 30, height: 70),
        _positioned(tag: "L12", l: 235, t: 358, width: 30, height: 70),
        _positioned(tag: "G", l: 188, t: 358, width: 30, height: 40),
        _positioned(tag: "A14", l: 200, t: 313, width: 65, height: 45),
        _positioned(tag: "RX1", l: 95, t: 140, width: 30, height: 60),
        _positioned(tag: "RX3", l: 90, t: 200, width: 30, height: 46),
        _positioned(tag: "RX4", l: 120, t: 215, width: 15, height: 45),
        _positioned(tag: "RX10", l: 110, t: 250, width: 20, height: 45),
        _positioned(tag: "RX11", l: 75, t: 290, width: 20, height: 45),
        _positioned(tag: "R9", l: 70, t: 330, width: 30, height: 30),
        _positioned(tag: "R91", l: 40, t: 360, width: 50, height: 50),
        _positioned(tag: "RX12", l: 95, t: 290, width: 20, height: 45),
        _positioned(tag: "RX9", l: 85, t: 245, width: 25, height: 45),
        _positioned(tag: "RX2", l: 123, t: 160, width: 15, height: 55),
        _positioned(tag: "LX1", l: 275, t: 140, width: 30, height: 53),
        _positioned(tag: "LX4", l: 280, t: 200, width: 30, height: 53),
        _positioned(tag: "LX3", l: 265, t: 200, width: 15, height: 53),
        _positioned(tag: "LX9", l: 265, t: 250, width: 30, height: 50),
        _positioned(tag: "LX11", l: 275, t: 300, width: 30, height: 40),
        _positioned(tag: "LX12", l: 305, t: 290, width: 30, height: 40),
        _positioned(tag: "S9", l: 305, t: 330, width: 30, height: 30),
        _positioned(tag: "S91", l: 305, t: 360, width: 60, height: 30),
        _positioned(tag: "LX10", l: 295, t: 250, width: 30, height: 40),
        _positioned(tag: "LX2", l: 260, t: 140, width: 15, height: 73),
      ];
  backHitlist() => [
        _positioned(tag: "I1", l: 160, width: 40, height: 55),
        _positioned(tag: "I2", l: 200, width: 40, height: 55),
        _positioned(tag: "I3", l: 155, t: 55, width: 45, height: 20),
        _positioned(tag: "I4", l: 200, t: 55, width: 40, height: 20),
        _positioned(tag: "N3", l: 170, t: 75, width: 30, height: 30),
        _positioned(tag: "N4", l: 200, t: 75, width: 30, height: 30),
        _positioned(tag: "P14", l: 130, t: 355, width: 45, height: 40),
        _positioned(tag: "P15", l: 175, t: 355, width: 60, height: 45),
        _positioned(tag: "P12", l: 175, t: 310, width: 60, height: 45),
        _positioned(tag: "P9", l: 175, t: 260, width: 50, height: 50),
        _positioned(tag: "P18", l: 175, t: 187, width: 50, height: 70),
        _positioned(tag: "P6", l: 175, t: 140, width: 50, height: 48),
        _positioned(tag: "P2", l: 175, t: 105, width: 25, height: 35),
        _positioned(tag: "P1", l: 110, t: 105, width: 65, height: 40),
        _positioned(tag: "P5", l: 130, t: 140, width: 45, height: 55),
        _positioned(tag: "P7", l: 225, t: 140, width: 45, height: 48),
        _positioned(tag: "P17", l: 140, t: 188, width: 35, height: 70),
        _positioned(tag: "P19", l: 225, t: 188, width: 35, height: 70),
        _positioned(tag: "P8", l: 140, t: 258, width: 35, height: 55),
        _positioned(tag: "P10", l: 225, t: 258, width: 35, height: 55),
        _positioned(tag: "P11", l: 140, t: 313, width: 35, height: 45),
        _positioned(tag: "S92", l: 30, t: 338, width: 55, height: 25),
        _positioned(tag: "LX15", l: 40, t: 298, width: 35, height: 40),
        _positioned(tag: "LX16", l: 75, t: 305, width: 35, height: 40),
        _positioned(tag: "LX13", l: 60, t: 258, width: 35, height: 40),
        _positioned(tag: "LX14", l: 95, t: 268, width: 35, height: 40),
        _positioned(tag: "LX7", l: 85, t: 218, width: 25, height: 50),
        _positioned(tag: "LX8", l: 110, t: 228, width: 25, height: 40),
        _positioned(tag: "LX5", l: 90, t: 158, width: 35, height: 60),
        _positioned(tag: "LX6", l: 125, t: 178, width: 15, height: 50),
        _positioned(tag: "S93", l: 20, t: 363, width: 55, height: 45),
        _positioned(tag: "RX16", l: 320, t: 300, width: 35, height: 50),
        _positioned(tag: "RX15", l: 285, t: 305, width: 35, height: 45),
        _positioned(tag: "RX14", l: 300, t: 250, width: 35, height: 50),
        _positioned(tag: "RX13", l: 265, t: 260, width: 35, height: 45),
        _positioned(tag: "RX7", l: 290, t: 205, width: 35, height: 50),
        _positioned(tag: "RX8", l: 265, t: 220, width: 25, height: 40),
        _positioned(tag: "RX5", l: 275, t: 155, width: 35, height: 50),
        _positioned(tag: "RX6", l: 260, t: 170, width: 20, height: 50),
        _positioned(tag: "R92", l: 320, t: 345, width: 55, height: 25),
        _positioned(tag: "R93", l: 330, t: 370, width: 55, height: 45),
        _positioned(tag: "P13", l: 235, t: 313, width: 35, height: 45),
        _positioned(tag: "P4", l: 225, t: 105, width: 60, height: 40),
        _positioned(tag: "P3", l: 200, t: 105, width: 25, height: 35),
        _positioned(tag: "P16", l: 235, t: 355, width: 40, height: 45),
        _positioned(tag: "L15", l: 130, t: 395, width: 45, height: 60),
        _positioned(tag: "L16", l: 175, t: 400, width: 30, height: 55),
        _positioned(tag: "R15", l: 205, t: 395, width: 30, height: 55),
        _positioned(tag: "R16", l: 235, t: 395, width: 35, height: 60),
        _positioned(tag: "L17", l: 135, t: 455, width: 40, height: 55),
        _positioned(tag: "R17", l: 205, t: 450, width: 30, height: 60),
        _positioned(tag: "L18", l: 175, t: 455, width: 30, height: 55),
        _positioned(tag: "R18", l: 235, t: 455, width: 30, height: 55),
        _positioned(tag: "L21", l: 145, t: 510, width: 25, height: 55),
        _positioned(tag: "L22", l: 170, t: 510, width: 25, height: 55),
        _positioned(tag: "L25", l: 145, t: 565, width: 25, height: 50),
        _positioned(tag: "L26", l: 170, t: 565, width: 25, height: 50),
        _positioned(tag: "R21", l: 205, t: 510, width: 25, height: 55),
        _positioned(tag: "R22", l: 230, t: 510, width: 25, height: 55),
        _positioned(tag: "R25", l: 200, t: 565, width: 25, height: 50),
        _positioned(tag: "R26", l: 225, t: 565, width: 30, height: 50),
        _positioned(tag: "R29", l: 205, t: 615, width: 50, height: 48),
        _positioned(tag: "R30", l: 210, t: 663, width: 50, height: 48),
        _positioned(tag: "L29", l: 145, t: 612, width: 50, height: 48),
        _positioned(tag: "L30", l: 140, t: 660, width: 50, height: 48),
      ];
}
