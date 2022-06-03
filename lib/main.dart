import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() => runApp(RutasInicio());

class RutasInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrimeraVentana(),
    );
  }
}

//Creamos la primera ventana con un botón
class PrimeraVentana extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Proyecto'),
        ),
        body: SingleChildScrollView(



          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
                  );
                },
                child: const Text('syncfusion'),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StarWarsData()),
                  );
                },
                child: const Text('api'),
              ),
              /*SingleChildScrollView(
                // wrap with a scrollable widget
                child: Column(
                  children: <Widget>[
                    Expanded(*/
                        TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChartApp(0)),
                          );
                        },
                        child: const Text('radial gauge syncfusion'),
                      ),

                   /* ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                          /*TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmpleadosWidget()),
                              );
                            },
                            child: const Text('Empleados azure'),
                          ),*/
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmpleadosWidget()),
                  );
                },
                child: const Text('boton prueba'),
              ),
                        ],
                      ),
                    ),

                );

  }
}
//Creamos la segunda ventana con un simple título

//plantilla syncfusion

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: getProductDataSource(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? SfDataGrid(source: snapshot.data, columns: getColumns())
                  : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              );
            },
          ),
        ));
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartApp(productList[0].freight!)),
    );
    //ChartApp (productList[0].freight!);
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'orderID',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Order ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'customerID',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text('Customer ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'employeeID',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Employee ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'orderDate',
          width: 95,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text('Order Date',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'freight',
          width: 65,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Freight')))
    ];
  }

  Future<List<Product>> generateProductList() async {
    var response = await http.get(Uri.parse(
        'https://ej2services.syncfusion.com/production/web-services/api/Orders'));
    var decodedProducts =
    json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> productList = await decodedProducts
        .map<Product>((json) => Product.fromJson(json))
        .toList();
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Product> productList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[3].value).toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[4].value.toStringAsFixed(1),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'orderID', value: dataGridRow.orderID),
        DataGridCell<String>(
            columnName: 'customerID', value: dataGridRow.customerID),
        DataGridCell<int>(
            columnName: 'employeeID', value: dataGridRow.employeeID),
        DataGridCell<DateTime>(
            columnName: 'orderDate', value: dataGridRow.orderDate),
        DataGridCell<double>(columnName: 'freight', value: dataGridRow.freight)
      ]);
    }).toList(growable: false);
  }
}



class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        orderID: json['OrderID'],
        customerID: json['CustomerID'],
        employeeID: json['EmployeeID'],
        orderDate: DateTime.parse(json['OrderDate']),
        shippedDate: DateTime.parse(json['ShippedDate']),
        freight: json['Freight'],
        shipName: json['ShipName'],
        shipAddress: json['ShipAddress'],
        shipCity: json['ShipCity'],
        shipPostelCode: json['ShipPostelCode'],
        shipCountry: json['ShipCountry']);
  }
  Product(
      {required this.orderID,
        required this.customerID,
        required this.employeeID,
        required this.orderDate,
        required this.shippedDate,
        required this.freight,
        required this.shipName,
        required this.shipAddress,
        required this.shipCity,
        required this.shipPostelCode,
        required this.shipCountry});
  final int? orderID;
  final String? customerID;
  final int? employeeID;
  final DateTime? orderDate;
  final DateTime? shippedDate;
  final double? freight;
  final String? shipName;
  final String? shipAddress;
  final String? shipCity;
  final int? shipPostelCode;
  final String? shipCountry;
}

//ventana api widget
class StarWarsData extends StatefulWidget {
  @override
  StarWarsState createState() => StarWarsState();
}

class StarWarsState extends State<StarWarsData> {
  final String url =
      "https://raw.githubusercontent.com/oshju/getafeapi/main/Datos.json";
  List? data;

  Future<String> getSWData() async {
    var res =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody["dates"];
    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("api meteo matics"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: ListView.builder(
            itemCount: data == null ? 0 : data?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Card(
                          child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: <Widget>[
                              Text("value: "),
                              Text(data![index]["value"].toString(),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black87)),
                            ],
                          )),
                    ),
                  ])));
            }));
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }
}

