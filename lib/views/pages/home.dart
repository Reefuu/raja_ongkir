part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];

  bool isLoading = false;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
      });
    });
  }

  dynamic ProvOriginID;
  dynamic ProvOrigin;

  dynamic ProvDestID;
  dynamic ProvDest;

  dynamic DataCity;
  dynamic CityID;
  dynamic CityOri;

  dynamic CityDestData;
  dynamic CityDestID;
  dynamic CityDest;

  Future<List<City>> getCities(var provId, var originORdestination) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
        if (originORdestination == 'origin') {
          isLoadingCityOrigin = false;
        } else {
          isLoadingCityDestination = false;
        }
      });
    });

    return city;
  }

  var selectedCourier = 'jne';
  List<Costs> costData = [];

  Future<dynamic> getCost(
      var courier, var origin, var destination, var weight) async {
    dynamic costs;
    await MasterDataService.getCost(origin, destination, weight, courier)
        .then((value) {
      setState(() {
        costs = value;
      });
      isLoading = false;
    });

    return costs;
  }

  var weight = 0;

  @override
  void initState() {
    super.initState();
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Raja Ongkir"),
        centerTitle: true,
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: DropdownButton(
                                  items: [
                                    DropdownMenuItem(
                                      value: 'jne',
                                      child: Text('JNE'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'pos',
                                      child: Text('POS'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'tiki',
                                      child: Text('TIKI'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourier = value as String;
                                    });
                                  },
                                  value: selectedCourier,
                                  isDense: true,
                                  isExpanded: false,
                                ),
                              ),
                              SizedBox(width: 30),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Berat (gr)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      weight = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Origin",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: provinceData.isEmpty
                                    ? uiloading.loadingSmall()
                                    : DropdownButton(
                                        items: provinceData
                                            .map((Province province) {
                                          return DropdownMenuItem(
                                            value: province.provinceId,
                                            child:
                                                Text(province.province ?? ""),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            ProvOriginID = value;
                                            isLoadingCityOrigin = true;
                                            CityOri = null;
                                            DataCity = getCities(
                                                ProvOriginID, 'origin');
                                          });
                                          CityID = null;
                                        },
                                        value: ProvOriginID,
                                        isExpanded: true,
                                        hint: ProvDest == null
                                            ? Text('Select Province')
                                            : Text(ProvDest.province),
                                      ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: DataCity,
                                  builder: (context, snapshot) {
                                    if (isLoadingCityOrigin) {
                                      return uiloading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: CityOri,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: CityOri == null
                                            ? Text('Select Town')
                                            : Text(CityOri.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            CityOri = newValue;
                                            CityID = CityOri.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: CityDest,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: Text('Select Town'),
                                        items: [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Destination",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: provinceData.isEmpty
                                    ? uiloading.loadingSmall()
                                    : DropdownButton(
                                        items: provinceData
                                            .map((Province province) {
                                          return DropdownMenuItem(
                                            value: province.provinceId,
                                            child:
                                                Text(province.province ?? ""),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            ProvDestID = value;
                                            isLoadingCityDestination = true;
                                            CityDest = null;
                                            CityDestData = getCities(
                                                ProvDestID, 'destination');
                                            CityDestID = null;
                                          });
                                        },
                                        value: ProvDestID,
                                        isExpanded: true,
                                        hint: ProvDest == null
                                            ? Text('Select Province')
                                            : Text(ProvDest.province),
                                      ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: CityDestData,
                                  builder: (context, snapshot) {
                                    if (isLoadingCityDestination) {
                                      return uiloading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: CityDest,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: CityDest == null
                                            ? Text('Select Town')
                                            : Text(CityDest.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            CityDest = newValue;
                                            CityDestID = CityDest.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada Data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: CityDest,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: Text('Select Town'),
                                        items: [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (CityDestID == null ||
                                      CityID == null ||
                                      weight < 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please Fill In all necesasary informations!'),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    setState(() async {
                                      costData = await getCost(
                                        selectedCourier,
                                        CityID,
                                        CityDestID,
                                        weight,
                                      );
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                child: Text('Calculate'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: costData.isEmpty || costData[0].cost.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("Tidak Ada Data"),
                            )
                          : ListView.builder(
                              itemCount: costData.length,
                              itemBuilder: (context, index) {
                                return CardProvince(costData[index]);
                              })),
                ),
              ],
            ),
            isLoading == true ? uiloading.loadingBlock() : Container()
          ],
        ),
      ),
    );
  }
}
