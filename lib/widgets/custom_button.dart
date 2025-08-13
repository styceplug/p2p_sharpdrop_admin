import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../utils/colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius,
    this.backgroundColor,
    this.textStyle,
    this.icon,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color effectiveBgColor = isDisabled
        ? Colors.grey.shade500.withOpacity(0.4)
        : backgroundColor ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    final Color effectiveTextColor = textStyle?.color ??
        (effectiveBgColor.computeLuminance() < 0.5 ? Colors.white : Colors.black);

    return InkWell(
      onTap: (isDisabled || isLoading) ? null : onPressed,
      borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.radius10),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height15,
          horizontal: Dimensions.width20,
        ),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: borderRadius ?? BorderRadius.circular(Dimensions.radius10),
        ),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: Colors.white, // You can theme this too if needed
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textStyle ??
                    TextStyle(
                      color: effectiveTextColor,
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }}

