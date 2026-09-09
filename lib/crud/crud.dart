import 'package:task_manager/crud/product_controller.dart';
import 'package:task_manager/crud/product_model.dart';
import 'package:flutter/material.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  ProductController productController = ProductController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    await productController.getProduct();
    setState(() {});
  }

  void productDialog(bool isUpdate, {Data? data}) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productIMGController = TextEditingController();
    TextEditingController productQTYController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    if (isUpdate) {
      productNameController.text = data!.productName.toString();
      productIMGController.text = data.img.toString();
      productQTYController.text = data.qty.toString();
      productUnitPriceController.text = data.unitPrice.toString();
      productTotalPriceController.text = data.totalPrice.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isUpdate ? 'Edit product' : 'Add product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: productIMGController,
              decoration: InputDecoration(
                labelText: 'Image',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: productQTYController,
              decoration: InputDecoration(
                labelText: 'QTY',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: productUnitPriceController,
              decoration: InputDecoration(
                labelText: 'Unite price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(
                labelText: 'Total price',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () async {
              if (isUpdate) {
                productController.updateProduct(
                  Data(
                    productName: productNameController.text,
                    img: productIMGController.text,
                    qty: int.parse(productQTYController.text),
                    unitPrice: int.parse(productUnitPriceController.text),
                    totalPrice: int.parse(productTotalPriceController.text),
                  ),
                  data!.sId.toString(),
                );

                await fetchData();
              } else {
                productController.createProduct(
                  Data(
                    productName: productNameController.text,
                    img: productIMGController.text,
                    qty: int.parse(productQTYController.text),
                    unitPrice: int.parse(productUnitPriceController.text),
                    totalPrice: int.parse(productTotalPriceController.text),
                  ),
                );
              }

              await fetchData();
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products'), backgroundColor: Colors.blue),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          final product = productController.products[index];

          return Column(
            children: [
              SizedBox(
                height: 190,
                child: Image.network(product.img.toString()),
              ),
              Text(
                product.productName.toString(),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text('Price: ${product.unitPrice}'),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      productDialog(true, data: product);
                    },
                    icon: Icon(Icons.edit_note, color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: () {
                      productController
                          .deleteProduct(product.sId.toString())
                          .then((onValue) async {
                            if (onValue) {
                              await fetchData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Product Deleted...!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('something wrong...!')),
                              );
                            }
                          });
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productDialog(false);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
