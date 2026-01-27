import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractiveWeatherCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final bool enableHapticFeedback;

  const InteractiveWeatherCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.enableHapticFeedback = true,
  });

  @override
  State<InteractiveWeatherCard> createState() => _InteractiveWeatherCardState();
}

class _InteractiveWeatherCardState extends State<InteractiveWeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _scale = 1.0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse().then((_) {
      if (widget.onTap != null) {
        widget.onTap!();
      }
    });
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!_isPressed) {
          setState(() => _scale = 1.02);
        }
      },
      onExit: (_) {
        if (!_isPressed) {
          setState(() => _scale = 1.0);
        }
      },
      child: GestureDetector(
        onTapDown: widget.onTap != null ? _onTapDown : null,
        onTapUp: widget.onTap != null ? _onTapUp : null,
        onTapCancel: widget.onTap != null ? _onTapCancel : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? _scaleAnimation.value : _scale,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.15),
                  blurRadius: _isPressed ? 8 : 12,
                  offset: Offset(0, _isPressed ? 2 : 4),
                  spreadRadius: _isPressed ? 0 : 1,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}