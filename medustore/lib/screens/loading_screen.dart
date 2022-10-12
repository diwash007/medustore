import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // getData();
  }

  // Future<dynamic> getData() async {
  //   NetworkHelper networkHelper = NetworkHelper();
  //   Map<dynamic, dynamic> shareData = await networkHelper.getData();
  //   updateData(shareData);
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  //     return HomeScreen(shareData: shareData);
  //   }));
  // }

  // Future<void> updateData(Map shareData) async {
  //   var shares = await DatabaseHelper.instance.getShares();
  //   for (var share in shares) {
  //     if (shareData[share.company]['closing'] != null) {
  //       await DatabaseHelper.instance.update(
  //         Share(
  //           id: share.id,
  //           company: share.company,
  //           kitta: share.kitta,
  //           closing: shareData[share.company]['closing'],
  //           diff: shareData[share.company]['diff'],
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Color(0xFF592ee1), Color(0xFFb836d9)]),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Medustore',
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
