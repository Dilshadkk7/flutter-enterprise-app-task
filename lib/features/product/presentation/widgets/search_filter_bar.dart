import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_enterprise_app/features/product/presentation/bloc/product_bloc.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<ProductBloc>().add(
          FilterProducts(
            searchTerm: _searchController.text,
            category: _selectedCategory,
          ),
        );
  }

  void _onCategoryChanged(String? newCategory) {
    setState(() {
      _selectedCategory = newCategory == 'All Categories' ? null : newCategory;
    });

    context.read<ProductBloc>().add(
          FilterProducts(
            searchTerm: _searchController.text,
            category: _selectedCategory,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProductBloc>().state;
    List<String> categories = ['All Categories'];

    if (state is ProductLoaded) {
      categories.addAll(state.uniqueCategories);
    }

    if (categories.length == 1) {
      categories = ['All Categories', 'electronics', 'jewelery', "men's clothing", "women's clothing"];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
          ),
          const SizedBox(height: 10),

          // Category Dropdown Filter
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
            value: _selectedCategory ?? 'All Categories',
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: _onCategoryChanged,
          ),
        ],
      ),
    );
  }
}