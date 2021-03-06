//
// Created by Scott Moon on 2019-05-04.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

import SCLayoutKit
import SCUIBuildKit
import RxSwift
import RxCocoa

class TodayController: BaseController {

  // MARK: - ViewModel

  var viewModel: TodayViewModel!
  var targetFullScreenController: FullScreenViewControllerAnimatable?
  var fullScreenStatus: ScreenStatus = .thumbnail

  // MARK: - Private

  private lazy var todayListView: TodayListView = {
    let listView = TodayListView()
    return listView
  }()

  private lazy var capView: UIView = {
    let capView = ViewBuilder()
      .setBackgroundColor(DefaultTheme.Color.secondaryColor)
      .setHeightAnchor(UIApplication.shared.statusBarFrame.height)
      .build()

    return capView
  }()

  private(set) lazy var blurVisualEffectView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    view.alpha = 0
    return view
  }()

  override func setupViews() {
    super.setupViews()
    view.addSubview(capView)
    view.addSubview(todayListView)
    view.addSubview(blurVisualEffectView)
  }

  override func setupConstraints() {
    super.setupConstraints()

    capView
      .setTopAnchor(view.topAnchor)
      .setLeadingAnchor(view.leadingAnchor)
      .setTrailingAnchor(view.trailingAnchor)

    todayListView
      .setTopAnchor(capView.bottomAnchor)
      .setLeadingAnchor(view.leadingAnchor)
      .setBottomAnchor(view.bottomAnchor)
      .setTrailingAnchor(view.trailingAnchor)

    blurVisualEffectView.fillSuperView()
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .slide
  }

  override var prefersStatusBarHidden: Bool {
    switch fullScreenStatus {
    case .thumbnail:
      return false
    default:
      return true
    }
  }
}

extension TodayController: FullScreenAnimatable {

  func setupFullscreenView(_ targetFullSceenController: FullScreenViewControllerAnimatable, info: FullScreenAnimatedInfo) {
    if nil != targetFullScreenController { return }

    if let fullScreenView = targetFullSceenController.view {
      view.addSubview(fullScreenView)
      addChild(targetFullSceenController)
    }
    targetFullSceenController.setupFullScreenLayout(startingFrame: info.startingFrame)

    targetFullScreenController = targetFullSceenController
  }

  func startFullScreenAnimation() {
    targetFullScreenController?.startFullScreenAnimation()
    UIView.defaultAnimated(
      animations: {
        self.blurVisualEffectView.alpha = 1
        self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        self.fullScreenStatus = .fullScreen
        UIView.animate(withDuration: 0.2) {
          self.setNeedsStatusBarAppearanceUpdate()
        }
        self.view.layoutIfNeeded()
      })
  }

  func dismissFullScreenAnimation() {
    targetFullScreenController?.dismissFullScreenAnimation()
    UIView.defaultAnimated(
      animations: {
        self.blurVisualEffectView.alpha = 0
        self.tabBarController?.tabBar.transform = .identity
        self.fullScreenStatus = .thumbnail
        UIView.animate(withDuration: 0.2) {
          self.setNeedsStatusBarAppearanceUpdate()
        }
        self.view.layoutIfNeeded()
      },
      completion: { result in
        if !result { return }
        self.targetFullScreenController?.view.removeFromSuperview()
        self.targetFullScreenController?.removeFromParent()
        self.targetFullScreenController = nil
      })
  }
}

extension TodayController: ViewModelBased {

  // MARK: - functions for protocol

  func bindViewModel() {
    viewWillAppearAction
      .asDriverJustComplete()
      .drive(viewModel.inputs.fetchToday)
      .disposed(by: disposeBag)

    viewModel.outputs.todayItemViewModels
      .asDriverJustComplete()
      .drive(todayListView.rx.updateTodayItemViewModels)
      .disposed(by: disposeBag)

    todayListView.rx.itemSelected
      .asObservable()
      .map { [unowned self] indexPath -> FullScreenAnimatedInfo? in
        guard
          let viewModel = self.todayListView.todayItemViewModels?[safe: indexPath.item],
          let selectedCell = self.todayListView.cellForItem(at: indexPath),
          let staringFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil)
          else { return nil }
        return FullScreenAnimatedInfo(
          todayItemViewModel: viewModel,
          startingFrame: staringFrame
        )
      }
      .ignoreNil()
      .map { AppStep.todayDetailIsRequired(fullScreenAnimatedInfo: $0) }
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
}
