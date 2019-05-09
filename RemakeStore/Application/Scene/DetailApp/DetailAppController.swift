//
// Created by Scott Moon on 2019-05-04.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

import RxSwift

class DetailAppController: BaseController {

  // MARK: - ViewModel

  var viewModel: DetailAppViewModel!

  var appId: Int!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
  }

}

extension DetailAppController: ViewModelBased {

  func bindViewModel() {

    Observable.just(appId)
      .bind(to: viewModel.appId)
      .disposed(by: disposeBag)

  }
}
