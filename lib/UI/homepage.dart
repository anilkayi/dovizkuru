import 'package:dovizkuru/UI/homepage_vm.dart';
import 'package:dovizkuru/const/const.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  String para = "TRY";

  HomePage(this.para);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool aramayap = false;
  String? aramaKelimesi;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          HomePageVm(context: context, para: widget.para),
      child: Consumer<HomePageVm>(builder: (context, value, child) {
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: buildAppBar(value),
            body: value.mods == Mod.LOADING
                ? Center(child: CircularProgressIndicator())
                : value.mods == Mod.ERROR
                    ? Text('Error')
                    : buildGridView(value));
      }),
    );
  }

  AppBar buildAppBar(HomePageVm value) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: aramayap
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramayap = false;
                    });
                  },
                  icon: Icon(Icons.cancel_outlined),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramayap = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
        )
      ],
      centerTitle: true,
      title: aramayap
          ? TextField(
              controller: _controller,
              onSubmitted: (value) {
                setState(() {
                  aramayap = false;
                  aramaKelimesi = value;
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(aramaKelimesi.toString())));
              })
          : value.mods == Mod.LOADING
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : value.mods == Mod.ERROR
                  ? Text(
                      'Yanlış Para Birimi Girdiniz,tekrar giriniz.',
                      style: kYaziTipi(),
                    )
                  : Text(value.getDovizValue!.baseCode.toString()),
      shadowColor: Colors.white,
      backgroundColor: Colors.transparent,
    );
  }

  GridView buildGridView(HomePageVm value) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: value.dovizListesi.length,
        itemBuilder: (context, index) {
          return value.mods == Mod.LOADING
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : value.mods == Mod.ERROR
                  ? Center(
                      child: Text('ERROR'),
                    )
                  : buildCard(value, index);
        });
  }
}
