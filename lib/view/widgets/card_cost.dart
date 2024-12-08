part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final List<Costs> costList;

  const CardCost({Key? key, required this.costList}) : super(key: key);

  @override
  _CardCostState createState() => _CardCostState();
}

class _CardCostState extends State<CardCost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.costList.length,
        itemBuilder: (context, index) {
          final cost = widget.costList[index];
          return Card(
            color: Colors.blue[50],
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              title: Text(
                '${cost.service} - ${cost.description}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Cost: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(cost.cost![0].value)} ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: '\nEstimated Arrival: ${cost.cost![0].etd} day(s)',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
