import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../widgets/virtual_credit_card.dart';
import '../utils/payment_formatters.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String _cardType = 'unknown';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _detectCardType(String input) {
    String cleanInput = input.replaceAll(' ', '');
    String newType = 'unknown';

    if (cleanInput.startsWith('4'))
      newType = 'visa';
    else if (cleanInput.startsWith('5'))
      newType = 'mastercard';
    else if (cleanInput.startsWith('34') || cleanInput.startsWith('37'))
      newType = 'amex';

    if (newType != _cardType) {
      setState(() => _cardType = newType);
    }
  }

  Widget _getCardIcon() {
    switch (_cardType) {
      case 'visa':
        return const Text('💳', style: TextStyle(fontSize: 24));
      case 'mastercard':
        return const Text('🔴🟡', style: TextStyle(fontSize: 20));
      case 'amex':
        return const Text('🔵', style: TextStyle(fontSize: 24));
      default:
        return const Icon(Icons.credit_card, color: Color(0xFF9898B5));
    }
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    context.read<CartProvider>().clearCart();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9898B5), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF9898B5)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEEEEF5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEEEEF5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6B35)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF44336)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CartProvider>().total;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Secure Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Replaced 60 lines of UI with this single clean component!
                      VirtualCreditCard(
                        cardNumber: _cardNumberController.text,
                        cardholderName: _nameController.text,
                        expiryDate: _expiryController.text,
                        cardIcon: _getCardIcon(),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) => setState(() {}),
                        decoration: _inputDecoration(
                          'Cardholder Name',
                          Icons.person_outline,
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter(),
                        ],
                        onChanged: (value) {
                          _detectCardType(value);
                          setState(() {});
                        },
                        decoration:
                            _inputDecoration(
                              'Card Number',
                              Icons.credit_card,
                            ).copyWith(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: _getCardIcon(),
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter your card number';
                          if (value.length < 19)
                            return 'Incomplete card number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardExpiryInputFormatter(),
                              ],
                              onChanged: (value) => setState(() {}),
                              decoration: _inputDecoration(
                                'MM/YY',
                                Icons.calendar_today_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                if (value.length < 5) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: _inputDecoration(
                                'CVV',
                                Icons.lock_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                if (value.length < 3) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEF5))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Pay \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
