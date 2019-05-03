//
// Created by Scott Moon on 2019-05-03.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import Foundation

import SCServiceKit

struct AppService {

  private let _httpClient: HTTPClient
  private let _translator: Translator
  private let _logger: Logger

  init(httpClient: HTTPClient, translator: Translator, logger: Logger) {
    _httpClient = httpClient
    _translator = translator
    _logger = logger
  }
}

extension AppService: Service {

  var httpClient: HTTPClient {
    return _httpClient
  }

  var translator: Translator {
    return _translator
  }

  var logger: Logger {
    return _logger
  }
}
