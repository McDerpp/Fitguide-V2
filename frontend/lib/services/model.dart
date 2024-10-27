import 'dart:convert';

import 'package:frontend/account.dart';
import 'package:frontend/models/trainingProgress.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ModelTrainingService {
  static String baseUrl = "${api.baseUrl}/api/models/";

  static Future<List<TrainingProgress>> getUserTrainingProgress() async {
    final response =
        await http.get(Uri.parse('${baseUrl}get_all_training/${setup.id}/'));

    List<dynamic> jsonList = json.decode(response.body);

    return jsonList.map((json) => TrainingProgress.fromJson(json)).toList();
  }

  static Future<List<WebSocketChannel>> webSocketConnectAll(
      List<String> taskIdList) async {
    print("connecting to websocket");
    final List<WebSocketChannel> _channelList = [];

    taskIdList.forEach((taskId) {
      print("taskId->$taskId");
      WebSocketChannel channel = WebSocketChannel.connect(
          Uri.parse('${api.webSocketUrl}/ws/task-status/${taskId}/'));
      _channelList.add(channel);
    });

    print("channel--->$_channelList");

    return _channelList;
  }

  static Future<WebSocketChannel> webSocketConnectSingle(String taskId) async {

    WebSocketChannel channel = WebSocketChannel.connect(
        Uri.parse('${api.webSocketUrl}/ws/task-status/${taskId}/'));

    return channel;
  }


  







}
