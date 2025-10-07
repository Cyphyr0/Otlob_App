import "package:flutter/material.dart";
import "../../domain/entities/payment.dart";

class PaymentResultWidget extends StatelessWidget {
  final Payment payment;
  final VoidCallback onContinue;

  const PaymentResultWidget({
    super.key,
    required this.payment,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = payment.status == PaymentTransactionStatus.completed;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSuccess
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.red.shade400, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Header
              Text(
                isSuccess ? "Payment Successful!" : "Payment Failed",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 48),

              // Animated result icon
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          isSuccess ? Icons.check_circle : Icons.error,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Payment details
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              "Amount",
                              "${payment.amount} ${payment.currency}",
                              isHeader: true,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              "Payment Method",
                              _getProviderDisplayName(payment.provider),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              "Transaction ID",
                              payment.transactionId ?? "N/A",
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              "Date & Time",
                              _formatDateTime(payment.createdAt),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              "Status",
                              _getStatusDisplayText(payment.status),
                              isStatus: true,
                              statusColor: _getStatusColor(payment.status),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Success/Failure message
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          isSuccess
                              ? "Your payment has been processed successfully. You will receive a confirmation email shortly."
                              : "Your payment could not be processed. Please try again or contact support.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    if (!isSuccess) ...[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade600,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Try Again"),
                      ),
                      const SizedBox(height: 16),
                    ],

                    ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isSuccess ? "Continue to Order" : "Back to Payment"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHeader = false, bool isStatus = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHeader ? 18 : 14,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHeader ? 18 : 14,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
            color: isStatus ? statusColor : Colors.black,
          ),
        ),
      ],
    );
  }

  String _getProviderDisplayName(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return "Credit/Debit Card";
      case PaymentProvider.fawry:
        return "Fawry";
      case PaymentProvider.vodafoneCash:
        return "Vodafone CASH";
      case PaymentProvider.meeza:
        return "Meeza";
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _getStatusDisplayText(PaymentTransactionStatus status) {
    switch (status) {
      case PaymentTransactionStatus.completed:
        return "Completed";
      case PaymentTransactionStatus.processing:
        return "Processing";
      case PaymentTransactionStatus.failed:
        return "Failed";
      case PaymentTransactionStatus.cancelled:
        return "Cancelled";
      case PaymentTransactionStatus.refunded:
        return "Refunded";
      case PaymentTransactionStatus.pending:
        return "Pending";
    }
  }

  Color _getStatusColor(PaymentTransactionStatus status) {
    switch (status) {
      case PaymentTransactionStatus.completed:
        return Colors.green;
      case PaymentTransactionStatus.processing:
        return Colors.orange;
      case PaymentTransactionStatus.failed:
        return Colors.red;
      case PaymentTransactionStatus.cancelled:
        return Colors.grey;
      case PaymentTransactionStatus.refunded:
        return Colors.blue;
      case PaymentTransactionStatus.pending:
        return Colors.amber;
    }
  }
}