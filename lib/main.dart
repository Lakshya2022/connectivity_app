import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title:'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key?key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity=Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState(){
    super.initState();
    initConnectivity();

    _connectivitySubscription=_connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose(){
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async{
    late List<ConnectivityResult> result;
    try{
      result =await _connectivity.checkConnectivity();
    } on PlatformException catch(e){
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if(!mounted){
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async{
    setState(() {
      _connectionStatus=result;
    });
    print("Connectivity changed : $_connectionStatus");
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text('Connectivity Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(flex: 2),
          Text('Active Connection types:',style: Theme.of(context).textTheme.headlineMedium,),
          const Spacer(),
          ListView(
            shrinkWrap: true,
            children: List.generate(
              _connectionStatus.length,
                (index) => Center(
                  child: Text(
                    _connectionStatus[index].toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
            )),
          ),
          const Spacer(flex: 2,)
        ],
      ),
    );
  }
}
