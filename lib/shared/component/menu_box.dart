import 'package:flutter/material.dart';
import 'package:soleh/themes/colors.dart';

class MenuBox2 extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const MenuBox2({
    super.key,
    required this.icon,
    required this.label,
    this.color = const Color(0xFF4A7C59),
  });

  @override
  State<MenuBox2> createState() => _MenuBox2State();
}

class _MenuBox2State extends State<MenuBox2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () {
        print('${widget.label} tapped');
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorTheme.primary,
                ColorTheme.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? widget.color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.08),
                spreadRadius: _isPressed ? 2 : 0,
                blurRadius: _isPressed ? 8 : 6,
                offset: Offset(0, _isPressed ? 2 : 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, size: 26, color: Colors.white),
                      const SizedBox(height: 4),
                      MarqueeText(
                        text: widget.label,
                        maxWidth: 68, // 80 - 12
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -10,
                child: Opacity(
                  opacity: 0.45,
                  child: Icon(
                    widget.icon,
                    size: 70,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuBox extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const MenuBox({
    super.key,
    required this.icon,
    required this.label,
    this.color = const Color(0xFF4A7C59),
  });

  @override
  State<MenuBox> createState() => _MenuBoxState();
}

class _MenuBoxState extends State<MenuBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () {
        print('${widget.label} tapped');
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? widget.color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.08),
                spreadRadius: _isPressed ? 2 : 0,
                blurRadius: _isPressed ? 8 : 6,
                offset: Offset(0, _isPressed ? 2 : 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 28,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.maxWidth = 64,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOverflowing = false;
  double _textWidth = 0;
  late double _containerWidth;

  @override
  void initState() {
    super.initState();
    _containerWidth = widget.maxWidth;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    if (mounted) {
      setState(() {
        _textWidth = textPainter.width;
        _isOverflowing = _textWidth > _containerWidth;
      });

      if (_isOverflowing) {
        final scrollDistance = _textWidth - _containerWidth + 25; // Add padding

        _animation = Tween<double>(
          begin: 0,
          end: -scrollDistance,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                _controller.reset();
                _controller.forward();
              }
            });
          }
        });

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOverflowing) {
      return Text(
        widget.text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: widget.style,
      );
    }

    return SizedBox(
      width: _containerWidth,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: Text(
                widget.text,
                maxLines: 1,
                style: widget.style,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            );
          },
        ),
      ),
    );
  }
}
