import 'package:flutter/material.dart';

void message(BuildContext context, String text, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: error ? Colors.red.shade700 : null,
    ),
  );
}

String money(num amount) => '\$${amount.toStringAsFixed(2)}';

class ErrorPanel extends StatelessWidget {
  final String text;
  final VoidCallback retry;
  const ErrorPanel(this.text, this.retry, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 44),
              const SizedBox(height: 16),
              Text(text, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: retry, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
}

class ProductImage extends StatelessWidget {
  final String url;
  final double height;
  const ProductImage(this.url, {this.height = 150, super.key});
  @override
  Widget build(BuildContext context) => Image.network(
        url,
        height: height,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : SizedBox(
                height: height,
                child: const Center(child: CircularProgressIndicator()),
              ),
        errorBuilder: (_, error, stack) => SizedBox(
          height: height,
          child: const Icon(Icons.image_not_supported_outlined, size: 48),
        ),
      );
}
