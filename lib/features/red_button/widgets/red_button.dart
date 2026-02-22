import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RedButton extends StatefulWidget {
  const RedButton({
    super.key,
    required this.onPressed,
    this.buttonColor,
    this.soundAssetPath,
  });

  final VoidCallback onPressed;
  final Color? buttonColor;
  /// Asset path for click sound, e.g. 'audio/click.mp3'.
  final String? soundAssetPath;

  @override
  State<RedButton> createState() => _RedButtonState();
}

class _RedButtonState extends State<RedButton>
    with SingleTickerProviderStateMixin {
  static const int _maxAudioPlayers = 3;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<AudioPlayer> _audioPlayers = [];
  int _currentPlayerIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    for (int i = 0; i < _maxAudioPlayers; i++) {
      _audioPlayers.add(AudioPlayer());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final player in _audioPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> _playClickSound() async {
    try {
      final player = _audioPlayers[_currentPlayerIndex];
      await player.stop();
      await player.play(
        AssetSource(widget.soundAssetPath ?? 'audio/click.mp3'),
      );
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _maxAudioPlayers;
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error triggering haptic feedback: $e');
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    _playClickSound();
    _triggerHapticFeedback();
  }

  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: widget.buttonColor ?? Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (widget.buttonColor ?? Colors.red)
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
