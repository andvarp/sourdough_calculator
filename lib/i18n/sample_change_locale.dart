import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/i18n/i18n_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';

class SampleChangeLocale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(I18n.of(context).translate('title')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Provider.of<I18nProvider>(context, listen: false)
                      .changeLanguage(Locale("en"));
                },
                child: Text('English'),
              ),
              RaisedButton(
                onPressed: () {
                  Provider.of<I18nProvider>(context, listen: false)
                      .changeLanguage(Locale("es"));
                },
                child: Text('spanish'),
              )
            ],
          )
        ],
      ),
    );
  }
}
