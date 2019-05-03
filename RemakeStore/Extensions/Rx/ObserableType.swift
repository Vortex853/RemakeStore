//
// Created by Scott Moon on 2019-05-04.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

extension ObservableType {
  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}
