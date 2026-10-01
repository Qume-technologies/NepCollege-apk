import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fees_provider.dart';
import '../widgets/fees_summary_card.dart';
import '../widgets/fee_transaction_item.dart';
import '../widgets/fee_support_section.dart';

class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final feesAsync = ref.watch(feesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Fee Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: feesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading fee records: $err')),
        data: (feesData) {
          double outstanding = 0;
          for (var fee in feesData) {
            if (!(fee['is_paid'] as bool? ?? false)) {
              outstanding += (fee['amount'] as num? ?? 0).toDouble();
            }
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(feesProvider.notifier).refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeesSummaryCard(outstanding: outstanding),
                  const SizedBox(height: 32),
                  const Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (feesData.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('No fee records found.', style: TextStyle(color: Colors.grey)),
                    )),
                  ...feesData.map((fee) => FeeTransactionItem(
                    title: fee['title'] ?? 'Fee Payment', 
                    amount: (fee['amount'] as num? ?? 0).toString(), 
                    date: fee['due_date'] ?? 'N/A', 
                    status: fee['is_paid'] ?? false,
                  )),
                  const SizedBox(height: 32),
                  const FeeSupportSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
