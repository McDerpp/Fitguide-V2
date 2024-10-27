import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TaskStatusPage extends StatefulWidget {
  @override
  _TaskStatusPageState createState() => _TaskStatusPageState();
}

class _TaskStatusPageState extends State<TaskStatusPage> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.16:8000/ws/task-status/'),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Status'),
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Text('Status: ${snapshot.data}');
          }
          return Text('No data received');
        },
      ),
    );
  }
}
