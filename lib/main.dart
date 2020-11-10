import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Socket socket;
  var mTextMessageController = TextEditingController();

  List _messages = [];
  _log(String message) {
    print(message);
    _messages.add(message);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    socket = io('http://onlylogistics-core.herokuapp.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.on('connect', (_) {
      _log('Websocket connect');
    });

    socket.on("received-message", (data) => _log(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing Socket.io"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Websockets"),
            SizedBox(height: 10),
            ListView.builder(
              itemBuilder: (cx, i) {
                return Text(_messages[i]);
              },
              itemCount: _messages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            )
          ],
        ),
      ),
    );
  }
}
