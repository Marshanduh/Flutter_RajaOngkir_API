part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeVm homeViewModel = HomeVm();

  bool isButtonPressed = false;
  final TextEditingController weightController = TextEditingController();

  dynamic selectedOriginProvince;
  dynamic selectedOriginCity;
  dynamic selectedDestinationProvince;
  dynamic selectedDestinationCity;
  String? selectedCourier;

  @override
  void initState() {
    super.initState();
    homeViewModel.getProvinceOriginList();
    homeViewModel.getProvinceDestinationList();
  }

  void calculateCost() {
    // Validate inputs before calculation
    if (selectedOriginCity == null ||
        selectedDestinationCity == null ||
        weightController.text.isEmpty ||
        selectedCourier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      isButtonPressed = true;
    });

    // Validate weight input to only accept numerical value
    final weightInput = weightController.text;
    final weight = int.tryParse(weightInput);
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Weight must be a valid number')),
      );
      return;
    } else {
      setState(() {
        isButtonPressed =
            true; 
      });
    }

    // Call cost calculation method
    homeViewModel.getCost(
      origin: selectedOriginCity.cityId.toString(),
      originType: 'city',
      destination: selectedDestinationCity.cityId.toString(),
      destinationType: 'city',
      itemWeight: weight,
      courier: selectedCourier!,
    );

    // Debug log for input values
    print('City Origin: ${selectedOriginCity.cityName}');
    print('City Destination: ${selectedDestinationCity.cityName}');
    print('Weight: $weight');
    print('Courier: $selectedCourier');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Calculate Cost",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeVm>(
        create: (context) => homeViewModel,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Courier and Weight Selection
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Courier Dropdown
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCourier,
                            hint: Text('Select Courier'),
                            items: <String>['jne', 'tiki', 'pos']
                                .map((String courier) {
                              return DropdownMenuItem<String>(
                                value: courier,
                                child: Text(courier.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCourier = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        // Weight TextField
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Weight (gram)',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Origin Selection
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Origin',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            // Province Dropdown
                            Expanded(
                              child: Consumer<HomeVm>(
                                builder: (context, value, _) {
                                  switch (value.provinceOriginList.status) {
                                    case Status.loading:
                                      return SpinKitCircle(
                                        color: Colors.blue, 
                                        size: 40.0, 
                                      );
                                    case Status.error:
                                      return Text(value
                                          .provinceOriginList.message
                                          .toString());
                                    case Status.completed:
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedOriginProvince,
                                        hint: Text('Select Province'),
                                        items: value.provinceOriginList.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province province) {
                                          return DropdownMenuItem(
                                            value: province,
                                            child: Text(
                                                province.province.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOriginProvince = newValue;
                                            selectedOriginCity = null;
                                            homeViewModel.getCityOriginList(
                                                selectedOriginProvince
                                                    .provinceId);
                                          });
                                          if (newValue != null) {
                                            value.setCityOriginList(
                                                ApiResponse.loading());
                                          }
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            // City Dropdown
                            Expanded(
                              child: Consumer<HomeVm>(
                                builder: (context, value, _) {
                                  switch (value.cityOriginList.status) {
                                    case Status.loading:
                                      return SpinKitCircle(
                                        color: Colors.blue, 
                                        size: 40.0, 
                                      );
                                    case Status.error:
                                      return Text(value.cityOriginList.message
                                          .toString());
                                    case Status.notStarted:
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedOriginCity,
                                        hint: Text('Select City'),
                                        items: [
                                          DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                "Select the province first:)"),
                                          )
                                        ],
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOriginCity = newValue;
                                          });
                                        },
                                      );
                                    case Status.completed:
                                      return DropdownButton<City>(
                                        isExpanded: true,
                                        value: selectedOriginCity,
                                        hint: Text('Select City'),
                                        items: value.cityOriginList.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City city) {
                                          return DropdownMenuItem<City>(
                                            value: city,
                                            child:
                                                Text(city.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOriginCity = newValue;
                                          });
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Destination Selection
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Destination',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            // Province Dropdown
                            Expanded(
                              child: Consumer<HomeVm>(
                                builder: (context, value, _) {
                                  switch (
                                      value.provinceDestinationList.status) {
                                    case Status.loading:
                                      return SpinKitCircle(
                                        color: Colors.blue, 
                                        size: 40.0, 
                                      );
                                    case Status.error:
                                      return Text(value
                                          .provinceDestinationList.message
                                          .toString());
                                    case Status.completed:
                                      return DropdownButton<Province>(
                                        isExpanded: true,
                                        value: selectedDestinationProvince,
                                        hint: Text('Select Province'),
                                        items: value
                                            .provinceDestinationList.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province province) {
                                          return DropdownMenuItem<Province>(
                                            value: province,
                                            child: Text(
                                                province.province.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestinationProvince =
                                                newValue;
                                            selectedDestinationCity = null;
                                            homeViewModel
                                                .getCityDestinationList(
                                                    selectedDestinationProvince
                                                        .provinceId);
                                          });
                                          if (newValue != null) {
                                            value.setCityDestinationList(
                                                ApiResponse.loading());
                                          }
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            // City Dropdown
                            Expanded(
                              child: Consumer<HomeVm>(
                                builder: (context, value, _) {
                                  switch (value.cityDestinationList.status) {
                                    case Status.notStarted:
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestinationCity,
                                        hint: Text('Select City'),
                                        items: [
                                          DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                "Select the province first:)"),
                                          )
                                        ],
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestinationCity = newValue;
                                          });
                                        },
                                      );
                                    case Status.loading:
                                      return SpinKitCircle(
                                        color: Colors.blue, 
                                        size: 40.0, 
                                      );
                                    case Status.error:
                                      return Text(value
                                          .cityDestinationList.message
                                          .toString());
                                    case Status.completed:
                                      return DropdownButton<City>(
                                        isExpanded: true,
                                        value: selectedDestinationCity,
                                        hint: Text('Select City'),
                                        items: value.cityDestinationList.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City city) {
                                          return DropdownMenuItem<City>(
                                            value: city,
                                            child:
                                                Text(city.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestinationCity = newValue;
                                          });
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Calculate Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor:
                          Colors.white, 
                    ),
                    onPressed: calculateCost,
                    child: Text('Calculate Shipping Cost'),
                  ),
                ),

                // Cost Results
                Consumer<HomeVm>(
                  builder: (context, value, _) {
                    // Jika tombol belum ditekan
                    if (!isButtonPressed) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Please input all the requirements',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Setelah tombol ditekan, tetapi input belum lengkap
                    if (selectedOriginCity == null ||
                        selectedDestinationCity == null ||
                        weightController.text.isEmpty ||
                        selectedCourier == null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Please input all requirements',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Loading state
                    if (value.costList.status == Status.loading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                      );
                    }

                    // Error state
                    if (value.costList.status == Status.error) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Error: ${value.costList.message}',
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Completed state
                    if (value.costList.status == Status.completed) {
                      if (value.costList.data != null &&
                          value.costList.data!.isNotEmpty) {
                        return CardCost(costList: value.costList.data!);
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'No cost data available',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    }
                    // Fallback
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }
}
