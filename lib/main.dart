import 'package:budget_tracker/budget_repository.dart';
import 'package:budget_tracker/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'failure_model.dart';
import 'item_model.dart';

void main() async{
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Budget Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({ Key? key }) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Tracker"),
      ),
       body: RefreshIndicator(
         onRefresh: () async {
           _futureItems = BudgetRepository().getItems();
           setState(() {
             
           });
         },
         child: FutureBuilder<List<Item>>(
            future: _futureItems,
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                 final items = snapshot.data!;
                 return ListView.builder(
                   itemCount: items.length + 1,
                   itemBuilder: (BuildContext context,int index) {
                     if (index == 0) return SpendingChart(items: items);
                     
                     final item = items[index-1];
                     return Container(
                       margin: const EdgeInsets.all(8.0),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(10.0),
                         border: Border.all(
                           width: 2.0,
                           color: getCategoryColor(item.category),
                         ),
                         boxShadow: const [
                           BoxShadow(
                             color: Colors.black26,
                             offset: Offset(0, 2),
                             blurRadius: 6.0,
                           )
                         ]
                        
                       ),
                       child: ListTile(
                         title: Text(item.name),
                         subtitle: Text(
                           '${item.category} * ${DateFormat.yMd().format(item.date)}',
                         ),
                         trailing: Text(
                           '-${item.price.toStringAsFixed(2)}\??'
                         ),
                       ),
                     );
                   },
                 );
       
              } else if (snapshot.hasError) {
                final failure = snapshot.error as Failure;
                return Center(child: Text(failure.message));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
       ),
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case '??????????????????????': return Colors.red[400]!;
    case '??????': return Colors.green[400]!;
    case '????????????': return Colors.blue[400]!;
    case '??????????????????': return Colors.purple[400]!;
    default: return Colors.orange[400]!;

  }
}