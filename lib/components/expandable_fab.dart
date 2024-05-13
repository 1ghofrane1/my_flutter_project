import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final IconData firstSecondaryIcon;
  final IconData secondSecondaryIcon;

  final VoidCallback firstSecondaryOnPressed;
  final VoidCallback secondSecondaryOnPressed;

  const ExpandableFab({
    Key? key,
    required this.firstSecondaryIcon,
    required this.secondSecondaryIcon,
    required this.firstSecondaryOnPressed,
    required this.secondSecondaryOnPressed,
  }) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //_buildFab(_animationController, widget.mainIcon, widget.mainOnPressed),
        //const SizedBox(height: 8),
        _buildFab(_animationController, widget.firstSecondaryIcon,
            widget.firstSecondaryOnPressed),
        const SizedBox(height: 8),
        _buildFab(_animationController, widget.secondSecondaryIcon,
            widget.secondSecondaryOnPressed),
        const SizedBox(height: 16),
        FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFBEF264),
          onPressed: _toggleExpanded,
          tooltip: 'Toggle',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
        ),
      ],
    );
  }

  Widget _buildFab(AnimationController animationController, IconData iconData,
      VoidCallback onPressed) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFFBEF264),
        onPressed: onPressed,
        tooltip: 'Add',
        child: Icon(
          iconData,
          color: const Color(0xFF171717),
        ),
      ),
    );
  }
}
