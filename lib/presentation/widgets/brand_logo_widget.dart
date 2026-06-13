import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandLogoWidget extends StatelessWidget {
  final String brand;
  final Color color;

  const BrandLogoWidget({
    Key? key,
    required this.brand,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cleanBrand = brand.toLowerCase().trim();

    if (cleanBrand.contains('chanel')) {
      return CustomPaint(
        size: const Size(60, 45),
        painter: ChanelLogoPainter(color),
      );
    } else if (cleanBrand.contains('gucci')) {
      return CustomPaint(
        size: const Size(60, 45),
        painter: GucciLogoPainter(color),
      );
    } else if (cleanBrand.contains('yves saint laurent') || cleanBrand == 'ysl') {
      return _buildYslLogo(color);
    } else if (cleanBrand.contains('margiela')) {
      return _buildMargielaLogo(color);
    } else if (cleanBrand.contains('versace')) {
      return _buildVersaceLogo(color);
    } else if (cleanBrand.contains('nishane')) {
      return _buildNishaneLogo(color);
    } else if (cleanBrand == 'kilian') {
      return _buildKilianLogo(color);
    } else if (cleanBrand.contains('marly')) {
      return _buildMarlyLogo(color);
    } else if (cleanBrand.contains('tom ford')) {
      return _buildTomFordLogo(color);
    } else if (cleanBrand.contains('hermes')) {
      return _buildHermesLogo(color);
    } else if (cleanBrand.contains('creed')) {
      return _buildCreedLogo(color);
    } else if (cleanBrand.contains('prada')) {
      return _buildPradaLogo(color);
    } else if (cleanBrand.contains('armani')) {
      return _buildArmaniLogo(color);
    }

    return _buildFallbackLogo(brand, color);
  }

  // --- Brand Logo Builders ---

  Widget _buildYslLogo(Color color) {
    return SizedBox(
      width: 60,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            child: Text(
              'Y',
              style: GoogleFonts.cinzel(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Text(
              'S',
              style: GoogleFonts.cinzel(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.9),
              ),
            ),
          ),
          Positioned(
            top: 18,
            child: Text(
              'L',
              style: GoogleFonts.cinzel(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMargielaLogo(Color color) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMargielaRow(['0', '1', '2', '③', '4', '5'], color),
          _buildMargielaRow(['6', '7', '8', '9', '10', '11'], color),
          _buildMargielaRow(['12', '13', '14', '15', '16', '17'], color),
          _buildMargielaRow(['18', '19', '20', '21', '22', '23'], color),
        ],
      ),
    );
  }

  Widget _buildMargielaRow(List<String> nums, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: nums.map((n) {
        final isSelected = n == '③';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
          child: Container(
            width: 10,
            alignment: Alignment.center,
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 0.8),
                  )
                : null,
            child: Text(
              isSelected ? '3' : n,
              style: GoogleFonts.outfit(
                fontSize: 6.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : color.withOpacity(0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVersaceLogo(Color color) {
    return CustomPaint(
      size: const Size(50, 50),
      painter: VersaceLogoPainter(color),
      child: Center(
        child: Text(
          'V',
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildNishaneLogo(Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'N',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1,
                ),
              ),
              Text(
                'NISHANE',
                style: GoogleFonts.outfit(
                  fontSize: 5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKilianLogo(Color color) {
    return Container(
      width: 40,
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Text(
          'K',
          style: GoogleFonts.cinzel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildMarlyLogo(Color color) {
    return CustomPaint(
      size: const Size(46, 46),
      painter: MarlyLogoPainter(color),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Text(
              '1743',
              style: GoogleFonts.outfit(
                fontSize: 7,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              'PdM',
              style: GoogleFonts.cinzel(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTomFordLogo(Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          'TF',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildHermesLogo(Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          'H',
          style: GoogleFonts.cinzel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildCreedLogo(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.keyboard_arrow_up, size: 10, color: color),
            Icon(Icons.keyboard_arrow_up, size: 14, color: color),
            Icon(Icons.keyboard_arrow_up, size: 10, color: color),
          ],
        ),
        Text(
          'CREED',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPradaLogo(Color color) {
    return CustomPaint(
      size: const Size(50, 42),
      painter: PradaLogoPainter(color),
      child: Container(
        alignment: const Alignment(0, -0.3),
        child: Text(
          'PRADA',
          style: GoogleFonts.cinzel(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildArmaniLogo(Color color) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Center(
        child: Text(
          'GA',
          style: GoogleFonts.cinzel(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(String brand, Color color) {
    final cleanName = brand.replaceAll('London', '').replaceAll('Parfums', '').trim();
    final parts = cleanName.split(' ');
    String initials = '';
    if (parts.length >= 2) {
      initials = '${parts[0][0]}${parts[1][0]}';
    } else if (cleanName.length >= 2) {
      initials = cleanName.substring(0, 2);
    } else {
      initials = cleanName;
    }
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.1), width: 1),
            ),
          ),
          Text(
            initials.toUpperCase(),
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Painters ---

class ChanelLogoPainter extends CustomPainter {
  final Color color;
  ChanelLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 3.2;
    final centerLeft = Offset(size.width / 2 - radius * 0.4, size.height / 2);
    final centerRight = Offset(size.width / 2 + radius * 0.4, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: centerLeft, radius: radius),
      0.8,
      4.7,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: centerRight, radius: radius),
      3.9,
      4.7,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GucciLogoPainter extends CustomPainter {
  final Color color;
  GucciLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    final radius = size.width / 3.2;
    final centerLeft = Offset(size.width / 2 - radius * 0.4, size.height / 2);
    final centerRight = Offset(size.width / 2 + radius * 0.4, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: centerLeft, radius: radius), 0.8, 4.7, false, paint);
    canvas.drawLine(
      Offset(centerLeft.dx + radius * 0.7, centerLeft.dy),
      Offset(centerLeft.dx + radius * 0.2, centerLeft.dy),
      paint,
    );

    canvas.drawArc(Rect.fromCircle(center: centerRight, radius: radius), 3.9, 4.7, false, paint);
    canvas.drawLine(
      Offset(centerRight.dx - radius * 0.7, centerRight.dy),
      Offset(centerRight.dx - radius * 0.2, centerRight.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VersaceLogoPainter extends CustomPainter {
  final Color color;
  VersaceLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radius = size.width / 2.3;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius - 3, paint);

    final dashPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = 0; i < 360; i += 15) {
      final angle = i * math.pi / 180;
      final x1 = center.dx + (radius - 8) * math.cos(angle);
      final y1 = center.dy + (radius - 8) * math.sin(angle);
      final x2 = center.dx + (radius - 4) * math.cos(angle);
      final y2 = center.dy + (radius - 4) * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MarlyPainter extends CustomPainter {
  final Color color;
  MarlyPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Left unimplemented
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MarlyLogoPainter extends CustomPainter {
  final Color color;
  MarlyLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.85, size.width * 0.5, size.height * 0.95);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.85, size.width * 0.2, size.height * 0.6);
    path.close();

    canvas.drawPath(path, paint);

    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.7),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.3, size.height * 0.7),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PradaLogoPainter extends CustomPainter {
  final Color color;
  PradaLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.25);
    path.lineTo(size.width * 0.9, size.height * 0.25);
    path.lineTo(size.width * 0.5, size.height * 0.85);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
