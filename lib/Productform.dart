import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final Function(
          String name, String description, double mrp, double sellingPrice)
      onSubmit;

  const ProductForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _mrp = 0.0;
  double _sellingPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name.';
                }
                return null;
              },
              onSaved: (newValue) => _name = newValue!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product description.';
                }
                return null;
              },
              onSaved: (newValue) => _description = newValue!,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'MRP'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Please enter a valid MRP.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _mrp = double.parse(newValue!),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Selling Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Please enter a valid selling price.';
                      }
                      return null;
                    },
                    onSaved: (newValue) =>
                        _sellingPrice = double.parse(newValue!),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSubmit(_name, _description, _mrp, _sellingPrice);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
