import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class AnimatedDiceRoll extends StatefulWidget {
  const AnimatedDiceRoll({
    super.key,
    required this.onRollComplete,
    required this.restaurantName,
    this.size = 120,
  });

  final VoidCallback onRollComplete;
  final String restaurantName;
  final double size;

  @override
  State<AnimatedDiceRoll> createState() => _AnimatedDiceRollState();
}

class _AnimatedDiceRollState extends State<AnimatedDiceRoll>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final Random _random = Random();
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Simple rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 360 * 5, // 5 full rotations
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Scale animation for dice effect
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.bounceOut),
        ),
        weight: 50,
      ),
    ]).animate(_controller);

    // Fade animation for result
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimation() {
    _controller.forward().whenComplete(() {
      setState(() => _showResult = true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onRollComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dice animation
          AnimatedBuilder(
            animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * (pi / 180),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size * 0.8,
                    height: widget.size * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.logoRed,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.casino,
                        size: 48,
                        color: AppColors.logoRed,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Rolling text
          if (!_showResult)
            Positioned(
              bottom: -40,
              child: Text(
                'Rolling...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoRed,
                ),
              ),
            ),

          // Result overlay
          if (_showResult)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: AppColors.logoRed,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.logoRed.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Found!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}