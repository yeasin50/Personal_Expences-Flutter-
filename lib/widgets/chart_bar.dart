import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spentAmount;
  final double spentPercent;

  ChartBar({this.label, this.spentAmount, this.spentPercent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        return Column(
      children: <Widget>[
        Container(
          height: constraints.maxHeight*0.15,
          child: FittedBox(
            child: Text('\$${spentAmount.toStringAsFixed(0)}'),
          ),
        ),
        SizedBox(
          height: constraints.maxHeight*.05,
        ),
        Container(
          height: constraints.maxHeight*.6,
          width: 10,
          child: Stack(
            // for overlapping we use stack
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                // alignment: AlignmentGeometry.,
                heightFactor: 1 - spentPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 220, 200, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: constraints.maxHeight*.05,
        ),
        Container(
          height: constraints.maxHeight*.15,
          child: FittedBox(
            child: Text(label),)
          ),
      ],
    );
      },
    );

  }
}
