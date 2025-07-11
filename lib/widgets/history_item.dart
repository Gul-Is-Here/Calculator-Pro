import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/calculation.dart';

class HistoryItem extends StatefulWidget {
  final Calculation calculation;
  final VoidCallback onTap;
  final Function(bool) onFavorite;
  final VoidCallback onDelete;

  const HistoryItem({
    required this.calculation,
    required this.onTap,
    required this.onFavorite,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: Get.theme.colorScheme.surface.withOpacity(0.95),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              splashColor: Get.theme.colorScheme.primary.withOpacity(0.2),
              highlightColor: Get.theme.colorScheme.primary.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isPressed ? 0.05 : 0.1),
                      offset: Offset(_isPressed ? 2 : 4, _isPressed ? 2 : 4),
                      blurRadius: _isPressed ? 4 : 8,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(_isPressed ? 0.05 : 0.1),
                      offset: Offset(
                        _isPressed ? -2 : -4,
                        _isPressed ? -2 : -4,
                      ),
                      blurRadius: _isPressed ? 4 : 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.calculation.expression,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Get.theme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              widget.calculation.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  widget.calculation.isFavorite
                                      ? Get.theme.colorScheme.error
                                      : Get.theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                              size: 24,
                            ),
                            onPressed:
                                () => widget.onFavorite(
                                  !widget.calculation.isFavorite,
                                ),
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '= ${widget.calculation.result}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.calculation.formattedDate,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Get.theme.colorScheme.error.withOpacity(
                                0.7,
                              ),
                              size: 20,
                            ),
                            onPressed: widget.onDelete,
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
