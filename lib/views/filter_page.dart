import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentify/service/haptic.dart';
import 'package:rentify/utils/globals.dart';
import 'package:rentify/utils/theme_data.dart';
import 'package:rentify/views/widgets/selectable_chip.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  static String route = "/filter-page";

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Filter states
  double _minPrice = 0;
  double _maxPrice = 300000;
  int _selectedBedrooms = 0; // 0 means any
  final List<String> _selectedTypes = [];
  String? _selectedLocation;
  bool _forRent = false;
  bool _forSale = false;
  bool _highRatedOnly = false;
  bool _availableOnly = true;
  bool _nearbyOnly = false;
  int _selectedSort = 0;

  // Mock data
  final List<String> _propertyTypes = ['Apartment', 'Villa', 'House', 'Townhouse', 'Condominium'];

  final List<String> _bedroomOptions = ['Any', '1', '2', '3', '4', '5+'];

  final List<String> _locations = ['Bole', 'Yeka', 'Summit', 'CMC', '4 Kilo', 'Ayat', 'Lebu', 'Goro', 'Sarbet', 'Bole Japan'];

  final List<String> _sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Highest Rated',
    'Most Viewed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text('Filters', style: textStylelr),
        actions: [
          TextButton(
            onPressed: () {
              // Reset all filters
              setState(() {
                _minPrice = 0;
                _maxPrice = 300000;
                _selectedBedrooms = 0;
                _selectedTypes.clear();
                _selectedLocation = null;
                _forRent = false;
                _forSale = false;
                _highRatedOnly = false;
                _availableOnly = true;
                _nearbyOnly = false;
                _selectedSort = 0;
              });
            },
            child: Text('Reset', style: TextStyle(color: AppTheme.secondaryColor, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort By Section
              _buildSectionTitle('Sort By'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _sortOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = _selectedSort == index;

                  return ChoiceChip(
                    label: Text(option, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: getTheme(context).primary.withValues(alpha: 0.3),
                    backgroundColor: getTheme(context).surface.withValues(alpha: 0.6),
                    labelStyle: TextStyle(color: isSelected ? AppTheme.textColor : AppTheme.textColor.withValues(alpha: 0.7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? getTheme(context).primary : Colors.transparent, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSort = selected ? index : 0;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              // Bedrooms Section
              _buildSectionTitle('Bedrooms'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _bedroomOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = _selectedBedrooms == index;

                  return ChoiceChip(
                    label: Text(
                      option == 'Any' ? 'Any' : '$option Bed${option == '1' ? '' : 's'}',
                      style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                    ),
                    selected: isSelected,

                    selectedColor: getTheme(context).primary.withValues(alpha: 0.3),
                    backgroundColor: getTheme(context).surface.withValues(alpha: 0.6),
                    labelStyle: TextStyle(color: isSelected ? AppTheme.textColor : AppTheme.textColor.withValues(alpha: 0.7)),
                    avatar: option != 'Any' && option != '5+' ? Icon(Icons.bed, size: 16, color: getTheme(context).secondary) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? getTheme(context).primary : Colors.transparent, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    visualDensity: VisualDensity.compact,

                    onSelected: (selected) {
                      setState(() {
                        _selectedBedrooms = selected ? index : 0;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              // Price Range Section
              _buildSectionTitle('Price Range (ETB)'),

              RangeSlider(
                values: RangeValues(_minPrice, _maxPrice),
                min: 0,
                max: 300000,
                divisions: 60,
                labels: null,
                activeColor: getTheme(context).primary,
                inactiveColor: AppTheme.secondaryColor.withValues(alpha: 0.3),
                onChanged: (values) {
                  Haptic.tick();
                  setState(() {
                    _minPrice = values.start;
                    _maxPrice = values.end;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildPriceChip('${_minPrice.toInt()}'), _buildPriceChip('${_maxPrice.toInt()}')],
              ),
              const SizedBox(height: 25),

              // Property Type Section
              _buildSectionTitle('Property Type'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _propertyTypes.map((type) {
                  final isSelected = _selectedTypes.contains(type);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTypes.remove(type);
                        } else {
                          _selectedTypes.add(type);
                        }
                      });
                    },
                    child: selectableChip(label: type, icon: _getTypeIcon(type), isSelected: isSelected),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              // Location Section
              _buildSectionTitle('Location'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _locations.map((location) {
                  final isSelected = _selectedLocation == location;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocation = isSelected ? null : location;
                      });
                    },
                    child: selectableChip(label: location, icon: Icons.location_on_outlined, isSelected: isSelected),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              _buildSectionTitle('More Filters'),
              _buildToggleOption(
                icon: Icons.attach_money,
                title: 'For Rent',
                value: _forRent,
                onChanged: (value) {
                  setState(() {
                    _forRent = value!;
                    if (value) _forSale = false;
                  });
                },
              ),
              _buildToggleOption(
                icon: Icons.sell,
                title: 'For Sale',
                value: _forSale,
                onChanged: (value) {
                  setState(() {
                    _forSale = value!;
                    if (value) _forRent = false;
                  });
                },
              ),
              _buildToggleOption(
                icon: Icons.star_border,
                title: 'High Rated Only (4.0+)',
                value: _highRatedOnly,
                onChanged: (value) => setState(() => _highRatedOnly = value!),
              ),
              _buildToggleOption(
                icon: Icons.check_circle_outline,
                title: 'Available Only',
                value: _availableOnly,
                onChanged: (value) => setState(() => _availableOnly = value!),
              ),
              _buildToggleOption(
                icon: Icons.near_me_outlined,
                title: 'Nearby Properties',
                value: _nearbyOnly,
                onChanged: (value) => setState(() => _nearbyOnly = value!),
                showDivider: false,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(hPadding),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final filters = {
                  'minPrice': _minPrice,
                  'maxPrice': _maxPrice,
                  'bedrooms': _selectedBedrooms,
                  'types': _selectedTypes,
                  'location': _selectedLocation,
                  'forRent': _forRent,
                  'forSale': _forSale,
                  'highRated': _highRatedOnly,
                  'availableOnly': _availableOnly,
                  'nearby': _nearbyOnly,
                  'sortBy': _selectedSort,
                };
                Navigator.pop(context, filters);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: getTheme(context).primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.filter_alt, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: textStylelr.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPriceChip(String price) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppTheme.backgroundColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
        child: Text('ETB ${formatNumberWithCommas(price)}', style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      splashColor: getTheme(context).primary.withValues(alpha: 0.3),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.secondaryColor, size: 22),
              const SizedBox(width: 15),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
              Transform.scale(
                scale: 0.9.sp,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppTheme.secondaryColor,
                  inactiveThumbColor: getTheme(context).onPrimary,
                  trackOutlineColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected) ? null : AppTheme.backgroundColor.withValues(alpha: 0.5),
                  ),
                  activeTrackColor: getTheme(context).primary.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          if (showDivider) SizedBox(height: 15),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'apartment':
        return Icons.apartment;
      case 'villa':
        return Icons.villa;
      case 'house':
        return Icons.house;
      case 'townhouse':
        return Icons.home_work;
      case 'condominium':
        return Icons.domain;
      default:
        return Icons.home;
    }
  }
}
