import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollablepositionedlistlag/_message/model/Message-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingMessageBloc extends BlocBase {

  List<Message> listTextParagraph = [];
  double _fontSize = 0;
  int indexReading;

  //============================================= Controller ListMsg =================================================
  Future<Message> getListMessages() async {
    String url = 'https://tabernaculodafe.org.br/busca/json_v0002/19491225.json';
    final response = await http.get(Uri.encodeFull(url), headers: {"Accept":"application/json"});
    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);
      return Message.fromJson(jsonDecode(source));
    } else {
      throw Exception('Falha a abrir a Mensagem');
    }
  }

//================================================= Font Size ========================================================
  var _controllerFontSize = BehaviorSubject<double>.seeded(20);
  Sink<double> get inValueFontSize=> _controllerFontSize.sink;
  Stream<double> get outValueFontSize => _controllerFontSize.stream;

  changeFontSize(double size) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('readingMessage_fontSize', size);
    inValueFontSize.add(size);
  }

  getFontSize() async{
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('readingMessage_fontSize');
    inValueFontSize.add(_fontSize != null ? _fontSize : 20);
  }

  //============================================ Jump Error Message =================================================
  var _controllerJumpParagraphMsgError = BehaviorSubject<String>();
  Sink<String> get inValueJumpParagraphMsgError => _controllerJumpParagraphMsgError.sink;
  Stream<String> get outValueJumpParagraphMsgError => _controllerJumpParagraphMsgError.stream;

  setJumpParagraphMsgError(String text) async{
    inValueJumpParagraphMsgError.add(text);
  }

//=================================== Color Background LongPress For Share =========================================
  var _controllerTotalParagraph = BehaviorSubject<int>();
  Sink<int> get inValueTotalParagraph => _controllerTotalParagraph.sink;
  Stream<int> get outValueTotalParagraph => _controllerTotalParagraph.stream;

  getTotalParagraph() async{
    inValueTotalParagraph.add(148);
  }

  @override
  void dispose() {
    _controllerTotalParagraph.close();
    _controllerJumpParagraphMsgError.close();
    _controllerFontSize.close();
    super.dispose();
  }
}