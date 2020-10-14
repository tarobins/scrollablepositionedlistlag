// import 'dart:async';
// import 'package:bloc_pattern/bloc_pattern.dart';
// import 'package:flutter/material.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:flutter/foundation.dart';
// import 'bloc/ReadingMessage-bloc.dart';
// import 'model/Message-model.dart';
// import 'LifecycleEventHandler.dart';
//
// class ReadingMessageNotBug extends StatefulWidget {
//   final bool isSearch;
//   final int code;
//   final String title;
//   final String local;
//   final String date;
//   final String translation;
//
//   final String searchText;
//   final int considerInParagraph;
//   final bool isPlural;
//   final int paragraph;
//   final String paragraphSnippet;
//
//   ReadingMessageNotBug({Key key, this.isSearch, this.searchText, this.considerInParagraph, this.isPlural, this.paragraph, this.paragraphSnippet, this.code, this.title, this.local, this.date, this.translation}) : super(key: key);
//
//   @override
//   _ReadingMessageNotBugState createState() => _ReadingMessageNotBugState();
// }
//
// class _ReadingMessageNotBugState extends State<ReadingMessageNotBug> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   ItemScrollController _itemScrollController;
//   ItemPositionsListener _itemPositionListener;
//   final ReadingMessageBloc _bloc = BlocProvider.getBloc<ReadingMessageBloc>();
//   final TextEditingController _textEditingController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   bool _isThemeDark = false;
//   double _fontSize = 0;
//   Future<Message> _getListTextParagraphMessage;
//   Stream<int> _totalParagraphInMessage;
//   Stream<String> _jumpParagraphMsgError;
//   Stream<double> _outValueFontSize;
//
//   @override
//   void initState() {
//     _itemScrollController = ItemScrollController();
//     _itemPositionListener = ItemPositionsListener.create();
//     _getListTextParagraphMessage = _bloc.getListMessages();
//     _totalParagraphInMessage = _bloc.outValueTotalParagraph;
//     _jumpParagraphMsgError = _bloc.outValueJumpParagraphMsgError;
//     _outValueFontSize = _bloc.outValueFontSize;
//     WidgetsBinding.instance.addObserver(
//         LifecycleEventHandler(
//             pauseCallBack: () async {},
//             resumeCallBack: () async {},
//             inactiveCallBack: () async {},
//             suspendingCallBack: () async {}
//         )
//     );
//     super.initState();
//   }
//
//   // Saltar para o parágrafo
//   void _jumpParagraph(context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StreamBuilder<int>(
//             stream: _totalParagraphInMessage,
//             builder: (context, snapshotOutValueTotalParagraphs) {
//               if (snapshotOutValueTotalParagraphs.data == null) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               int totalParagraph = snapshotOutValueTotalParagraphs.data;
//
//               // return object of type Dialog
//               return AlertDialog(
//                 title: new Text("Ir para o parágrafo"),
//                 content: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         TextField(
//                             keyboardType: TextInputType.number,
//                             controller: _textEditingController,
//                             focusNode: _focusNode,
//                             style: TextStyle(color: _isThemeDark ? Colors.white : Colors.black, fontSize: 18),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: _isThemeDark ? Colors.black : Colors.white,
//                               hintText: "digite de 1 a $totalParagraph",
//                               hintStyle: TextStyle(color: Colors.grey),
//                             )
//                         ),
//                         StreamBuilder<String>(
//                             stream: _jumpParagraphMsgError,
//                             builder: (context, snapshotOutValueJumpParagraphMsgError) {
//                               if (snapshotOutValueJumpParagraphMsgError.data == null) {
//                                 return Container();
//                               }
//                               return Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text("${snapshotOutValueJumpParagraphMsgError.data}", style: TextStyle(color: Colors.red)),
//                               );
//                             }
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 actions: <Widget>[
//                   new FlatButton(
//                     child: new Text("Cancelar"),
//                     onPressed: () {
//                       _textEditingController.clear();
//                       _bloc.setJumpParagraphMsgError("");
//                       Navigator.pop(context);
//                     },
//                   ),
//                   new FlatButton(
//                     child: new Text("Ok"),
//                     onPressed: () {
//                       if (_textEditingController.text == "") {
//                         _bloc.setJumpParagraphMsgError("Digite um número maior que 1\ne menor que $totalParagraph");
//                       } else if (int.parse(_textEditingController.text) < 1) {
//                         _bloc.setJumpParagraphMsgError("O número dever ser maior que 1");
//                       } else if (int.parse(_textEditingController.text) > totalParagraph) {
//                         _bloc.setJumpParagraphMsgError("O número dever ser\nmenor que $totalParagraph");
//                       } else {
//                         _itemScrollController.scrollTo(index: int.parse(_textEditingController.text), duration: Duration(milliseconds: 20));
//                         _textEditingController.clear();
//                         _bloc.setJumpParagraphMsgError("");
//                         Navigator.pop(context);
//                       }
//                     },
//                   )
//                 ],
//               );
//             }
//         );
//       },
//     );
//   }
//
//   // Modificar Tamanho da Fonte
//   void _mbsFontSize(context) {
//     showModalBottomSheet(
//         isScrollControlled: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StreamBuilder<double>(
//               stream: _bloc.outValueFontSize,
//               builder: (context, snapshotOutValueFontSize) {
//                 if (snapshotOutValueFontSize.data == null) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 _fontSize = snapshotOutValueFontSize.data;
//                 return Container(
//                     padding: EdgeInsets.only(top: 10),
//                     height: 80,
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[Text("Tamanho da Fonte", style: TextStyle(fontSize: 16))],
//                         ),
//                         StreamBuilder<double>(
//                             initialData: _fontSize,
//                             stream: _outValueFontSize,
//                             builder: (context, snapshotOutValueFontSize) {
//                               if (snapshotOutValueFontSize.data == null) {
//                                 return CircularProgressIndicator();
//                               }
//                               _fontSize = snapshotOutValueFontSize.data;
//                               return Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   FlatButton(
//                                     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
//                                     color: Colors.blue,
//                                     child: Icon(Icons.remove, color: Colors.white),
//                                     onPressed: () {
//                                       _bloc.changeFontSize(_fontSize - 1);
//                                     },
//                                   ),
//                                   SizedBox(width: 25),
//                                   Text("${_fontSize.toInt()}"),
//                                   SizedBox(width: 25),
//                                   FlatButton(
//                                     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
//                                     color: Colors.blue,
//                                     child: Icon(Icons.add, color: Colors.white),
//                                     onPressed: () {
//                                       _bloc.changeFontSize(_fontSize + 1);
//                                     },
//                                   ),
//                                 ],
//                               );
//                             }
//                         ),
//                       ],
//                     )
//                 );
//               }
//           );
//         }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _bloc.getFontSize();
//     _bloc.getTotalParagraph();
//     _textEditingController..addListener(() {
//       _bloc.setJumpParagraphMsgError("");
//     }
//     );
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text("Mensagem"),
//           actions: <Widget>[
//             PopupMenuButton(
//               onSelected: (value){
//                 switch(value) {
//                   case 0 :
//                     _mbsFontSize(context);
//                     break;
//                   case 1 :
//                     _jumpParagraph(context);
//                     break;
//                 }
//               },
//               itemBuilder: (context) {
//                 var list = List<PopupMenuEntry<Object>>();
//                 list.add(
//                   PopupMenuItem(
//                     child: Text("Tamanho da Fonte"),
//                     value: 0,
//                   ),
//                 );
//                 list.add(
//                   PopupMenuDivider(
//                     height: 10,
//                   ),
//                 );
//                 list.add(
//                     PopupMenuItem(
//                       child: Text("Ir para o Parágrafo"),
//                       value: 1,
//                     )
//                 );
//                 return list;
//               },
//             )
//           ],
//         ),
//         body: FutureBuilder<Message>(
//             future: _getListTextParagraphMessage,
//             builder: (context, snapshotGetMessages) {
//
//               if (snapshotGetMessages.hasError) {
//                 return Center(child: Text(snapshotGetMessages.error.toString(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
//               }
//
//               if (snapshotGetMessages.data == null) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               return StreamBuilder<double>(
//                   stream: _outValueFontSize,
//                   builder: (context, snapshotOutValueFontSize) {
//
//                     if (snapshotOutValueFontSize.data == null) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//
//                     _fontSize = snapshotOutValueFontSize.data;
//
//                     return Column(
//                         children: [
//                           Expanded(
//                               child: ScrollablePositionedList.builder(
//                                   initialScrollIndex: 0,
//                                   itemScrollController: _itemScrollController,
//                                   itemPositionsListener: _itemPositionListener,
//                                   itemCount: snapshotGetMessages.data.paragraphs.length,
//                                   itemBuilder: (context, index) {
//
//                                     if (snapshotGetMessages.data.paragraphs.length > 0) {
//                                       if(index == 0){
//
//                                         return Container(
//                                           decoration: new BoxDecoration(color: _isThemeDark ? Colors.black : Colors.white, border: new Border(bottom: BorderSide(color: _isThemeDark ? Colors.black : Colors.grey))),
//                                           padding: const EdgeInsets.only(bottom: 7, top: 7),
//                                           alignment: FractionalOffset.center,
//                                           child: Center(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Text('${snapshotGetMessages.data.title}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
//                                                 Text('${snapshotGetMessages.data.place}', textAlign: TextAlign.center),
//                                                 Text('${snapshotGetMessages.data.date}', textAlign: TextAlign.center),
//                                                 Text("Tradução: ${snapshotGetMessages.data.translation}", textAlign: TextAlign.center),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//
//                                       } else {
//
//                                         index = index - 1;
//                                         String numberParagraph = snapshotGetMessages.data.paragraphs[index].number.toString();
//                                         String textParagraph = snapshotGetMessages.data.paragraphs[index].text.toString();
//                                         String textPrgNoNumAndTab = textParagraph.replaceAll(new RegExp(r'^[\d-\t]+'), "");
//
//                                         return Container(
//                                             child: GestureDetector(
//                                                 onLongPress: () {
//
//                                                 },
//                                                 onTap: () {
//
//                                                 },
//                                                 child: Padding(
//                                                     padding: const EdgeInsets.only(left: 12, top: 2, right: 12, bottom: 2),
//                                                     child: Container(
//                                                       child: RichText(
//                                                         text: TextSpan(
//                                                             children: [
//                                                               TextSpan(text: numberParagraph, style: TextStyle(inherit: true, fontSize: _fontSize, color: Colors.blue)),
//                                                               TextSpan(text: "  " + textPrgNoNumAndTab, style: TextStyle(fontSize: _fontSize, color: _isThemeDark ? Colors.white : Colors.black))
//                                                             ]
//                                                         ),
//                                                       ),
//                                                     )
//                                                 )
//                                             )
//                                         );
//                                       }
//                                     } else {
//                                       return Container();
//                                     }
//                                   }
//                               )
//                           )
//                         ]
//                     );
//                   }
//               );
//             }
//         )
//     );
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     _textEditingController.dispose();
//   }
// }
