import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> confirmOrderReceived(String orderId) async {
  try {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'customerConfirmed': true,
      'customerConfirmedTimestamp': FieldValue.serverTimestamp(),
      'status': "Completed"
    });
  } catch (e) {
    print("Error confirming order receipt: $e");
  }
}

class CustomerOrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const CustomerOrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading order data: ${snapshot.error}"));
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Order not found", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text("Looking for order ID: $orderId",
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            );
          }

          // Safely cast data
          Map<String, dynamic>? orderData;
          try {
            orderData = snapshot.data!.data() as Map<String, dynamic>;
          } catch (e) {
            return Center(child: Text("Invalid order data format: $e"));
          }

          // Get order items (handling as an array)
          List<dynamic> orderItems = orderData['orderDetails'] ?? [];
          bool isDelivered = orderData['status'] == 'Delivered';
          bool isConfirmedByCustomer = orderData['customerConfirmed'] == true;
          
          // Show confirmation button only if order is delivered but not yet confirmed
          bool showConfirmButton = isDelivered && !isConfirmedByCustomer;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Order Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text("Order ID: $orderId",
                            style: const TextStyle(fontSize: 16)),
                        Text("Status: ${orderData['status'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(orderData['status']),
                            )),
                        const SizedBox(height: 4),
                        if (isDelivered)
                          Text(
                              "Delivery Confirmed: ${orderData['customerConfirmed'] == true ? 'Yes' : 'No'}",
                              style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),

                // Display confirmation message at the top if confirmed
                if (isConfirmedByCustomer)
                  Card(
                    margin: const EdgeInsets.only(top: 16),
                    color: Colors.green.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "You have confirmed receipt of this order.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
                const Text(
                  "Order Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (orderItems.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No items in this order",
                          style: TextStyle(fontSize: 16)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text(orderItems[index].toString()),
                        ),
                      );
                    },
                  ),

                if (orderData['deliveryTimestamp'] != null) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Delivery Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Expected Delivery: ${_formatTimestamp(orderData['deliveryTimestamp'])}",
                              style: const TextStyle(fontSize: 16)),
                          if (orderData['deliveryCompletedTimestamp'] != null)
                            Text(
                                "Delivered On: ${_formatTimestamp(orderData['deliveryCompletedTimestamp'])}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          if (orderData['customerConfirmedTimestamp'] != null)
                            Text(
                                "Received On: ${_formatTimestamp(orderData['customerConfirmedTimestamp'])}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ],

                if (orderData['storeInfo'] != null || orderData['storeName'] != null) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Store Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (orderData['storeName'] != null)
                            Text("Store: ${orderData['storeName']}",
                                style: const TextStyle(fontSize: 16)),
                          if (orderData['storeAddress'] != null)
                            Text("Address: ${orderData['storeAddress']}",
                                style: const TextStyle(fontSize: 16)),
                          if (orderData['storePhone'] != null)
                            Text("Phone: ${orderData['storePhone']}",
                                style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],

                if (orderData['totalAmount'] != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("\$${orderData['totalAmount'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Customer confirmation button (only shown if order is delivered but not confirmed)
                if (showConfirmButton)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _confirmReceipt(context, orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Confirm Order Received",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmReceipt(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Receipt"),
          content: const Text(
              "Have you received all items in your order? This will complete the order process."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Close confirmation dialog
                Navigator.of(dialogContext).pop();

                // Store the current scaffold context for showing snackbars later
                final scaffoldContext = context;

                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext loadingContext) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("Confirming receipt..."),
                        ],
                      ),
                    );
                  },
                );

                // Update the order
                confirmOrderReceived(orderId).then((_) {
                  // Pop loading dialog if app is still running
                  if (scaffoldContext.mounted) {
                    // Find the current navigator context to pop the dialog
                    Navigator.of(scaffoldContext).pop();

                    // Show success message
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Thank you for confirming receipt of your order!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }).catchError((error) {
                  // Pop loading dialog if app is still running
                  if (scaffoldContext.mounted) {
                    Navigator.of(scaffoldContext).pop();

                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text("Failed to confirm order: $error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              },
              child:
                  const Text("Confirm Receipt", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.amber;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      if (timestamp is Timestamp) {
        final DateTime dateTime = timestamp.toDate();
        return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return timestamp.toString();
      }
    } catch (e) {
      return timestamp.toString();
    }
  }
}