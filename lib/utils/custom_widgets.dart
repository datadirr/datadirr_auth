import 'package:datadirr_auth/auth/auth.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/fonts.dart';
import 'package:datadirr_auth/utils/plugin.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_plus/dropdown_item.dart';
import 'package:flutter_widget_function/function/utils.dart';

class DatadirrAccountAppBar extends StatelessWidget {
  final Auth? auth;
  final Function()? onBack;

  const DatadirrAccountAppBar({super.key, this.auth, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Visibility(
              visible: (onBack != null),
              child: Tap(
                  onTap: onBack, child: const Icon(Assets.icArrowBackward))),
          const HSpace(),
          Expanded(
            child: Row(
              children: [
                const CImage(Assets.imgDatadirrTxt, width: 70),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 2),
                  child: Text(Strings.account,
                      style: Styles.txtMedium(color: Colorr.accent)),
                )
              ],
            ),
          ),
          const HSpace(),
          Visibility(
              visible: (auth != null),
              child: ProfileUI(value: (auth ?? Auth()).name))
        ],
      ),
    );
  }
}

class VSpace extends StatelessWidget {
  final double? space;
  final Widget? child;

  const VSpace({super.key, this.space, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: space ?? 10, child: child);
  }
}

class HSpace extends StatelessWidget {
  final double? space;
  final Widget? child;

  const HSpace({super.key, this.space, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: space ?? 10, child: child);
  }
}

class CDivider extends StatelessWidget {
  final Color? color;
  final double? height;

  const CDivider({super.key, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return Divider(color: color ?? Colorr.grey10, height: height);
  }
}

class Tap extends StatelessWidget {
  final Function()? onTap;
  final Function()? onLongTap;
  final Widget? child;
  final Color? splashColor;
  final Color? overlayColor;

  const Tap(
      {super.key,
      this.onTap,
      this.onLongTap,
      this.child,
      this.splashColor,
      this.overlayColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor ?? Colorr.transparent,
      hoverColor: Colorr.transparent,
      overlayColor: WidgetStateProperty.all(overlayColor ?? Colorr.transparent),
      onTap: onTap,
      onLongPress: onLongTap,
      child: child,
    );
  }
}

class CProgress extends StatelessWidget {
  final double? size;
  final Color? color;

  const CProgress({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(color: color ?? Colorr.primary)));
  }
}

class LProgress extends StatelessWidget {
  final Color? color;

  const LProgress({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(color: color ?? Colorr.primary);
  }
}

class NoData extends StatelessWidget {
  final double? width;
  final double? height;

  const NoData({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CImage(Assets.imgNoData,
            width: width ?? 150, height: height ?? 150));
  }
}

class CDropdown extends StatelessWidget {
  final String selectedId;
  final List<DropdownItem> list;
  final Function(String id) onSelected;
  final TextStyle? style;
  final bool isExpanded;
  final double? fontSize;
  final String? hintText;
  final String? suffixImage;

  const CDropdown(
      {super.key,
      required this.selectedId,
      required this.list,
      required this.onSelected,
      this.style,
      this.isExpanded = false,
      this.fontSize,
      this.hintText,
      this.suffixImage});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        icon: Utils.isNullOREmpty(suffixImage)
            ? const Icon(Assets.icArrowDownward)
            : Image.asset(suffixImage!, width: 30, height: 30),
        hint: Text(
          hintText ?? "",
          style: Styles.txtRegular(
              fontSize: fontSize ?? Fonts.fontLarge, color: Colorr.grey50),
        ),
        value: Utils.isNullOREmptyORZero(selectedId) ? null : selectedId,
        items: list
            .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                value: item.id.toString(),
                child: Text(
                  item.value,
                  style: style ??
                      Styles.txtRegular(fontSize: fontSize ?? Fonts.fontLarge),
                )))
            .toList(),
        style: style,
        underline: Container(),
        isExpanded: isExpanded,
        isDense: true,
        onChanged: (id) {
          onSelected(id ?? selectedId);
        });
  }
}

class CTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final String? suffixText;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final InputBorder border;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final bool capitalize;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String? prefixImage;
  final IconData? suffixIcon;
  final String? suffixImage;
  final Function()? suffixIconTap;

  const CTextField(
      {super.key,
      this.controller,
      this.labelText,
      this.hintText,
      this.prefixText,
      this.suffixText,
      this.minLines,
      this.maxLines,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.inputType,
      this.inputFormatters,
      this.readOnly = false,
      this.enabled = true,
      this.border = const OutlineInputBorder(),
      this.onTap,
      this.onChanged,
      this.onSaved,
      this.capitalize = false,
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
      this.prefixImage,
      this.suffixIcon,
      this.suffixImage,
      this.suffixIconTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      onSaved: (value) {
        if (onSaved != null) {
          onSaved!(value);
        }
      },
      textCapitalization:
          capitalize ? TextCapitalization.characters : TextCapitalization.none,
      controller: controller,
      minLines: minLines,
      maxLines: obscureText
          ? 1
          : (minLines != null)
              ? (minLines! > (maxLines ?? 1))
                  ? minLines
                  : maxLines
              : maxLines ?? 1,
      maxLength: maxLength,
      textAlign: textAlign,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: border,
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        suffixText: suffixText,
        suffixIcon: (suffixIcon != null)
            ? Tap(
                onTap: () {
                  if (suffixIconTap != null) {
                    suffixIconTap!();
                  }
                },
                child: Icon(suffixIcon))
            : (suffixImage != null)
                ? Tap(
                    onTap: () {
                      if (suffixIconTap != null) {
                        suffixIconTap!();
                      }
                    },
                    child: Image.asset(suffixImage!))
                : null,
        prefixIcon: (prefixImage != null) ? Image.asset(prefixImage!) : null,
      ),
    );
  }
}

class CATextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool mandate;
  final String? tabText;
  final Color? tabTextColor;
  final Color? tabBGColor;
  final double? radius;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmit;
  final Function(String? value)? onSaved;
  final bool capitalize;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool displayCounter;
  final String? prefixImage;
  final Function()? prefixImageTap;
  final String? suffixImage;
  final Function()? suffixImageTap;

  const CATextField(
      {super.key,
      this.controller,
      this.labelText = "",
      this.hintText = "",
      this.mandate = false,
      this.tabText,
      this.tabTextColor,
      this.tabBGColor,
      this.radius,
      this.minLines,
      this.maxLines = 1,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.inputType,
      this.inputFormatters,
      this.readOnly = false,
      this.enabled = true,
      this.onTap,
      this.onChanged,
      this.onSubmit,
      this.onSaved,
      this.capitalize = false,
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
      this.displayCounter = false,
      this.prefixImage,
      this.prefixImageTap,
      this.suffixImage,
      this.suffixImageTap});

  @override
  Widget build(BuildContext context) {
    return CAField(
        labelText: labelText,
        mandate: mandate,
        tabText: tabText,
        tabTextColor: tabTextColor,
        tabBGColor: tabBGColor,
        radius: radius,
        prefixImage: prefixImage,
        prefixImageTap: prefixImageTap,
        suffixImage: suffixImage,
        suffixImageTap: suffixImageTap,
        child: TextFormField(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          onSaved: (value) {
            if (onSaved != null) {
              onSaved!(value);
            }
          },
          onFieldSubmitted: (value) {
            if (onSubmit != null) {
              onSubmit!(value);
            }
          },
          textCapitalization: capitalize
              ? TextCapitalization.characters
              : TextCapitalization.none,
          controller: controller,
          minLines: minLines,
          maxLines: obscureText
              ? 1
              : (minLines != null)
                  ? (minLines! > (maxLines ?? 1))
                      ? minLines
                      : maxLines
                  : maxLines,
          maxLength: maxLength,
          textAlign: textAlign,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          readOnly: readOnly,
          enabled: enabled,
          obscureText: obscureText,
          style: Styles.txtRegular(),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            counterText: displayCounter ? null : "",
            contentPadding: EdgeInsets.zero,
            hintText: hintText,
            hintStyle: Styles.txtRegular(color: Colorr.grey50),
          ),
        ));
  }
}

