import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final VoidCallback onTap;
  final bool isNeumorphic;

  const CalculatorButton({
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
    this.isNeumorphic = false,
    Key? key,
  }) : super(key: key);

  @override
  _CalculatorButtonState createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isOperator = [
      '÷',
      '×',
      '-',
      '+',
      '=',
      '%',
      '⌫',
      'C',
      '☰',
    ].contains(widget.text);
    final buttonColor = widget.color ?? Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient:
                    isOperator && widget.color != null
                        ? LinearGradient(
                          colors: [
                            widget.color!.withOpacity(_isPressed ? 1.0 : 0.9),
                            widget.color!.withOpacity(_isPressed ? 0.9 : 1.0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: isOperator && widget.color != null ? null : buttonColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    widget.isNeumorphic
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              _isPressed ? 0.05 : 0.1,
                            ),
                            offset: Offset(
                              _isPressed ? 2 : 4,
                              _isPressed ? 2 : 4,
                            ),
                            blurRadius: _isPressed ? 4 : 8,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(
                              _isPressed ? 0.1 : 0.2,
                            ),
                            offset: Offset(
                              _isPressed ? -2 : -4,
                              _isPressed ? -2 : -4,
                            ),
                            blurRadius: _isPressed ? 4 : 8,
                            spreadRadius: 1,
                          ),
                        ]
                        : [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              _isPressed ? 0.04 : 0.08,
                            ),
                            blurRadius: _isPressed ? 3 : 6,
                            offset: Offset(0, _isPressed ? 1 : 2),
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.3),
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.15),
                  child: Center(
                    child: Text(
                      widget.text,
                      style: GoogleFonts.inter(
                        fontSize: widget.fontSize ?? 22,
                        fontWeight:
                            isOperator ? FontWeight.w600 : FontWeight.w500,
                        color:
                            widget.color != null
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface
                                    .withOpacity(_isPressed ? 1.0 : 0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
