//
// Created by Scott Moon on 2019-05-16.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import XCTest
import UIKit

@testable import RemakeStore

class TodayListViewSpec: XCTestCase {

  var sut: TodayListView?

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func test_init() {
    sut = TodayListView()

    XCTAssertNotNil(sut)
  }

  func test_dataSource_numberOfItemsInSection() {
    let expectedCount = 10

    sut = TodayListView()

    guard
      let sut = sut,
      let dataSource = sut.dataSource
      else {
        fatalError("Should be not nil")
    }

    let resultCount = dataSource.collectionView(sut, numberOfItemsInSection: 0)

    XCTAssertEqual(expectedCount, resultCount)
  }

  func test_dataSource_cellForItemAt() {
    sut = TodayListView()
    guard
      let sut = sut,
      let dataSource = sut.dataSource
      else {
        fatalError("Should be not nil")
    }

    let resultCell = dataSource.collectionView(sut, cellForItemAt: [0, 0])

    XCTAssertNotNil(resultCell as? TodayFullBackgroundCell)
  }

  func test_dataSource_viewForSupplementaryElementOfKind() {

    sut = TodayListView()
    guard
      let sut = sut,
      let dataSource = sut.dataSource
      else {
        fatalError("Should be not nil")
    }

    _ = dataSource.collectionView(sut, cellForItemAt: [0, 3])
    let resultHeader = dataSource.collectionView?(sut, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: [0, 3])

    XCTAssertNotNil(resultHeader as? TodayHeader)
  }

  func test_delegate_referenceSizeForHeaderInSection() {
    let expectedHeight: CGFloat = 85

    sut = TodayListView()
    guard
      let sut = sut,
      let delegate = sut.delegate as? UICollectionViewDelegateFlowLayout,
      let layout = sut.collectionViewLayout as? UICollectionViewFlowLayout
      else {
        fatalError("Should be not nil")
    }

    let resultSize = delegate.collectionView?(sut, layout: layout, referenceSizeForHeaderInSection: 0)

    XCTAssertEqual(expectedHeight, resultSize?.height)
  }

  func test_delegate_sizeForItemAt() {
    let expectedHeight: CGFloat = 466

    sut = TodayListView()
    guard
      let sut = sut,
      let delegate = sut.delegate as? UICollectionViewDelegateFlowLayout,
      let layout = sut.collectionViewLayout as? UICollectionViewFlowLayout
      else {
        fatalError("Should be not nil")
    }

    let resultSize = delegate.collectionView?(sut, layout: layout, sizeForItemAt: [0, 0])

    XCTAssertEqual(expectedHeight, resultSize?.height)
  }

  func test_delegate_minimumInteritemSpacingForSectionAt() {

    let expectedLineSpacing: CGFloat = 32

    sut = TodayListView()
    guard
      let sut = sut,
      let delegate = sut.delegate as? UICollectionViewDelegateFlowLayout,
      let layout = sut.collectionViewLayout as? UICollectionViewFlowLayout
      else {
        fatalError("Should be not nil")
    }

    let resultLineSpacing = delegate.collectionView?(sut, layout: layout, minimumInteritemSpacingForSectionAt: 0)

    XCTAssertEqual(expectedLineSpacing, resultLineSpacing)
  }

  func test_delegate_insetForSectionAt() {
    let expectedMargin = UIEdgeInsets(top: 10, left: 0, bottom: 32, right: 0)

    sut = TodayListView()
    guard
      let sut = sut,
      let delegate = sut.delegate as? UICollectionViewDelegateFlowLayout,
      let layout = sut.collectionViewLayout as? UICollectionViewFlowLayout
      else {
        fatalError("Should be not nil")
    }

    let resultMargin = delegate.collectionView?(sut, layout: layout, insetForSectionAt: 0)

    XCTAssertEqual(expectedMargin, resultMargin)
  }
}
