import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  void _pay() {
    InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-cU2rXc0G8Lsn2e_EDnp-BA');
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _cardNonceRequestSuccess,
        onCardEntryCancel: _cardEntryCancel);
  }

  void _cardEntryCancel() {}

  void _cardNonceRequestSuccess(CardDetails result) {
    print(result);
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(
        child: Icon(Icons.payment),
        onPressed: _pay,
        tooltip: 'Payment',
      ),
    );
  }
}
