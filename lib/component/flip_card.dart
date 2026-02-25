import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget Function(double opacity) frontBuilder;
  final Widget Function(double opacity) backBuilder;

  const FlipCard({
    super.key,
    required this.frontBuilder,
    required this.backBuilder,
  });

  @override
  State<FlipCard> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _fadeController;
  late Animation<double> _flipAnimation;
  late Animation<double> _fadeAnimation;

  bool isFront = true;
  bool _showFront = true;
  VoidCallback? _onFlipComplete;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 1.0,
    );
    _fadeAnimation = _fadeController.drive(Tween(begin: 0.0, end: 1.0));

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipController.reset();
        _onFlipComplete?.call();
        _onFlipComplete = null;
        _fadeController.forward();
      }
    });
  }

  void flip() {
    _flipController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showFront = !_showFront;
          isFront = !isFront;
        });
      }
    });
  }

  //void flipToNext(VoidCallback onComplete) {
  //  _onFlipComplete = onComplete;
  //  _fadeController.reverse().then((_) {
  //    _flipController.forward();
  //    Future.delayed(const Duration(milliseconds: 200), () {
  //      if (mounted) {
  //        setState(() {
  //          _showFront = true;
  //          isFront = true;
  //        });
  //      }
  //    });
  //  });
  //}

  void flipToNextNoFade(VoidCallback onComplete) {
    _onFlipComplete = onComplete;
    _flipController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.value = 0.0;
        setState(() {
          _showFront = true;
          isFront = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _fadeAnimation]),
        builder: (context, _) {
          final angle = _flipAnimation.value * 3.14159;
          final tilt = angle < 1.5708 ? angle : angle - 3.14159;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(tilt),
            // Passe l'opacité au builder → seul le contenu fade
            child: _showFront
                ? widget.frontBuilder(_fadeAnimation.value)
                : widget.backBuilder(_fadeAnimation.value),
          );
        },
      ),
    );
  }
}
