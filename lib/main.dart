import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

/* 
 I dont have mac to implement AdaptiveView.it will as same as andorid devices. 
 This is an overall Material design bas3d on Android.

*/

void main() {
  /*
  // force stay in protraitMode. But we will do some config 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expences",

      /// visible in background task
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  button: TextStyle(color: Colors.white),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

//we need StatefulWidget because it gonna update UI
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: "t1", title: "milk", amount: 70, date: DateTime.now()),
    // Transaction(id: 't2', title: 'mango', amount: 23, date: DateTime.now())
  ];

/*
  this is getter used in flutter(also other languages)
  retrun list of Transaction of week
  week start today and go through last 7 days.
  Duration takes parameter. 
   */
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((trans) {
      return trans.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }


/* This funtion is for adding new transaction to list*/ 
  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTransaction = Transaction(
        amount: amount,
        title: title,
        date: dateTime,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }


/* This funtion is for deleting transaction from list*/ 
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }


/* Show bottomshit dialog for new entry */ 
  void showTransactionDialog(BuildContext contex) {
    showModalBottomSheet(
      context: contex,
      builder: (bctx) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  //Test purpose to get more width
  void showTXDialog(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (buildContex) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                width: width - 10,
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: AlertDialog(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  contentPadding: EdgeInsets.all(0.0),
                  content: NewTransaction(_addNewTransaction),
                  actions: <Widget>[],
                ),
              ),
            ]),
          );
        });
  }

  //todo: make final with width=max-20
  void showDialogTx(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.all(0.0),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  // var height = MediaQuery.of(context).size.height;
                  // var width = MediaQuery.of(context).size.width;
                  return Container(
                    // height: height - 200,
                    // width: width - 10,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          NewTransaction(_addNewTransaction),
                        ]),
                  );
                },
              ),
            ));
  }

  /* chart show 
    this value deside where as we wanna show both chart and list at the time 
   */
  bool _showChart = false;



  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Personal Expences",
        style: TextStyle(fontFamily: 'Open Sans'),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showTransactionDialog(context),
        )
      ],
    );

    var availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final transListWidget = Container(
      height: availableHeight * .7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // this If condition is special in v2.3.0 , dont use any paranthesis {}
          if (!isLandscape)
            Container(
              height: availableHeight * .3,
              child: Chart(_recentTransactions),
            ),
          if (!isLandscape)
            transListWidget,

          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Show Chart"),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),

          if (isLandscape)
            _showChart
                ? Container(
                    height: availableHeight * .7,
                    child: Chart(_recentTransactions))
                : transListWidget
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // onPressed: () => showTransactionDialog(context),
        onPressed: () => showDialogTx(context), // failed to get more width
      ),
    );
  }
}
