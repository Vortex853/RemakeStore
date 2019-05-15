//
// Created by Scott Moon on 2019-05-04.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

import RxFlow

class AppsFlow: BaseFlow {

  // MARK: - Protocol Variables

  let service: Service

  var root: Presentable {
    return rootViewController
  }

  // MARK: - Private

  private lazy var rootViewController: UINavigationController = {
    var container = AppsDIContainer(with: service)
    return container.navigationController
  }()

  // MARK: - Initializing

  required init(with service: Service) {
    self.service = service
  }

  // MARK: - functions for protocol

  internal func navigate(to step: AppStep) -> FlowContributors {
    switch step {
    case .dashboardIsComplete:
      return navigateToAppsScreen()
    case .appDetailIsRequired(let appId):
      return navigateToAppDetail(with: appId)
    case .appDetailIsComplete:
      return dismissAppDetailScreen()
    default:
      return .none
    }
  }
}

extension AppsFlow {
  private func navigateToAppsScreen() -> FlowContributors {
    var container = AppsDIContainer(with: service)
    let controller = container.getController()
    rootViewController.setViewControllers([controller], animated: false)

    let contributor = FlowContributor.contribute(
      withNextPresentable: controller,
      withNextStepper: controller
    )

    return .one(flowContributor: contributor)
  }

  private func navigateToAppDetail(with appId: Int) -> FlowContributors {
    var container = AppDetailDIContainer(with: service, appId: appId)
    let controller = container.getController()
    rootViewController.pushViewController(controller, animated: true)

    let contributor = FlowContributor.makeContributor(withNextPresentable: controller)

    return .one(flowContributor: contributor)
  }

  private func dismissAppDetailScreen() -> FlowContributors {
    rootViewController.popViewController(animated: true)
    return .none
  }

}
