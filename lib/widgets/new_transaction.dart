import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransactionFun;
  NewTransaction(this.addTransactionFun);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInputControler = TextEditingController();
  final amountInputControler = TextEditingController();

  /* DateTime.now() return the current timeStamp
    if you don't wanna assign simply remove the asigned value(DateTime.now();)

     DateTime selectedDate;
   */
  DateTime selectedDate = DateTime.now();

  void submitInput() {
    final tmptitle = titleInputControler.text;
    final amount = double.parse(amountInputControler.text);

    // if any field is empty it wont go any further
    if (tmptitle.isEmpty || amount <= 0 || selectedDate==null) {
      return;
    }
     widget.addTransactionFun(tmptitle, amount, selectedDate);
    
    Navigator.of(context).pop();
  }

  void _showDatePicker(){
    showDatePicker(
        context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((date){
      if(date== null) return;
      setState(() {
        selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top:10,left: 10,right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom+10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // onChanged: (val) {
                //   inputTitle = val;
                // },
                 onSubmitted: (_) => submitInput,
                controller: titleInputControler,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'amount'),
                keyboardType: TextInputType.number,
                // keyboardType: TextInputType.numberWithOptions(decimal: true), //for ISO
                // onChanged: (val) => amountInput = val,
                controller: amountInputControler,
                onSubmitted: (_) => submitInput,
              ),

              Container(
                height: 60,
                child:Row( children: <Widget>[
                  Expanded( child:Text(
                    selectedDate==null?"No date chosen":
                    'Date: ${DateFormat.yMd().format(selectedDate)}'
                  ),),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Choose Date",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    ),),
                    onPressed: _showDatePicker,
                  ),
                ],
                ),
              ),
              RaisedButton(
                  child: Text("Add Transaction"),
                  // textColor: Theme.of(context).textTheme.button.color,
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: submitInput),
            ],
          ),
        ),
      ),
    );
  }
}
