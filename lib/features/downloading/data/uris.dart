import 'package:flutter/foundation.dart';

const pandoraWebUrl = 'https://www.pandora.com';

Uri get pandoraWebCorsUrl =>
    Uri(scheme: 'https', host: 'pandora-cors-proxy.herokuapp.com');
const usePandoraWebCorsUrl = kIsWeb;
