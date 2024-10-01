import 'package:datadirr_auth/data/country/country.dart';
import 'package:datadirr_auth/utils/assets.dart';
import 'package:datadirr_auth/utils/colorr.dart';
import 'package:datadirr_auth/utils/common.dart';
import 'package:datadirr_auth/utils/custom_widgets.dart';
import 'package:datadirr_auth/utils/strings.dart';
import 'package:datadirr_auth/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_function/function/utils.dart';

class CountrySelection extends StatefulWidget {
  final Country? country;
  final Function(BuildContext context, Country country)? onSelected;

  const CountrySelection({super.key, this.country, this.onSelected});

  @override
  State<CountrySelection> createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  bool _loading = false;
  List<Country> _fList = [];
  List<Country> _countryList = [];
  final TextEditingController _conSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _getCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorr.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(children: [
          Row(
            children: [
              Tap(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Assets.icArrowBackward)),
              const HSpace(),
              Expanded(
                  child: Text(Strings.countries,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.txtMedium())),
            ],
          ),
          const VSpace(),
          CATextField(
            controller: _conSearch,
            hintText: Strings.searchHere,
            prefixImage: Assets.imgSearch,
            radius: 30,
            onChanged: (value) => _onSearch(value),
          ),
          const VSpace(),
          _loading
              ? const CProgress()
              : _fList.isEmpty
                  ? const NoData()
                  : Expanded(
                      child: ListView.separated(
                        key: Common.pageStorageKey(),
                        itemCount: _fList.length,
                        itemBuilder: (context, index) {
                          return _itemViewCountry(_fList[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const CDivider();
                        },
                      ),
                    )
        ]),
      )),
    );
  }

  _itemViewCountry(Country country) {
    return Tap(
      onTap: () {
        _selected(country);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: Styles.boxDecoration(
          color: country.selected ? Colorr.grey10 : Colorr.white,
        ),
        child: Text("${country.countryName} (${country.countryPhoneCodePlus})",
            overflow: TextOverflow.ellipsis, style: Styles.txtRegular()),
      ),
    );
  }

  _getCountry() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _fList = _countryList = await Country.countries(country: widget.country);
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  _onSearch(String value) {
    if (Utils.isNullOREmpty(value)) {
      if (mounted) {
        setState(() {
          _fList = _countryList;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _fList = _countryList
              .where((element) => (element.countryName
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.countryCodeISO3
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.countryPhoneCode
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.countryPhoneCodePlus
                      .toLowerCase()
                      .contains(value.toLowerCase())))
              .toList();
        });
      }
    }
  }

  _selected(Country country) {
    if (widget.onSelected == null) {
      Navigator.pop(context, country);
    } else {
      widget.onSelected!(context, country);
    }
  }
}
