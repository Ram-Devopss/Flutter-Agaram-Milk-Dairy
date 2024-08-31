import 'package:agaram_dairy/dashboard.dart';
import 'package:agaram_dairy/products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SubscriptionCard.dart';
import 'fulladdress.dart';

class OrdersConfirm extends StatefulWidget {
  final List<Product> products;
  final String userid;

  const OrdersConfirm({Key? key, required this.products, required this.userid}) : super(key: key);



  @override
  State<OrdersConfirm> createState() => _OrdersConfirmState();

}


class _OrdersConfirmState extends State<OrdersConfirm> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.products.fold(0, (previousValue, product) => previousValue + (product.price * product.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.products[index].name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: \u20B9${widget.products[index].price.toStringAsFixed(2)}  - Quantity: ${widget.products[index].quantity}',
                        ),
                        const SizedBox(height: 22),
                        if (loading) const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Price:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\u20B9$totalPrice',
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {

var address = await findAddressData();

 if(address['full_address']==null)
{
  const snackBar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.close, color: Colors.red),
        SizedBox(width: 8),
        Text('First Add Address'),
      ],
    ),
    backgroundColor: Colors.lightGreen,
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) =>   AddressPage(uid:widget.userid)),
    // Prevents going back to the intro page
  );

}
else
  {

    setState(() {
      loading = true;
    });
    var result = await insertData();
    if (result) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Dashboard(uid: widget.userid)));

      setState(() {
        loading = false;
      });


      const snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.lightGreen),
            SizedBox(width: 8),
            Text('Booking Was Registered'),
          ],
        ),
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Confirm Orders',
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Address Card View
          Expanded(
            child: AddressCardView(uid: widget.userid),
          ),
        ],
      ),
    );
  }

  Future<bool> insertData() async {
    try {
      // Prepare a list of maps containing product details
      List<Map<String, dynamic>> productsData = [];
      double totalPrice = widget.products.fold(
          0, (previousValue, product) => previousValue + (product.price * product.quantity));
      // Iterate through each product in the list and add its details to the productsData list
      widget.products.forEach((product) {
        productsData.add({
          'name': product.name,
          'price': product.price,
          'quantity': product.quantity,
        });
      });

      // Add a new document with the incremented ID
      await FirebaseFirestore.instance.collection('agaram').doc('user_delivery').collection('users').doc(widget.userid).collection("booking").doc('products').set({
        "order_placed": DateTime.now(),
        "items": productsData,
        'total_price': totalPrice
      });


      print("Data Inserted Successfully");
      return true;
    } catch (error) {
      print(error);
      const snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Text('Something Went Wrong'),
          ],
        ),
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  Future<Map<String, dynamic>> findWalletData() async {
    try {
      // Retrieve the document snapshot from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.userid)
          .collection("booking")
          .doc("wallets")
          .get();

      // Check if the snapshot contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Explicitly cast the data to the expected type
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

        // Check if the data is empty
        if (data.isEmpty) {
          // Handle case where data is empty
          return {};
        }

        // Return the retrieved data
        return data;
      } else {
        const snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.close, color: Colors.red),
              SizedBox(width: 8),
              Text('First Add Subscription'),
            ],
          ),
          backgroundColor: Colors.lightGreen,
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) =>   SubscriptionGrid(uid: widget.userid),),
        //   // Prevents going back to the intro page
        // );

        // Handle case where no data is available
        throw Exception('No wallet data available');
      }
    } catch (e) {
      // Handle any errors that occur during data retrieval
      throw Exception('Error fetching wallet data: $e');
    }
  }


  Future<Map<String, dynamic>> findAddressData() async {
    try {
      // Retrieve the document snapshot from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(widget.userid)
          .collection("booking")
          .doc("full_address")
          .get();

      // Check if the snapshot contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Explicitly cast the data to the expected type
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

        // Check if the data is empty
        if (data.isEmpty) {
          // Handle case where data is empty
          return {};
        }

        // Return the retrieved data
        return data;
      } else {
        const snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.close, color: Colors.red),
              SizedBox(width: 8),
              Text('First Add Address'),
            ],
          ),
          backgroundColor: Colors.lightGreen,
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>   AddressPage(uid:widget.userid)),
          // Prevents going back to the intro page
        );

        // Handle case where no data is available
        throw Exception('No Address are available');
      }
    } catch (e) {
      // Handle any errors that occur during data retrieval
      throw Exception('Error fetching Address data: $e');
    }
  }







}
class AddressCardView extends StatelessWidget {
  final String uid;
  AddressCardView({required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .collection("booking")
          .doc("full_address")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Connecting Pls Wait"); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddressPage(uid: this.uid)));
          return Text('No data available'); // Show if no data is available
        } else {

           Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null || data.isEmpty) {
            // Handle case where data is null or empty

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => AddressPage(uid: this.uid)));

            return Row(
              children: <Widget>[
                Text("No Address Has Found"),
                const Spacer(),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.greenAccent[8]
                  ),
                  icon: Icon(Icons.edit),
                  label: const Text(
                    "Add Address",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddressPage(uid: this.uid)));                            },
                ),
              ],
            );
          }
          // Data is available, construct your card view here
          Map<String, dynamic> fullAddress = data['full_address'][0]; // Access the first address in the list

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[800],
                        ),
                      ),
                      Container(height: 10),
                      Text(
                        "Area: ${fullAddress['area']}\nPincode: ${fullAddress['pincode']}\nCity: ${fullAddress['city']}\nHouse No: ${fullAddress['house_no']}\nState: ${fullAddress['state']}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Spacer(),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.greenAccent[8]
                            ),
                            icon: Icon(Icons.edit),
                            label: const Text(
                              "Edit Address",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AddressPage(uid: this.uid)));                            },
                          ),
                         ],
                      ),
                    ],
                  ),
                ),
                Container(height: 5),
              ],
            ),
          );
        }
      },
    );
  }
}