class CAText extends StatelessWidget {
  final String text;
  final String labelText;
  final String hintText;
  final bool mandate;
  final String? tabText;
  final Color? tabTextColor;
  final Color? tabBGColor;
  final String? prefixImage;
  final Function()? prefixImageTap;
  final String? suffixImage;
  final Function()? suffixImageTap;
  final Function()? onTap;
  final Function()? onTabTap;
  final bool hasTextField;

  const CAText(
      {super.key,
      required this.text,
      this.labelText = "",
      this.hintText = "",
      this.mandate = false,
      this.tabText,
      this.tabTextColor,
      this.tabBGColor,
      this.prefixImage,
      this.prefixImageTap,
      this.suffixImage,
      this.suffixImageTap,
      this.onTap,
      this.onTabTap,
      this.hasTextField = false});

  @override
  Widget build(BuildContext context) {
    return CAField(
        labelText: labelText,
        mandate: mandate,
        tabText: tabText,
        tabTextColor: tabTextColor,
        tabBGColor: tabBGColor,
        onTap: onTap,
        onTabTap: onTabTap,
        hasTextField: hasTextField,
        prefixImage: prefixImage,
        prefixImageTap: prefixImageTap,
        suffixImage: suffixImage,
        suffixImageTap: suffixImageTap,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            Utils.isNullOREmpty(text) ? hintText : text,
            style: Styles.txtRegular(
                color:
                    Utils.isNullOREmpty(text) ? Colorr.grey50 : Colorr.black),
          ),
        ));
  }
}

class CADropdown extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool mandate;
  final String? tabText;
  final Color? tabTextColor;
  final Color? tabBGColor;
  final String selectedId;
  final List<DropdownItem> list;
  final Function(String id) onSelected;
  final String? prefixImage;
  final Function()? prefixImageTap;
  final String? suffixImage;

  const CADropdown(
      {super.key,
      this.labelText,
      this.hintText,
      this.mandate = false,
      this.tabText,
      this.tabTextColor,
      this.tabBGColor,
      required this.selectedId,
      required this.list,
      required this.onSelected,
      this.prefixImage,
      this.prefixImageTap,
      this.suffixImage});

  @override
  Widget build(BuildContext context) {
    return CAField(
        labelText: labelText,
        mandate: mandate,
        tabText: tabText,
        tabTextColor: tabTextColor,
        tabBGColor: tabBGColor,
        prefixImage: prefixImage,
        prefixImageTap: prefixImageTap,
        child: CDropdown(
            selectedId: selectedId,
            list: list,
            isExpanded: true,
            hintText: hintText,
            suffixImage: suffixImage,
            onSelected: (id) => onSelected(id)));
  }
}

