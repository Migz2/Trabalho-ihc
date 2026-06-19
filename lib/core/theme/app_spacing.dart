/// Standardized spacing values for consistent layout
/// Using a scale: xs(4), sm(8), md(16), lg(24), xl(32), xxl(48)
class AppSpacing {
  AppSpacing._();

  /// 4px - Extra small spacing (tight layouts, minor gaps)
  static const double xs = 4.0;

  /// 8px - Small spacing (button padding, minor margins)
  static const double sm = 8.0;

  /// 16px - Medium spacing (standard margins, card padding)
  static const double md = 16.0;

  /// 24px - Large spacing (section separation, larger padding)
  static const double lg = 24.0;

  /// 32px - Extra large spacing (major section gaps)
  static const double xl = 32.0;

  /// 48px - Double extra large spacing (major layout sections)
  static const double xxl = 48.0;

  // ─────────────────────────────────────────────
  // COMMON COMBINATIONS
  // ─────────────────────────────────────────────

  /// Standard horizontal padding for full-width sections
  static const double screenPadding = md;

  /// Standard vertical spacing between major sections
  static const double sectionSpacing = lg;

  /// Standard gap between list items
  static const double listItemGap = sm;

  /// Standard gap inside cards
  static const double cardPadding = md;

  /// Standard gap between card elements
  static const double cardElementGap = sm;

  /// Standard padding for buttons
  static const double buttonPaddingH = lg;
  static const double buttonPaddingV = md;

  /// Standard gap in horizontal layouts (row)
  static const double rowGap = md;

  /// Standard gap in vertical layouts (column)
  static const double columnGap = md;

  /// Standard gap between form fields
  static const double formFieldGap = md;

  /// Standard bottom padding for keyboard offset
  static const double keyboardPadding = xl;

  /// Standard icon size small
  static const double iconSmall = 16.0;

  /// Standard icon size medium
  static const double iconMedium = 24.0;

  /// Standard icon size large
  static const double iconLarge = 32.0;
}
