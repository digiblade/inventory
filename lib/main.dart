import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Productform.dart';
import 'package:inventory/datamodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inventory Billing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = [];
  fetchProducts() async {
    products = [];
    setState(() {});
    Dio dio = Dio();
    Response res =
        await dio.get("https://inventory.oxlide.co.in/inventory/getProduct");
    if (res.statusCode == 200) {
      final decodedData = res.data as List;
      products = decodedData
          .map((data) => Product(
              data['product_name'] as String,
              data['product_description'] as String,
              data['product_mrp'],
              data['product_selling_price']))
          .toList();
      setState(() {}); //
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Wrap(
                    alignment: WrapAlignment.center,
                    children: products
                        .map(
                          (product) => GestureDetector(
                            onDoubleTap: () => _showPopup(context, product),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Column(
                                    children: [
                                      Text(
                                        product.productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        product.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "₹${product.mrp} MRP/-",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "₹${product.sellingPrice}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.green,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          "Add to card",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormPopup(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  addForm(context, String name, String description, double mrp,
      double sellingPrice) async {
    Dio dio = Dio();
    Response res = await dio
        .post("https://inventory.oxlide.co.in/inventory/addProduct", data: {
      "product_name": name,
      "product_description": description,
      "product_sku": "",
      "product_mrp": mrp,
      "product_selling_price": sellingPrice,
      "product_purchase_date": 0,
      "product_expiry": 0,
    });
    Navigator.of(context).pop();
    fetchProducts();
  }

  _showFormPopup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the popup content
        return AlertDialog(
          title: const Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProductForm(
                onSubmit: (String name, String description, double mrp,
                        double sellingPrice) =>
                    addForm(
                  context,
                  name,
                  description,
                  mrp,
                  sellingPrice,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Product popup
_showPopup(context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Return the popup content
      return AlertDialog(
        title: Text(product.productName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.description,
              style: const TextStyle(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${product.mrp} MRP/-",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "₹${product.sellingPrice}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

//add product form``

