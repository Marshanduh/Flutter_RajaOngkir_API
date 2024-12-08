part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeVm homeViewModel = HomeVm();

  @override
  void initState() {
    homeViewModel.getProvinceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(
          "Province Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeVm>(
          create: (context) => homeViewModel,
          child: Consumer<HomeVm>(builder: (context, value, _) {
            switch (value.provinceList.status) {
              case Status.loading:
                return Align(
                  alignment: Alignment.center,
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 60.0,
                  ),
                );
              case Status.error:
                return Align(
                  alignment: Alignment.center,
                  child: Text(value.provinceList.message.toString()),
                );
              case Status.completed:
                return ListView.builder(
                    itemCount: value.provinceList.data?.length,
                    itemBuilder: (context, index) {
                      return CardProvince(
                          value.provinceList.data!.elementAt(index));
                    });
              default:
            }
            return Container();
          })),
    );
  }
}
