import 'package:dovizkuru/UI/homepage.dart';
import 'package:dovizkuru/const/const.dart';
import 'package:dovizkuru/data/dovizdata.dart';
import 'package:dovizkuru/model/dovizmodel.dart';
import 'package:flutter/material.dart';

enum Mod { LOADING, ERROR, DONE }

class HomePageVm extends ChangeNotifier {
  DovizApiData getDovizData = DovizApiData();
  Doviz? getDovizValue;
  Mod _mods = Mod.LOADING;
  List<DovizListem> dovizListesi = <DovizListem>[];
  String para = "TRY";
  HomePageVm({required BuildContext context, required this.para}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      currentDoviz();
    });
  }

  Mod get mods => _mods;

  currentDoviz() async {
    try {
      getDovizValue = await getDovizData.getCurrentDoviz(para.toString());
      notifyListeners();
      _mods = Mod.DONE;
      getDovizValue!.conversionRates!.forEach((key, value) {
        dovizListesi.add(DovizListem(paraAdi: key, paraDegeri: value));
      });
    } catch (e) {
      print(e);
      _mods = Mod.ERROR;
    }
  }
}

Card buildCard(HomePageVm value, int index) {
  return Card(
    shadowColor: Colors.white,
    color: Colors.black12,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "1" + " " + value.getDovizValue!.baseCode.toString(),
              style: kYaziTipi(),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "=",
              style: kYaziTipi(),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              value.dovizListesi[index].paraDegeri.toString() +
                  " " +
                  value.dovizListesi[index].paraAdi.toString(),
              style: kYaziTipi(),
            ),
          ],
        )
      ],
    ),
  );
}
