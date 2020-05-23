import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart';


class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemWidget(this.orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false ;

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.orderItem.amount.toStringAsFixed(2)}'),
            //subtitle: Chip(avatar: Icon(Icons.access_time), label: Text('${DateFormat('dd MM yyyy').format(orderItem.dateTime)}')),
            subtitle:Wrap(crossAxisAlignment: WrapCrossAlignment.center,spacing: 5,runSpacing: 20,
              children: <Widget>[ Icon(Icons.access_time),Text('${DateFormat('dd MM yyyy').format(widget.orderItem.dateTime)}')],),
            trailing: IconButton(onPressed:(){ setState(() {_expanded =! _expanded ;});}, icon: Icon(Icons.expand_more),),
          ),

          _expanded ?
            Container(
//            margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: 0,
                   // sortAscending: true,
                  columnSpacing: 1,
                    columns: [
                      DataColumn(label: Text('product Name',) ),
                      DataColumn(label: FittedBox(child: Text('\$price x1')) ),
                      DataColumn(label: FittedBox(child: Text('quantity')) ),
                      DataColumn(label: Text('\$ Total',) ),
                    ],
                    rows: widget.orderItem.products.map(
                            (product){
                          return DataRow(cells: <DataCell>[
                            DataCell(Text(product.title , style: Theme.of(context).textTheme.title,),),
                            DataCell( Text('\$'+product.price.toStringAsFixed(2))),
                            DataCell(Text('x${product.quantity}'),),
                            DataCell(Text('\$'+(product.price*product.quantity).toStringAsFixed(2) ,style: TextStyle(fontSize: 20),),),
                          ] );
                        }).toList(), ),
              ),
//              child: Table(
////                columnWidths: {
////                  1: FixedColumnWidth(0.2),
////                  2: FixedColumnWidth(0.2),
////                  3: FixedColumnWidth(0.1),
////                  4: FixedColumnWidth(0.3),
////                },
//                children: [
//                  TableRow(children:[
//                    Text('product Name', style: Theme.of(context).textTheme.title,),
//                    Text('\$ price x1'),
//                    Text('quantity'),
//                    Text('\$ Total',),
//                  ] ),
//                  ...widget.orderItem.products.map(
//                          (product){
//                        return TableRow(children:[
//                          Text(product.title , style: Theme.of(context).textTheme.title,),
//                          Text('\$'+product.price.toStringAsFixed(2)),
//                          Text('x${product.quantity}'),
//                          Text('\$'+(product.price*product.quantity).toStringAsFixed(2) ,style: TextStyle(fontSize: 20),),
//                        ] );
//                      }).toList(),
//                ]
//              ),


//              child: ListView(
//                  children: widget.orderItem.products.map(
//                          (product){
//                            return ListTile(title: Text(product.title,));
//                          }).toList()
//              )
            ): const SizedBox(height:1) ,
        ],
      ),
    );
  }
}
