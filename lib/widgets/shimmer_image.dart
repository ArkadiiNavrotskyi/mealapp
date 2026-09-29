import 'package:flutter/material.dart';

/// Simple shimmer placeholder shown while a network image loads.
/// No external package needed.
class ShimmerImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
  });

  @override
  State<ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _ShimmerBox(controller: _controller);
      },
      errorBuilder: (context, error, stack) =>
      widget.errorWidget ??
          Container(
            color: Colors.grey[850],
            alignment: Alignment.center,
            child: const Icon(
              Icons.restaurant,
              color: Colors.white54,
              size: 40,
            ),
          ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final AnimationController controller;
  const _ShimmerBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + t * 2, -1.0),
              end: Alignment(1.0 + t * 2, 1.0),
              colors: const [
                Color(0xFF2A2A2A),
                Color(0xFF3D3D3D),
                Color(0xFF2A2A2A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}