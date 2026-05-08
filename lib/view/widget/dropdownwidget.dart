import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.isRequired,
    required this.label,
    required this.selectLabel,
    this.selectedItem,
    required this.dropItems,
    required this.onChanged,
    this.height,
    this.backgroundColor = Colors.white,
    this.validator,
  });

  final bool? isRequired;
  final String label;
  final String selectLabel;
  final String? selectedItem;
  final void Function(String) onChanged;
  final List<String> dropItems; 
  final double? height;
  final Color backgroundColor;
  final String? Function(String?)? validator;

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedValue;
  bool isDropdownOpen = false;
  final ScrollController _dropdownScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedItem;
  }

  @override
  void dispose() {
    _dropdownScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue ?? widget.selectLabel,
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        if (isDropdownOpen)
          Container(
            height: widget.height ?? 130,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: RawScrollbar(
              thumbVisibility: true,
              thickness: 6,
              thumbColor: Colors.grey.withOpacity(0.6),
              radius: const Radius.circular(20),
              trackVisibility: true,
              controller: _dropdownScrollController,
              child: SingleChildScrollView(
                controller: _dropdownScrollController,
                child: Column(
                  children: widget.dropItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        widget.onChanged(item);
                        setState(() {
                          selectedValue = item;
                          isDropdownOpen = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        alignment: Alignment.topLeft,
                        child: Text(
                          item,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        if (widget.validator != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Builder(
              builder: (context) {
                final errorMessage = widget.validator!(selectedValue);
                if (errorMessage == null)
                  return const SizedBox.shrink();
                return Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                );
              },
            ),
          ),
      ],
    );
  }
}
