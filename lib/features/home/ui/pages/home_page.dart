import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pandora_toolbox/core/widgets/app_app_bar.dart';
import 'package:pandora_toolbox/core/widgets/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const path = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _readmeTextFuture = rootBundle.loadString('README.md');

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      scaffoldBuilder: (_, drawer, body) {
        return Scaffold(
          appBar: AppAppBar(),
          drawer: drawer,
          body: body,
        );
      },
      bodyBuilder: (_, __) {
        return Center(
          child: FutureBuilder<String>(
            future: _readmeTextFuture,
            builder: (context, snapshot) {
              return Markdown(
                data: snapshot.data ?? '',
//                 data: '''
// # Pandora Toolbox
// Welcome to Pandora Toolbox! If you're not in the web app already, it can be accessed [here](https://epimetheusmusicplayer.github.io/pandora_toolbox).
//
// ## Introduction
// This is a collection of tools that analyse the Pandora Web app and provide access to Pandora APIs.
//
// ## How does it work?
// Pandora Toolbox uses the following methods to provide tools:
// 1. Analyzing source code from the Pandora Web client
// 2. Making Pandora API requests
//
// All data is dynamically downloaded directly from Pandora; none of it is hard-coded.
// The only connections that are made to anything other than Pandora to use the tools are the occasional connections through a [CORS stripper proxy](https://github.com/Freeboard/thingproxy).
//
// ## Can I trust Pandora Toolbox with my Pandora credentials?
// API requests on the web are made through the proxy linked above. It's up to you.
// On other platforms, requests are made to Pandora directly - so the answer in those cases is absolutely.
//                 ''',
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(textScaleFactor: 1.25),
                padding: EdgeInsets.all(32),
                onTapLink: (_, href, __) {
                  launchUrl(Uri.parse(href!));
                },
              );
            },
          ),
        );
      },
    );
  }
}
