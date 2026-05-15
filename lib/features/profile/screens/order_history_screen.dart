import 'package:flutter/material.dart';
import '../../../core/mock_data.dart';
import '../../shop/models/product.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A2E),
          elevation: 0,
          title: const Text(
            'My Orders',
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
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF6B35),
            indicatorWeight: 3,
            labelColor: Color(0xFFFF6B35),
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _OrderCard(
                  orderId: 'ORD-84920',
                  date: 'Today, 10:42 AM',
                  status: 'Shipped',
                  statusStep: 2,
                  products: [mockTrendingProducts[0], mockNewArrivals[1]],
                  total: 215.50,
                  isTracking: true,
                ),
                const SizedBox(height: 16),
                _OrderCard(
                  orderId: 'ORD-84915',
                  date: 'Yesterday, 2:15 PM',
                  status: 'Processing',
                  statusStep: 1,
                  products: [mockTech[1]],
                  total: 329.00,
                  isTracking: true,
                ),
              ],
            ),

            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _OrderCard(
                  orderId: 'ORD-82104',
                  date: 'Oct 12, 2025',
                  status: 'Delivered',
                  statusStep: 3,
                  products: [mockShoes[0], mockFashion[2]],
                  total: 104.98,
                  isTracking: false,
                ),
              ],
            ),

            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _OrderCard(
                  orderId: 'ORD-81099',
                  date: 'Sep 28, 2025',
                  status: 'Cancelled',
                  statusStep: -1,
                  products: [mockHome[0]],
                  total: 450.00,
                  isTracking: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final int statusStep;
  final List<Product> products;
  final double total;
  final bool isTracking;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusStep,
    required this.products,
    required this.total,
    required this.isTracking,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (statusStep == -1) {
      statusColor = const Color(0xFFF44336);
    } else if (statusStep == 3) {
      statusColor = const Color(0xFF22C55E);
    } else {
      statusColor = const Color(0xFFFF6B35);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9898B5),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Color(0xFFEEEEF5), height: 1),
          ),

          Row(
            children: [
              ...products
                  .take(3)
                  .map(
                    (product) => Align(
                      widthFactor:
                          0.8,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: product.bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
              if (products.length > 3)
                Align(
                  widthFactor: 0.8,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F6FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+${products.length - 3}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9898B5)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (isTracking && statusStep >= 0) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTimelineDot(isActive: statusStep >= 0, label: 'Placed'),
                _buildTimelineLine(isActive: statusStep >= 1),
                _buildTimelineDot(isActive: statusStep >= 1, label: 'Packed'),
                _buildTimelineLine(isActive: statusStep >= 2),
                _buildTimelineDot(isActive: statusStep >= 2, label: 'Shipped'),
                _buildTimelineLine(isActive: statusStep >= 3),
                _buildTimelineDot(
                  isActive: statusStep >= 3,
                  label: 'Delivered',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Text(
                  'Track Package',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else if (!isTracking && statusStep != -1) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Text(
                  'Buy Again',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineDot({required bool isActive, required String label}) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF6B35) : const Color(0xFFEEEEF5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isActive ? const Color(0xFF1A1A2E) : const Color(0xFF9898B5),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: isActive ? const Color(0xFFFF6B35) : const Color(0xFFEEEEF5),
      ),
    );
  }
}
