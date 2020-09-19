import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function delTransaction;
  TransactionList(this._userTransactions, this.delTransaction);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var isLandspace = mediaQuery.orientation == Orientation.landscape;

    return _userTransactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Add Data",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height:
                      20, // sizebox use for spacecing without taking any child
                ), // useful for spacecing
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/smile.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(children: <Widget>[
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: _userTransactions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text('\$${_userTransactions[index].amount}'),
                        ),
                      ),
                    ),
                    // trailing: Icon(Icons.title),
                    title: Text(
                      _userTransactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(_userTransactions[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 420
                        ? FlatButton.icon(
                            label: Text("Delete"),
                            icon: Icon(
                              Icons.delete,
                            ),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () =>
                                delTransaction(_userTransactions[index].id),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () =>
                                delTransaction(_userTransactions[index].id),
                          ),
                  ),
                );
              },
            ),

/* this will help to add one more extra space for floatingActionButton
    Don't use any {}  in if statement , this comes in flutter V2.3.0*/
            if (!isLandspace)
              SizedBox(
                height: mediaQuery.size.height * .08,
              ),
            if (isLandspace)
              SizedBox(
                height: mediaQuery.size.height * .03,
              )
          ]);
  }
}
