import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

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
        _buildFab(_animationController, Icons.add),
        const SizedBox(height: 8),
        _buildFab(_animationController, Icons.event),
        const SizedBox(height: 8),
        _buildFab(_animationController, Icons.person_add),
        const SizedBox(height: 16),
        FloatingActionButton(
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

  Widget _buildFab(AnimationController animationController, IconData iconData) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      child: FloatingActionButton(
        onPressed: () {
          // Handle fab button tap
        },
        tooltip: 'Add',
        child: Icon(iconData),
      ),
    );
  }
}
