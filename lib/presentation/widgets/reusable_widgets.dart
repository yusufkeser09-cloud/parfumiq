import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/perfume_model.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: GoogleFonts.outfit().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final bool isFullWidth;
  final IconData? icon;

  const PremiumButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.isFullWidth = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = isSecondary
        ? OutlinedButton.styleFrom(
            foregroundColor: AppTheme.accentGold,
            side: BorderSide(color: AppTheme.accentGold, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGold,
            foregroundColor: AppTheme.primaryBlack,
            elevation: 4,
            shadowColor: AppTheme.accentGold.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppTheme.brightGold, width: 1),
            ),
          );

    final buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );

    final button = isSecondary
        ? OutlinedButton(onPressed: onPressed, child: buttonChild, style: style)
        : ElevatedButton(onPressed: onPressed, child: buttonChild, style: style);

    return InteractiveScale(
      child: isFullWidth ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

class VerdictBadge extends StatelessWidget {
  final String verdict;

  const VerdictBadge({Key? key, required this.verdict}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAlinir = verdict.toLowerCase().contains('alınır');
    final isDegmez = verdict.toLowerCase().contains('değmez') || verdict.toLowerCase().contains('alınmaz');

    String shortText = 'DENGELİ';
    Color bgColor = AppTheme.secondaryBlack;
    Color textColor = AppTheme.accentGold;
    Color borderColor = AppTheme.accentGold.withOpacity(0.5);

    if (isAlinir) {
      shortText = 'ALINIR';
      bgColor = AppTheme.statusSuccess.withOpacity(0.15);
      textColor = AppTheme.statusSuccess;
      borderColor = AppTheme.statusSuccess.withOpacity(0.5);
    } else if (isDegmez) {
      shortText = 'DEĞMEZ';
      bgColor = AppTheme.statusDanger.withOpacity(0.15);
      textColor = AppTheme.statusDanger;
      borderColor = AppTheme.statusDanger.withOpacity(0.5);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        shortText,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class RiskBadge extends StatelessWidget {
  final String risk;

  const RiskBadge({Key? key, required this.risk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = AppTheme.accentGold;
    if (risk.contains('Güvenli')) {
      color = AppTheme.statusSuccess;
    } else if (risk.contains('Dengeli')) {
      color = AppTheme.statusWarning;
    } else {
      color = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        risk,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class ScentTagChip extends StatelessWidget {
  final String text;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback? onTap;

  const ScentTagChip({
    Key? key,
    required this.text,
    this.isSelectable = false,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color bgColor = isSelected 
        ? AppTheme.accentGold 
        : (isDark ? AppTheme.secondaryBlack : AppTheme.cleanWhite);
    Color textColor = isSelected 
        ? AppTheme.primaryBlack 
        : (isDark ? AppTheme.textLight : AppTheme.textDark);
    Color borderColor = isSelected 
        ? AppTheme.accentGold 
        : (isDark ? AppTheme.darkBrown : AppTheme.borderGray);
    Color shadowColor = AppTheme.accentGold.withOpacity(0.2);

    if (isSelected) {
      if (text.contains('Temiz') || text.contains('🌊') || text.contains('Ferah')) {
        bgColor = const Color(0xFF0288D1);
        textColor = Colors.white;
        borderColor = const Color(0xFF0288D1);
        shadowColor = const Color(0xFF0288D1).withOpacity(0.3);
      } else if (text.contains('Tatlı') || text.contains('🍭') || text.contains('Şekerli')) {
        bgColor = const Color(0xFFD81B60);
        textColor = Colors.white;
        borderColor = const Color(0xFFD81B60);
        shadowColor = const Color(0xFFD81B60).withOpacity(0.3);
      } else if (text.contains('Odunsu') || text.contains('🪵') || text.contains('Kuru')) {
        bgColor = const Color(0xFF6D4C41);
        textColor = Colors.white;
        borderColor = const Color(0xFF6D4C41);
        shadowColor = const Color(0xFF6D4C41).withOpacity(0.3);
      } else if (text.contains('Baharatlı') || text.contains('🌶️') || text.contains('Oryantal')) {
        bgColor = const Color(0xFFE64A19);
        textColor = Colors.white;
        borderColor = const Color(0xFFE64A19);
        shadowColor = const Color(0xFFE64A19).withOpacity(0.3);
      } else if (text.contains('Vanilyalı') || text.contains('🍦') || text.contains('Gurme')) {
        bgColor = const Color(0xFFFDD835);
        textColor = const Color(0xFF4E342E);
        borderColor = const Color(0xFFFDD835);
        shadowColor = const Color(0xFFFDD835).withOpacity(0.3);
      } else if (text.contains('Ud') || text.contains('🕌') || text.contains('Reçinemsi')) {
        bgColor = const Color(0xFF8E24AA);
        textColor = Colors.white;
        borderColor = const Color(0xFF8E24AA);
        shadowColor = const Color(0xFF8E24AA).withOpacity(0.3);
      } else if (text.contains('Pudralı') || text.contains('🧼') || text.contains('Sabunsu')) {
        bgColor = const Color(0xFF00ACC1);
        textColor = Colors.white;
        borderColor = const Color(0xFF00ACC1);
        shadowColor = const Color(0xFF00ACC1).withOpacity(0.3);
      } else if (text.contains('Çiçeksi') || text.contains('🌹') || text.contains('Romantik')) {
        bgColor = const Color(0xFFE91E63);
        textColor = Colors.white;
        borderColor = const Color(0xFFE91E63);
        shadowColor = const Color(0xFFE91E63).withOpacity(0.3);
      } else if (text.contains('Narenciye') || text.contains('🍋') || text.contains('Limonsu')) {
        bgColor = const Color(0xFFFFEB3B);
        textColor = Colors.black;
        borderColor = const Color(0xFFFFEB3B);
        shadowColor = const Color(0xFFFFEB3B).withOpacity(0.3);
      } else if (text.contains('Amber') || text.contains('🔥') || text.contains('Sıcak')) {
        bgColor = const Color(0xFFF57C00);
        textColor = Colors.white;
        borderColor = const Color(0xFFF57C00);
        shadowColor = const Color(0xFFF57C00).withOpacity(0.3);
      }
    }

    Widget chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isSelected
            ? [BoxShadow(color: shadowColor, blurRadius: 4, offset: const Offset(0, 2))]
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: textColor,
        ),
      ),
    );

    if (isSelectable && onTap != null) {
      return InteractiveScale(
        onTap: onTap,
        child: chip,
      );
    }
    return chip;
  }
}

class PerfumeCard extends StatelessWidget {
  final PerfumeModel perfume;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const PerfumeCard({
    Key? key,
    required this.perfume,
    this.onFavoriteTap,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InteractiveScale(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/perfume/${perfume.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Perfume Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      perfume.imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        color: isDark ? AppTheme.secondaryBlack : AppTheme.bgCream,
                        child: Icon(Icons.image_not_supported_outlined, color: AppTheme.accentGold, size: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Perfume Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    perfume.brand.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    perfume.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (onFavoriteTap != null)
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? AppTheme.statusDanger : AppTheme.accentGold,
                                ),
                                onPressed: onFavoriteTap,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                        SizedBox(height: 6),
                        // Suitability Badges
                        Row(
                          children: [
                            RiskBadge(risk: perfume.riskLevel),
                            SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.darkBrown : AppTheme.bgCream,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                perfume.priceBand,
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                perfume.fragranceFamily,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Davud Comment Snippet
              Text(
                perfume.davudComment,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
              ),
              SizedBox(height: 12),
              // Net Verdict
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ScentIQ Kararı:',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  VerdictBadge(verdict: perfume.netVerdict),
                ],
              ),
              SizedBox(height: 6),
              Text(
                perfume.netVerdict,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class ElegantDiagonalBackground extends StatelessWidget {
  final Widget child;
  const ElegantDiagonalBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0908) : const Color(0xFFF7F4EB),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: isDark ? DiagonalStripesPainter() : LightDiagonalStripesPainter(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Band 1 (subtle diagonal stripe)
    final path1 = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(-size.width * 0.2, size.height)
      ..close();
    paint.shader = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.025),
        Colors.white.withOpacity(0.0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, paint);

    // Band 2 (slightly brighter stripe next to it)
    final path2 = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..close();
    paint.shader = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.04),
        Colors.white.withOpacity(0.0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path2, paint);

    // Band 3 (right side)
    final path3 = Path()
      ..moveTo(size.width * 0.7, 0)
      ..lineTo(size.width * 1.2, 0)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.4, size.height)
      ..close();
    paint.shader = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.02),
        Colors.white.withOpacity(0.0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LightDiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final path1 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(-size.width * 0.1, size.height)
      ..close();
    paint.shader = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.35),
        Colors.white.withOpacity(0.0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InteractiveScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final double hoverScaleFactor;
  final bool enableHoverBackground;

  const InteractiveScale({
    Key? key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.95,
    this.hoverScaleFactor = 1.05,
    this.enableHoverBackground = false,
  }) : super(key: key);

  @override
  State<InteractiveScale> createState() => _InteractiveScaleState();
}

class _InteractiveScaleState extends State<InteractiveScale> {
  double _scale = 1.0;
  bool _isHovered = false;
  bool _isPressed = false;

  void _updateScale() {
    setState(() {
      if (_isPressed) {
        _scale = widget.scaleFactor; // Scale down on press (e.g. 0.95)
      } else if (_isHovered) {
        _scale = widget.hoverScaleFactor; // Smoothly scale up on hover (puff up effect)
      } else {
        _scale = 1.0; // Return to normal
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDark 
        ? Colors.white.withOpacity(0.05) 
        : Colors.black.withOpacity(0.04);

    Widget innerChild = widget.child;

    if (widget.enableHoverBackground) {
      innerChild = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered ? hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.child,
      );
    }

    Widget result = AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: innerChild,
    );

    if (widget.onTap != null) {
      result = GestureDetector(
        onTapDown: (_) {
          _isPressed = true;
          _updateScale();
        },
        onTapUp: (_) {
          _isPressed = false;
          _updateScale();
        },
        onTapCancel: () {
          _isPressed = false;
          _updateScale();
        },
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    return MouseRegion(
      onEnter: (_) {
        _isHovered = true;
        _updateScale();
      },
      onExit: (_) {
        _isHovered = false;
        _updateScale();
      },
      cursor: SystemMouseCursors.click,
      child: result,
    );
  }
}

class PremiumBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PremiumBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.secondaryBlack : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _BottomTabItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Ana Sayfa',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: 'Favoriler',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                icon: Icons.workspace_premium_outlined,
                activeIcon: Icons.workspace_premium,
                label: 'Premium',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                icon: Icons.door_sliding_outlined,
                activeIcon: Icons.door_sliding,
                label: 'Dolap',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ),
            Expanded(
              child: _BottomTabItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Ayarlar',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomTabItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomTabItem({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_BottomTabItem> createState() => _BottomTabItemState();
}

class _BottomTabItemState extends State<_BottomTabItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.accentGold;
    final inactiveColor = AppTheme.textMuted;
    
    Color targetColor = widget.isSelected 
        ? activeColor 
        : (_isHovered ? activeColor.withOpacity(0.9) : inactiveColor);

    double scale = 1.0;
    if (_isPressed) {
      scale = 0.92;
    } else if (_isHovered) {
      scale = 1.05;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isSelected 
                  ? AppTheme.accentGold.withOpacity(0.08) 
                  : (_isHovered 
                      ? (Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withOpacity(0.05) 
                          : Colors.black.withOpacity(0.04))
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedRotation(
                  turns: widget.isSelected ? 0.0 : (_isHovered ? -0.02 : 0.0),
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isSelected ? widget.activeIcon : widget.icon,
                    color: targetColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                    color: targetColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: widget.isSelected ? 16 : (_isHovered ? 8 : 0),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ParfumIQLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const ParfumIQLogo({
    Key? key,
    this.size = 28.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppTheme.accentGold;
    return SizedBox(
      width: size * 0.85,
      height: size,
      child: CustomPaint(
        painter: BrandLogoPainter(color: logoColor),
      ),
    );
  }
}

class BrandLogoPainter extends CustomPainter {
  final Color color;

  BrandLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Solid Paint for filled elements
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Stroke Paint for outlines (thick, smooth)
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Thicker outline for main bottle body
    final bodyStrokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;

    // 1. Draw Cap (solid filled rectangle with small rounded corners)
    final capRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, h * 0.06, w * 0.28, h * 0.15),
      Radius.circular(w * 0.03),
    );
    canvas.drawRRect(capRRect, fillPaint);

    // 2. Draw Neck (solid filled connector)
    final neckRect = Rect.fromLTWH(w * 0.42, h * 0.21, w * 0.16, h * 0.06);
    canvas.drawRect(neckRect, fillPaint);

    // 3. Draw Bottle Body Frame (hollow rounded rectangle)
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.27, w * 0.7, h * 0.65),
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(bodyRRect, bodyStrokePaint);

    // 4. Draw Monogram "I" (serif style) inside the bottle
    final double ix = w * 0.38;
    final double iyTop = h * 0.44;
    final double iyBottom = h * 0.74;
    final double iWidth = w * 0.06;

    // Draw main vertical bar of "I"
    canvas.drawRect(
      Rect.fromLTWH(ix - iWidth / 2, iyTop + h * 0.04, iWidth, iyBottom - iyTop - h * 0.08),
      fillPaint,
    );
    // Draw top serif bar
    canvas.drawRect(
      Rect.fromLTWH(ix - w * 0.09, iyTop, w * 0.18, h * 0.04),
      fillPaint,
    );
    // Draw bottom serif bar
    canvas.drawRect(
      Rect.fromLTWH(ix - w * 0.09, iyBottom, w * 0.18, h * 0.04),
      fillPaint,
    );

    // 5. Draw Monogram "Q"
    final double qx = w * 0.58;
    final double qy = h * 0.58;
    final double qRadius = w * 0.15;

    final qStrokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05;

    // Draw Q circle
    canvas.drawCircle(Offset(qx, qy), qRadius, qStrokePaint);

    // Draw Q tail (flowing curve from inside Q to bottom right)
    final qTailPath = Path()
      ..moveTo(qx + qRadius * 0.3, qy + qRadius * 0.3)
      ..quadraticBezierTo(
        qx + qRadius * 0.8,
        qy + qRadius * 0.8,
        qx + qRadius * 1.3,
        qy + qRadius * 1.1,
      );
    
    final tailPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(qTailPath, tailPaint);
  }

  @override
  bool shouldRepaint(covariant BrandLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class ScentKeycapChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ScentKeycapChip({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Keycap style colors
    final Color topColor = isSelected 
        ? AppTheme.accentGold.withOpacity(0.15)
        : (isDark ? const Color(0xFF2A2928) : const Color(0xFFE8E5DC));
        
    final Color bottomColor = isSelected
        ? AppTheme.accentGold.withOpacity(0.05)
        : (isDark ? const Color(0xFF141312) : const Color(0xFFCFCAC0));

    final Color borderColor = isSelected
        ? AppTheme.accentGold
        : (isDark ? const Color(0xFF42403D) : const Color(0xFFB0AAB0));

    final Color innerBevelColor = isSelected
        ? AppTheme.accentGold.withOpacity(0.3)
        : (isDark ? const Color(0xFF5A5855) : const Color(0xFFFFFFFF));

    final Color textColor = isSelected
        ? AppTheme.accentGold
        : (isDark ? AppTheme.textLight : AppTheme.textDark);

    return InteractiveScale(
      onTap: onTap,
      scaleFactor: 0.96,
      hoverScaleFactor: 1.04,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(3.0), // Create the 3D keycap edge effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              borderColor.withOpacity(0.9),
              borderColor.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
              blurRadius: isSelected ? 8 : 4,
              spreadRadius: isSelected ? 1 : 0,
              offset: isSelected ? const Offset(0, 2) : const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            gradient: LinearGradient(
              colors: [topColor, bottomColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: innerBevelColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class ParfumIQWordmarkLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const ParfumIQWordmarkLogo({
    Key? key,
    this.size = 100.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppTheme.accentGold;
    return SizedBox(
      width: size * 3.2,
      height: size,
      child: CustomPaint(
        painter: WordmarkLogoPainter(color: logoColor),
      ),
    );
  }
}

class WordmarkLogoPainter extends CustomPainter {
  final Color color;

  WordmarkLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final double fontSize = h * 0.45;
    final textStyle = GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 5.0,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: 'PARFÜMIQ', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final double textX = (w - textPainter.width) / 2;
    final double textY = (h - textPainter.height) / 2;
    final Offset textOffset = Offset(textX, textY);

    // 1. Wave lines behind text
    final wavePaint1 = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.035
      ..strokeCap = StrokeCap.round;

    final wavePaint2 = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.015
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(textX - w * 0.05, textY + textPainter.height * 0.75);
    path1.cubicTo(
      textX + w * 0.25, textY - h * 0.05,
      textX + w * 0.45, textY + textPainter.height + h * 0.15,
      textX + w * 0.75, textY + textPainter.height * 0.45,
    );
    path1.cubicTo(
      textX + w * 0.9, textY - h * 0.02,
      textX + w * 0.98, textY + textPainter.height * 0.55,
      textX + w * 1.05, textY + textPainter.height * 0.75,
    );

    final path2 = Path();
    path2.moveTo(textX - w * 0.03, textY + textPainter.height * 0.85);
    path2.cubicTo(
      textX + w * 0.28, textY + h * 0.02,
      textX + w * 0.4, textY + textPainter.height + h * 0.08,
      textX + w * 0.7, textY + textPainter.height * 0.55,
    );
    path2.cubicTo(
      textX + w * 0.85, textY + h * 0.08,
      textX + w * 0.93, textY + textPainter.height * 0.65,
      textX + w * 1.0, textY + textPainter.height * 0.85,
    );

    canvas.drawPath(path1, wavePaint1);
    canvas.drawPath(path2, wavePaint2);

    // 2. Paint text
    textPainter.paint(canvas, textOffset);

    // 3. Diamonds
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double qCenterX = textX + textPainter.width - fontSize * 0.52;
    final double qCenterY = textY + textPainter.height * 0.58;

    // Inside Q
    _drawDiamond(canvas, Offset(qCenterX, qCenterY), fontSize * 0.18, fontSize * 0.25, fillPaint);

    // Above Q
    final double star1X = qCenterX + fontSize * 0.42;
    final double star1Y = textY - fontSize * 0.05;
    _drawDiamond(canvas, Offset(star1X, star1Y), fontSize * 0.15, fontSize * 0.22, fillPaint);

    // Above I
    final double star2X = textX + textPainter.width - fontSize * 1.25;
    final double star2Y = textY - fontSize * 0.12;
    _drawDiamond(canvas, Offset(star2X, star2Y), fontSize * 0.10, fontSize * 0.15, fillPaint);
  }

  void _drawDiamond(Canvas canvas, Offset center, double width, double height, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - height / 2)
      ..lineTo(center.dx + width / 2, center.dy)
      ..lineTo(center.dx, center.dy + height / 2)
      ..lineTo(center.dx - width / 2, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WordmarkLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