class CALabel extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool mandate;
  final String? tabText;
  final Color? tabTextColor;
  final Color? tabBGColor;
  final Function()? onTap;
  final Function()? onTabTap;

  const CALabel(
      {super.key,
      this.labelText,
      this.hintText,
      this.mandate = false,
      this.tabText,
      this.tabTextColor,
      this.tabBGColor,
      this.onTap,
      this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          (!Utils.isNullOREmpty(labelText) || !Utils.isNullOREmpty(tabText)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: !Utils.isNullOREmpty(labelText),
            child: Flexible(
                child: Row(
              children: [
                Flexible(
                  child: Text(labelText ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtMedium()),
                ),
                const HSpace(space: 2),
                Visibility(
                  visible: mandate,
                  child: Text("*",
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtRegular(color: Colorr.red50)),
                ),
              ],
            )),
          ),
          Visibility(
            visible: !Utils.isNullOREmpty(tabText),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HSpace(space: 5),
                Tap(
                  onTap: () {
                    if (onTabTap != null) {
                      onTabTap!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: Styles.boxDecoration(color: tabBGColor),
                    child: Center(
                      child: Text(tabText ?? "",
                          style: Styles.txtRegular(color: tabTextColor)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String value) onSearch;
  final Color? color;

  const SearchField(
      {super.key,
      this.controller,
      this.hintText,
      required this.onSearch,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration:
          Styles.boxDecoration(color: color ?? Colorr.grey10, radius: 30),
      child: Row(
        children: [
          Image.asset(Assets.imgSearch, width: 25, height: 25),
          const HSpace(),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText ?? Strings.searchHere),
              onChanged: (value) {
                onSearch(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CAField extends StatelessWidget {
  final Widget child;
  final String? labelText;
  final String? prefixImage;
  final Function()? prefixImageTap;
  final String? suffixImage;
  final Function()? suffixImageTap;
  final String? tabText;
  final Color? tabTextColor;
  final Color? tabBGColor;
  final double? radius;
  final Function()? onTap;
  final Function()? onTabTap;
  final bool mandate;
  final bool hasTextField;

  const CAField(
      {super.key,
      required this.child,
      this.labelText,
      this.prefixImage,
      this.prefixImageTap,
      this.suffixImage,
      this.suffixImageTap,
      this.tabText,
      this.tabTextColor,
      this.tabBGColor,
      this.radius,
      this.onTap,
      this.onTabTap,
      this.mandate = false,
      this.hasTextField = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: (!Utils.isNullOREmpty(labelText) ||
              !Utils.isNullOREmpty(tabText)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !Utils.isNullOREmpty(labelText),
                child: Flexible(
                    child: LabelText(
                        labelText: labelText ?? "", mandate: mandate)),
              ),
              Visibility(
                visible: !Utils.isNullOREmpty(tabText),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HSpace(space: 5),
                    Tap(
                      onTap: () {
                        if (onTabTap != null) {
                          onTabTap!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: Styles.boxDecoration(color: tabBGColor),
                        child: Center(
                          child: Text(tabText ?? "",
                              style: Styles.txtRegular(color: tabTextColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const VSpace(space: 2),
        Tap(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
              padding: const EdgeInsets.all(15),
              decoration: Styles.boxDecoration(
                  borderColor: hasTextField ? Colorr.grey10 : Colorr.grey10,
                  color: hasTextField ? Colorr.grey10 : Colorr.grey10,
                  radius: radius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!Utils.isNullOREmpty(prefixImage))
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tap(
                            onTap: () {
                              if (prefixImageTap != null) {
                                prefixImageTap!();
                              }
                            },
                            child: CImage(prefixImage!, width: 20, height: 20)),
                        const HSpace()
                      ],
                    ),
                  Expanded(child: child),
                  if (!Utils.isNullOREmpty(suffixImage))
                    Row(
                      children: [
                        const HSpace(),
                        Tap(
                            onTap: () {
                              if (suffixImageTap != null) {
                                suffixImageTap!();
                              }
                            },
                            child: CImage(suffixImage!, width: 20, height: 20)),
                      ],
                    )
                ],
              )),
        )
      ],
    );
  }
}

class LabelText extends StatelessWidget {
  final String labelText;
  final bool mandate;

  const LabelText({super.key, required this.labelText, this.mandate = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(labelText,
              overflow: TextOverflow.ellipsis, style: Styles.txtMedium()),
        ),
        const HSpace(space: 2),
        Visibility(
          visible: mandate,
          child: Text("*",
              overflow: TextOverflow.ellipsis,
              style: Styles.txtRegular(color: Colorr.red50)),
        ),
      ],
    );
  }
}

class CButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? width;
  final double? height;
  final Color? backColor;
  final Color? textColor;
  final double? fontSize;
  final Color? borderColor;
  final bool loading;
  final Color? loaderColor;
  final double? radius;
  final TextStyle? textStyle;

  const CButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width,
      this.height,
      this.backColor,
      this.textColor,
      this.fontSize,
      this.borderColor,
      this.loading = false,
      this.loaderColor,
      this.radius,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        if (!loading) {
          onTap();
        }
      },
      child: Container(
        width: width,
        height: height ?? 40,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        decoration: Styles.boxDecoration(
            color: loading ? Colorr.grey20 : backColor ?? Colorr.primary,
            borderColor: borderColor,
            radius: radius),
        child: Center(
            child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              Styles.txtMedium(
                  color: textColor ?? Colorr.white, fontSize: fontSize),
        )),
      ),
    );
  }
}

class CTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? width;
  final double? height;
  final Color? backColor;
  final Color? textColor;
  final double? fontSize;
  final Color? borderColor;
  final bool loading;
  final Color? loaderColor;
  final double? radius;
  final TextStyle? textStyle;

  const CTextButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width,
      this.height,
      this.backColor,
      this.textColor,
      this.fontSize,
      this.borderColor,
      this.loading = false,
      this.loaderColor,
      this.radius,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        if (!loading) {
          onTap();
        }
      },
      child: Container(
        width: width,
        height: height ?? 40,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        decoration:
            Styles.boxDecoration(borderColor: borderColor, radius: radius),
        child: Center(
            child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              Styles.txtMedium(
                  color: loading ? Colorr.grey20 : textColor ?? Colorr.primary,
                  fontSize: fontSize),
        )),
      ),
    );
  }
}

class Touch extends StatelessWidget {
  final bool? disable;
  final Widget? child;

  const Touch({super.key, this.disable, this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(ignoring: disable ?? false, child: child);
  }
}

class TicketView extends StatelessWidget {
  final Color? color;
  final Color? foregroundColor;
  final Widget? childTop;
  final Widget? childBottom;

  const TicketView(
      {super.key,
      this.color,
      this.foregroundColor,
      this.childTop,
      this.childBottom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: color ?? Colorr.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: childTop,
        ),
        Container(
          color: color ?? Colorr.white,
          child: Row(
            children: [
              SizedBox(
                width: 15,
                height: 25,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: foregroundColor ?? Colorr.grey10),
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            (constraints.constrainWidth() / 15).floor(),
                            (index) => SizedBox(
                                  height: 2,
                                  width: 10,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: foregroundColor ??
                                              Colorr.grey10)),
                                ))),
                  );
                }),
              ),
              SizedBox(
                width: 15,
                height: 25,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: foregroundColor ?? Colorr.grey10),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: color ?? Colorr.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: childBottom,
        ),
      ],
    );
  }
}

