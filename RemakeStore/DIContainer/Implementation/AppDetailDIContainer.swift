//
// Created by Scott Moon on 2019-05-10.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

import Swinject
import SCServiceKit

struct AppDetailDIContainer: DIContainer {

  // MARK: - Protocol Variables

  let container: Container

  // MARK: - Private

  private let service: Service
  private let appId: Int

  private(set) lazy var repository: ITunesRepository = {
    let service = self.service
    let baseUrl = "https://itunes.apple.com"
    container.register(ITunesRepository.self) { _ in
      ITunesRepository(httpClient: service.httpClient, baseUrl: baseUrl)
    }.inObjectScope(.weak)

    guard let repository = container.resolve(ITunesRepository.self) else {
      fatalError("Should be not nil")
    }
    return repository
  }()

  private lazy var viewModel: AppDetailViewModel = {
    let service = self.service
    let repository = self.repository

    container.register(AppDetailViewModel.self) { _ in
      AppDetailViewModel(
        with: service,
        repository: repository
      )
    }.inObjectScope(.weak)

    guard let viewModel = container.resolve(AppDetailViewModel.self) else {
      fatalError("Should be not nil")
    }
    return viewModel
  }()

  private lazy var controller: AppDetailController = {
    container.register(AppDetailController.self) { _ in
      AppDetailController()
    }.inObjectScope(.weak)

    guard let controller = container.resolve(AppDetailController.self) else {
      fatalError("Should be not nil")
    }

    let viewModel = self.viewModel
    let appId = self.appId
    controller.bind(to: viewModel) {
      controller.appId = appId
    }
    return controller
  }()

  // MARK: - Initializing

  init(with service: Service, appId: Int) {
    self.service = service
    self.appId = appId
    container = Container()
  }

  // MARK: Public

  mutating func getController() -> AppDetailController {
    return self.controller
  }
}
