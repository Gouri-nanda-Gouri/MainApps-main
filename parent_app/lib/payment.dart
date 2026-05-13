import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parent_app/success.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Access your Supabase instance
final supabase = Supabase.instance.client;

class PaymentGatewayScreen extends StatefulWidget {
  final int id;
  final dynamic amt;

  const PaymentGatewayScreen({super.key, required this.id, required this.amt});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController cardName = TextEditingController();
  final TextEditingController expiry = TextEditingController();
  final TextEditingController cvv = TextEditingController();

 Future<void> checkout() async {
  // 1. Validate form fields (Card number, Expiry, etc.)
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isProcessing = true);

  try {
    // 2. Update the Consultation record
    // We update payment_status to 'paid' and ensure the status is 'active'
    await supabase
        .from('tbl_consultation')
        .update({
          'payment_status': 'paid',
          'consultation_status': 'active', // Or 'completed' depending on your flow
        })
        .eq('appointment_id', widget.id); 

    // 3. Optional: Update the master appointment status if needed
    await supabase
        .from('tbl_appointment')
        .update({'appointment_status': 4}) // Mark appointment as approved
        .eq('appointment_id', widget.id);

    // 4. Success Navigation
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  PaymentSuccessPage()),
      );
    }
  } catch (e) {
    print("Payment processing error: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment processing failed: ${e.toString()}")),
      );
    }
    setState(() => _isProcessing = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Secure Payment", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              /// CREDIT CARD UI
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xff7F5AF0), Color(0xff6246EA)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.credit_card, color: Colors.white, size: 40),
                    const Spacer(),
                    Text(
                      cardNumber.text.isEmpty ? "XXXX XXXX XXXX XXXX" : cardNumber.text,
                      style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cardName.text.isEmpty ? "CARD HOLDER" : cardName.text.toUpperCase(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          expiry.text.isEmpty ? "MM/YY" : expiry.text,
                          style: const TextStyle(color: Colors.white70),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              /// PAYMENT FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: cardNumber,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardFormatter()
                      ],
                      decoration: inputDecoration("Card Number"),
                      validator: (value) {
                        if (value == null || value.replaceAll(" ", "").length != 16) {
                          return "Enter valid 16 digit card number";
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: cardName,
                      decoration: inputDecoration("Card Holder Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter name";
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiry,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              ExpiryFormatter()
                            ],
                            decoration: inputDecoration("Expiry MM/YY"),
                            validator: (value) {
                              if (value == null || value.length != 5) return "Invalid";
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: cvv,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3)
                            ],
                            decoration: inputDecoration("CVV"),
                            validator: (value) {
                              if (value == null || value.length != 3) return "Invalid";
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7F5AF0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isProcessing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("Pay ₹${widget.amt}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class CardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    var text = newValue.text.replaceAll(" ", "");

    if (text.length > 16) return oldValue;

    var newText = "";

    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) newText += " ";
      newText += text[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    String text = newValue.text.replaceAll("/", "");

    if (text.length > 4) return oldValue;

    if (text.length >= 3) {
      text = "${text.substring(0,2)}/${text.substring(2)}";
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}