// linkedin login ouath 2.0

/*const String redirectUrl = 'https://www.youtube.com/callback';
const String clientId = '776rnw4e4izlvg';
const String clientSecret = 'rQEgboUHMLcQi59v';

class MyApp extends StatelessWidget {
  const MyApp({final Key key}) : super(key: key);

  // This widget is the root of your application.
  @overridew
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinkedIn demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Auth code')
              ],
            ),
            title: const Text('LinkedIn Authorization'),
          ),
          body: const TabBarView(
            children: [
              LinkedInProfileExamplePage(),
              LinkedInAuthCodeExamplePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInProfileExamplePage extends StatefulWidget {
  const LinkedInProfileExamplePage({final Key key}) : super(key: key);

  @override
  State createState() => _LinkedInProfileExamplePageState();
}

class _LinkedInProfileExamplePageState
    extends State<LinkedInProfileExamplePage> {
  UserObject user;
  bool logoutUser = false;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) => LinkedInUserWidget(
                    appBar: AppBar(
                      title: const Text('OAuth User'),
                    ),
                    destroySession: logoutUser,
                    redirectUrl: redirectUrl,
                    clientId: clientId,
                    clientSecret: clientSecret,
                    projection: const [
                      ProjectionParameters.id,
                      ProjectionParameters.localizedFirstName,
                      ProjectionParameters.localizedLastName,
                      ProjectionParameters.firstName,
                      ProjectionParameters.lastName,
                      ProjectionParameters.profilePicture,
                    ],
                    onError: (final UserFailedAction e) {
                      print('Error: ${e.toString()}');
                      print('Error: ${e.stackTrace.toString()}');
                    },
                    onGetUserProfile: (final UserSucceededAction linkedInUser) {
                      print(
                        'Access token ${linkedInUser.user.token.accessToken}',
                      );

                      print('User id: ${linkedInUser.user.userId}');

                      user = UserObject(
                        firstName:
                        linkedInUser?.user?.firstName?.localized?.label,
                        lastName:
                        linkedInUser?.user?.lastName?.localized?.label,
                        email: linkedInUser?.user?.email?.elements[0]
                            ?.handleDeep?.emailAddress,
                        profileImageUrl: linkedInUser
                            ?.user
                            ?.profilePicture
                            ?.displayImageContent
                            ?.elements[0]
                            ?.identifiers[0]
                            ?.identifier,
                      );

                      setState(() {
                        logoutUser = false;
                      });

                      Navigator.pop(context);
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          LinkedInButtonStandardWidget(
            onTap: () {
              setState(() {
                user = null;
                logoutUser = true;
              });
            },
            buttonText: 'Logout',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('First: ${user?.firstName} '),
              Text('Last: ${user?.lastName} '),
              Text('Email: ${user?.email}'),
              Text('Profile image: ${user?.profileImageUrl}'),
            ],
          ),
        ],
      ),
    );
  }
}

class LinkedInAuthCodeExamplePage extends StatefulWidget {
  const LinkedInAuthCodeExamplePage({final Key key}) : super(key: key);

  @override
  State createState() => _LinkedInAuthCodeExamplePageState();
}

class _LinkedInAuthCodeExamplePageState
    extends State<LinkedInAuthCodeExamplePage> {
  AuthCodeObject authorizationCode;
  bool logoutUser = false;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        LinkedInButtonStandardWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (final BuildContext context) => LinkedInAuthCodeWidget(
                  destroySession: logoutUser,
                  redirectUrl: redirectUrl,
                  clientId: clientId,
                  onError: (final AuthorizationFailedAction e) {
                    print('Error: ${e.toString()}');
                    print('Error: ${e.stackTrace.toString()}');
                  },
                  onGetAuthCode: (final AuthorizationSucceededAction response) {
                    print('Auth code ${response.codeResponse.code}');

                    print('State: ${response.codeResponse.state}');

                    authorizationCode = AuthCodeObject(
                      code: response.codeResponse.code,
                      state: response.codeResponse.state,
                    );
                    setState(() {});

                    Navigator.pop(context);
                  },
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        LinkedInButtonStandardWidget(
          onTap: () {
            setState(() {
              authorizationCode = null;
              logoutUser = true;
            });
          },
          buttonText: 'Logout user',
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Auth code: ${authorizationCode?.code} '),
              Text('State: ${authorizationCode?.state} '),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthCodeObject {
  AuthCodeObject({this.code, this.state});

  final String code;
  final String state;
}

class UserObject {
  UserObject({
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
} */

