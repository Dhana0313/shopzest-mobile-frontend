import 'package:flutter/material.dart';
import '../../../core/mock_data.dart';
import '../../shop/models/product.dart';
import '../../shop/widgets/home_components.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  late final List<Product> _allProducts;
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';

  final List<String> _filterCategories = ['All', 'Shoes', 'Fashion', 'Tech', 'Home', 'Beauty'];

  @override
  void initState() {
    super.initState();
    _allProducts = [
      ...mockTrendingProducts,
      ...mockNewArrivals,
      ...mockShoes,
      ...mockFashion,
      ...mockTech,
      ...mockHome,
      ...mockBeauty,
    ];
    
    final seen = <String>{};
    _allProducts.retainWhere((product) => seen.add(product.id));
    
    _filteredProducts = List.from(_allProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(query) || 
                              product.brand.toLowerCase().contains(query);
                              
        bool matchesCategory = true;
        if (_selectedCategory != 'All') {
          if (_selectedCategory == 'Shoes') matchesCategory = mockShoes.any((p) => p.id == product.id);
          if (_selectedCategory == 'Fashion') matchesCategory = mockFashion.any((p) => p.id == product.id);
          if (_selectedCategory == 'Tech') matchesCategory = mockTech.any((p) => p.id == product.id);
          if (_selectedCategory == 'Home') matchesCategory = mockHome.any((p) => p.id == product.id);
          if (_selectedCategory == 'Beauty') matchesCategory = mockBeauty.any((p) => p.id == product.id);
        }

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF1A1A2E),
              padding: const EdgeInsets.fromLTRB(12, 16, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => _runFilter(),
                              autofocus: true,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Search products, brands...',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _runFilter();
                              },
                              child: Icon(Icons.close, color: Colors.white.withOpacity(0.5), size: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Pills
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _filterCategories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _runFilter();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF7F6FF),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFEEEEF5),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF4A4A6A),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(color: const Color(0xFF1A1A2E).withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: _filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}