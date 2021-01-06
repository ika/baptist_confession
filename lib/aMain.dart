import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bMain.dart';
import 'cDetailPage.dart';
import 'dDetailPage.dart';
import 'dbHelper.dart';
import 'dbModel.dart';
import 'aDetailPage.dart';
import 'eMain.dart';
import 'fDetailPage.dart';

int r;

DBProvider dbProvider = DBProvider();

Future<int> _read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'routs';
  return prefs.getInt(key) ?? 0;
}

_save(int r) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'routs';
  final value = r;
  prefs.setInt(key, value);
}

class AMain extends StatefulWidget {
  @override
  _AMainState createState() => _AMainState();
}

class _AMainState extends State<AMain> {
  List<Chapter> chapters = List<Chapter>();

  @override
  void initState() {
    super.initState();

    _read().then((value) {
      r = value;
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
        future: dbProvider.getTitleList('atexts'),
        builder: (context, AsyncSnapshot<List<Chapter>> snapshot) {
          if (snapshot.hasData) {
            chapters = snapshot.data;
            return showChapterList(chapters, context);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  showChapterList(List<Chapter> chapters, context) {
    ListTile makeListTile(chapters, int index) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        // leading: Container(
        //   padding: EdgeInsets.only(right: 12.0),
        //   decoration: new BoxDecoration(
        //       border: new Border(
        //           right: new BorderSide(width: 1.0, color: Colors.white24))),
        //   child: Icon(Icons.autorenew, color: Colors.white),
        // ),
        title: Text(
          chapters[index].chap,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.white),
                    text: " " + chapters[index].title),
              ),
            ),
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () {
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        (r == 0) ? ADetailPage(index) : FDetailPage(index)));
          });
        });

    Card makeCard(chapters, int index) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(chapters, index),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: chapters == null ? 0 : chapters.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(chapters, index);
        },
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(64, 75, 96, .9),
      title: Text('Baptist Confession'),
      // actions: <Widget>[
      //  IconButton(
      //    icon: Icon(Icons.list_sharp),
      //    onPressed: () {},
      //  )
      // ],
    );

    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext bc) {
            return Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Wrap(
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Wrap(
                                children: [
                                  Column(children: [
                                    new ListTile(
                                        leading: new Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.blueGrey),
                                        title: new Text('Preface'),
                                        onTap: () => {
                                              Navigator.pop(context),
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            CDetailPage(0)));
                                              }),
                                            }),
                                    new ListTile(
                                        leading: new Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.blueGrey,
                                        ),
                                        title: new Text('Ecumenical Creeds'),
                                        onTap: () => {
                                              Navigator.pop(context),
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            BMain()));
                                              }),
                                            }),
                                    new ListTile(
                                        leading: new Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.blueGrey),
                                        title: new Text('The Five Points'),
                                        onTap: () => {
                                              Navigator.pop(context),
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            DDetailPage(0)));
                                              }),
                                            }),
                                    new ListTile(
                                        leading: new Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.blueGrey),
                                        title: r == 0
                                            ? Text('With Proofs')
                                            : Text('Plain Text'),
                                        onTap: () {
                                          if (r == 0) {
                                            _save(1);
                                            setState(() {
                                              r = 1;
                                            });
                                          } else {
                                            _save(0);
                                            setState(() {
                                              r = 0;
                                            });
                                          }
                                          Navigator.pop(context);
                                        }),
                                    new ListTile(
                                        leading: new Icon(Icons.bookmarks,
                                            color: Colors.blueGrey),
                                        title: new Text('Bookmarks'),
                                        onTap: () => {
                                              Navigator.pop(context),
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            EMain()));
                                              }),
                                            }),
                                    new ListTile(
                                        leading: new Icon(Icons.share,
                                            color: Colors.blueGrey),
                                        title: new Text('Share this App'),
                                        onTap: () => {
                                              Navigator.pop(context),
                                              Share.share(
                                                  'The Baptist Confession https://play.google.com/store/apps/details?id=org.armstrong.ika.baprist_confession')
                                            }),
                                  ]),
                                ],
                              )),
                        ]),
                  ],
                ));
          });
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: new Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
