 class Item {
   final String name;
   final String category;
   final double price;
   final DateTime date;

   const Item({
     required this.name,
     required this.category,
     required this.price,
     required this.date,
   });

   factory Item.fromMap(Map<String,dynamic> map) {
     final properties = map['properties'] as Map<String, dynamic>;
     final dateStr = properties['Дата']?['date']?['start'];
     return Item(
       name: properties['Имя']?['title']?[0]?['plain_text'] ?? '?',
       category: properties['Категория']?['select']?['name'] ?? 'Разное',
       price: (properties['Цена']?['number'] ?? 0).toDouble(),
       date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),  
     );
   }
 }