//busqueda de empleados ejercicio

class EmpleadosWidget extends StatefulWidget {
  @override
  EmpleadosState createState() => EmpleadosState();
}

class EmpleadosState extends State<EmpleadosWidget> {
  final String urlBase =
      'https://apiempleadospgs.azurewebsites.net/api/Empleados';
  final filtroControlador = TextEditingController();
  final filtroFoco = FocusNode();
  List? empleados;
  @override
  void initState() {
    super.initState();
    this.obtenerEmpleados();
  }

  Future<String> obtenerEmpleados([String filtroSalario = ""]) async {
    String url;
    if (filtroSalario.isEmpty)
      url = urlBase;
    else

      url = '${urlBase}Salario/$filtroSalario';
    var res =
        await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    setState(() {
      empleados = json.decode(res.body);
    });
    return 'Empleados obtenidos OK.';
  }

  Container obtenerFila(int indice, String campo) => Container(
      padding: EdgeInsets.only(left: 20),
      child: Row(children: [
        Text("$campo: "),
        Text('${empleados![indice][campo]}',
            style: TextStyle(fontSize: 18.0, color: Colors.purple.shade800))
      ]));
  @override
  Widget build(BuildContext contexto) => Scaffold(
      appBar: AppBar(
          title: Text('Listado de empleados'),
          backgroundColor: Colors.purple.shade800),
      body: Column(children: [
        Container(
            height: 85,
            margin: EdgeInsets.only(top: 6, right: 8, bottom: 0, left: 8),
            child: TextFormField(
                cursorColor: Colors.deepPurple,
                controller: filtroControlador,
                focusNode: filtroFoco,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d'))
                ],
                decoration: InputDecoration(
                    labelText: 'Filtrar por salario',
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    suffixIcon: IconButton(
                        color: Colors.deepPurple,
                        icon: Icon(Icons.search),
                        onPressed: () {
                          obtenerEmpleados(filtroControlador.text);
                          filtroFoco.unfocus();
                        })))),
        Expanded(
            child: ListView.builder(
                itemCount: empleados == null ? 0 : empleados!.length,
                itemBuilder: (BuildContext contexto2, int indice) => Card(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shadowColor: Colors.deepPurple,
                    color:
                        indice % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                    elevation: 3,
                    child: Column(children: [
                      obtenerFila(indice, 'Apellido'),
                      obtenerFila(indice, 'Oficio'),
                      obtenerFila(indice, 'Salario')
                    ]))))
      ]));
}

//radial gauge syncfusion

class ChartApp extends StatelessWidget {
  double valor=0;
  ChartApp(double dato){
    valor=dato;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Container(
                    child: SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
        GaugeRange(
            startValue: 0,
            endValue: 50,
            color: Colors.green,
            startWidth: 10,
            endWidth: 10),
        GaugeRange(
            startValue: 50,
            endValue: 100,
            color: Colors.orange,
            startWidth: 10,
            endWidth: 10),
        GaugeRange(
            startValue: 100,
            endValue: 150,
            color: Colors.red,
            startWidth: 10,
            endWidth: 10)
      ], pointers: <GaugePointer>[
        NeedlePointer(value: valor)
      ], annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Container(
                child: Text(valor.toString(),
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
            angle: 90,
            positionFactor: 0.5)
      ])
    ])))));
  }
}
