//
//  Game+UI.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 12/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

// MARK: - Setup UI

extension GameVC {
  func setupUI(pocketSize: CGRect) {
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.subviews.forEach { $0.removeFromSuperview() }
    setupSFX()
    if let game = UINib.game.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(game, pinTo: .layoutMargins)
    }
    setUpCollectionView(pocketSize: pocketSize)
  }

//  func populatePocketViewData(_ pocketViewData: PocketViewData) {
//    pockets = .init()
//    for row in 1 ... App.shared.game.level.board.rows {
//      for column in 1 ... App.shared.game.level.board.columns {
//        let pocket = PocketView(frame: pocketSize, viewData: pocketViewData)
//        pocket.row = row
//        pocket.column = column
//        pockets.append(pocket)
//      }
//    }
//    print("Pockets count: \(pockets.count)")
//  }

  private func setUpCollectionView(pocketSize: CGRect) {
    guard let gridCollectionView else {
      return
    }
    gridCollectionView.isScrollEnabled = false
    gridCollectionView
      .register(UICollectionViewCell.self,
                forCellWithReuseIdentifier: "cell")
    gridCollectionView.backgroundColor = .clear

    gridCollectionView.delegate = self
    gridCollectionView.dataSource = self

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 4

    gridCollectionView
      .setCollectionViewLayout(layout, animated: false)

    setupBall()
  }

  func setupBall() {
    let level = App.shared.game.level
    print(level.startPocket)
    let startingPocketIndex = level.startPocket.0 * level.startPocket.1 - 1
    let startingPocketCenter = centerPoint(pocketIndex: startingPocketIndex)

    paintBall.frame = pocktetSize.insetBy(dx: 42, dy: 42)

    paintBall.center = startingPocketCenter
    springConfigurationButton.center = startingPocketCenter

    view.addSubview(paintBall)

    configureGestureRecognizers()
  }
}

// MARK: - Grid laypout

extension GameVC: UICollectionViewDataSource {
  internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return App.shared.game.level.board.rows * App.shared.game.level.board.columns
  }

  internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

    guard let gridCollectionView else {
      print("⚠️ gridCollectionView is nil")
      return cell
    }
    
    // Ghetto way of determining pocket's grid position
    let pocketPosition = gridCollectionView.convert(cell.center, to: view)
      
    let pocketHeight = gridCollectionView.frame.height / CGFloat(level.board.rows)
    let pocketWidth = gridCollectionView.frame.width / CGFloat(level.board.columns)
      
    let pocketRow = Int(pocketPosition.y / pocketHeight) + 1
    let pocketColumn = Int(pocketPosition.x / pocketWidth) + 1

      
    let viewData = PocketViewData(
      indexPath: indexPath,
      displayPosition: pocketPosition,
      isGoal: level.endPocket.0 == pocketRow && level.endPocket.1 == pocketColumn,
      isStartPocket: level.startPocket.0 == pocketRow && level.startPocket.1 == pocketColumn
    )

    updatePocketViewData(viewData)

    let pocket = PocketView(frame: pocktetSize, viewData: viewData)
    // TODO: make nice functions to set and fish up views using tags
    pocket.tag = viewData.tag

    pocket.translatesAutoresizingMaskIntoConstraints = false

    let containerView = UIView()
    containerView.addSubview(pocket)

    NSLayoutConstraint.activate([
      pocket.heightAnchor.constraint(equalToConstant: pocktetSize.height),
      pocket.widthAnchor.constraint(equalToConstant: pocktetSize.width),
      pocket.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      pocket.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ])

    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
    cell.contentView.addSubview(containerView, pinTo: .viewEdges)

    return cell
  }
}

extension GameVC: UICollectionViewDelegateFlowLayout {
  internal func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let lay = collectionViewLayout as! UICollectionViewFlowLayout
    let widthPerItem = collectionView.frame.width / CGFloat(App.shared.game.level.board.columns) - lay.minimumInteritemSpacing
    let heightPerItem = collectionView.frame.height / CGFloat(App.shared.game.level.board.rows) - lay.minimumInteritemSpacing
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
}

// - MARK: QOL Functions
extension GameVC {
  func updatePocketViewData(_ viewData: PocketViewData) {
    pocketViewData.removeAll { $0.indexPath == viewData.indexPath }
    pocketViewData.append(viewData)
  }
}
