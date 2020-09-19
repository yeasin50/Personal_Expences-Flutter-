import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var weekCost = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          weekCost += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        "amount": weekCost,
      };
    }).reversed.toList();
  }

  double get totalSpent {
    return recentTransactions.fold(0.0, (sum, item) {
      return sum + item.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
     print(totalSpent);

    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
         padding: EdgeInsets.all(10),
         child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            // return Text('${data['day']} : ${data['amount']}');
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
              label: data['day'],
              spentAmount: data['amount'],
              spentPercent: totalSpent==0.0? 0.0: (data['amount'] as double)/ totalSpent,
            ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
