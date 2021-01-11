import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pandora_toolbox/core/bloc/manifest/manifest_bloc.dart';
import 'package:pandora_toolbox/core/widgets/app_page_transitions_builder.dart';
import 'package:pandora_toolbox/features/endpoints/bloc/endpoint/endpoint_bloc.dart';
import 'package:pandora_toolbox/features/endpoints/ui/pages/endpoint_page.dart';
import 'package:pandora_toolbox/features/home/ui/pages/home_page.dart';
import 'package:pandora_toolbox/features/source/bloc/source/source_bloc.dart';
import 'package:pandora_toolbox/features/source/ui/pages/source_page.dart';
import 'package:pandora_toolbox/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<Client>(
      create: (_) => Client(),
      dispose: (_, client) => client.close(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ManifestBloc(Provider.of(context, listen: false)),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => SourceBloc(
              Provider.of(context, listen: false),
              BlocProvider.of(context, listen: false),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => EndpointBloc(
              BlocProvider.of<SourceBloc>(context, listen: false)
                  .fileUpdatedStream,
            ),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'Pandora Toolbox',
          theme: FlexColorScheme.light(
            colors: customFlexScheme.light,
            appBarElevation: 4,
          ).toTheme.copyWith(
              pageTransitionsTheme:
                  AppPageTransitionsBuilder.pageTransitionsTheme),
          darkTheme: FlexColorScheme.dark(
            colors: customFlexScheme.dark,
            appBarElevation: 4,
          ).toTheme.copyWith(
              pageTransitionsTheme:
                  AppPageTransitionsBuilder.pageTransitionsTheme),
          routes: {
            HomePage.path: (_) => const HomePage(),
            EndpointPage.path: (_) => const EndpointPage(),
            SourcePage.path: (_) => const SourcePage(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