class LVText extends StatelessWidget {
  final String? label;
  final String value;

  const LVText({super.key, this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label ?? "",
            overflow: TextOverflow.ellipsis,
            style: Styles.txtThin(
                color: Colorr.grey50, fontSize: Fonts.fontSmall)),
        Text(value,
            overflow: TextOverflow.ellipsis, style: Styles.txtRegular()),
      ],
    );
  }
}

class PoweredByUI extends StatelessWidget {
  const PoweredByUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Strings.poweredBy,
                style: Styles.txtRegular(
                    color: Colorr.grey50, fontSize: Fonts.fontXXSmall)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.imgDatadirrLogo, width: 15, height: 15),
                const HSpace(space: 2),
                Text(Plugin.company, style: Styles.txtMedium()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileUI extends StatelessWidget {
  final String value;
  final double? size;
  final double? fontSize;
  final double? radius;

  const ProfileUI(
      {super.key, required this.value, this.size, this.fontSize, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 30,
      height: size ?? 30,
      decoration: Styles.boxDecoration(
          color: Colorr.primary,
          borderColor: Colorr.grey10,
          radius: radius ?? 20),
      child: Center(
          child: Text((value.isNotEmpty ? value[0] : ""),
              style:
                  Styles.txtRegular(color: Colorr.white, fontSize: fontSize))),
    );
  }
}

class CImage extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;

  const CImage(this.assetName, {super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetName,
        width: width, height: height, package: Plugin.package);
  }
}

class InfoUI extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const InfoUI(
      {super.key,
      required this.title,
      required this.message,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Styles.txtMedium()),
        const VSpace(space: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const HSpace(),
            Expanded(child: Text(message, style: Styles.txtThin())),
          ],
        )
      ],
    );
  }
}
