import 'package:ShelfScan/models/product.dart';
import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.productModel}) : super(key: key);
  final Product productModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
      },
      child: Column(
        children: [
          ListTile(
            title: Text(
              productModel.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.sku,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${productModel.price}',
                      style: TextStyle(
                        fontSize: 13,
                        color: productModel.isSpecialOffer ? AppColor.yellow:AppColor.greenDEEP,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Text(DateFormat('hh:mm:ss').format(productModel.datePrice)),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Divider(
              thickness: .8,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPopupDialog(BuildContext context) {
    final TextEditingController _controllerRegularPrice = TextEditingController();
    final TextEditingController _controllerSalePrice = TextEditingController();
    final TextEditingController _controllerSku = TextEditingController();
    if (productModel.isSpecialOffer) {
      _controllerSalePrice.text = productModel.price.toString();
    } else{
      _controllerRegularPrice.text = productModel.price.toString();
    }
    _controllerSku.text = productModel.sku;

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(productModel.name),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerRegularPrice,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Обычная цена",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerSalePrice,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Акционная цена",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerSku,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "SKU",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteProduct(productModel.productId, context);
              },
              child: const Text(
                'Удалить',
                style: TextStyle(
                  color: AppColor.redMAIN,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _updateProduct(productModel.productId, _controllerRegularPrice.text,
                    _controllerSalePrice.text, _controllerSku.text, context);
              },
              child: const Text(
                'Сохранить',
                style: TextStyle(color: AppColor.greenMAIN),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(int productId, BuildContext context) async {
    try {
      final remoteServices = RemoteServices();
      final response = await remoteServices.deleteProduct(productId);
      if (response == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(response),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      //   Navigator.of(context).pop();
      // } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProduct(int productId, String regularPrice, String salePrice, String sku, BuildContext context) async {
  try {
    final remoteServices = RemoteServices();
    final data = {
      'name': productModel.name,
      'sku': sku,
      'price': {
        'price': productModel.isSpecialOffer ? salePrice : regularPrice,
        'is_special_offer': productModel.isSpecialOffer,
        'date_price': DateFormat('yyyy-MM-dd').format(productModel.datePrice), 
      },
    };
    final response = await remoteServices.updateProduct(productId, data);
    if (response == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(response),
    //       backgroundColor: AppColor.greenMAIN,
    //     ),
    //   );
    //   Navigator.of(context).pop();
    // } else {
      throw Exception('Failed to update product');
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: AppColor.redMAIN,
      ),
    );
  }
}



}
