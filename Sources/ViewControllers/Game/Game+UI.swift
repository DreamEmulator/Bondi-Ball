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
  internal func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.subviews.forEach { $0.removeFromSuperview() }
    if let game = UINib.game.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(game, pinTo: .layoutMargins)
    }
    createListOfPockets()
  }

  internal func createListOfPockets() {
    pockets = .init()
    for _ in 0 ... (App.shared.game.level.board.columns * App.shared.game.level.board.rows - 1) {
      pockets.append(PocketView())
    }
    setUpCollectionView()
  }

  private func setUpCollectionView() {
    gridCollectionView.isScrollEnabled = false
    gridCollectionView
      .register(UICollectionViewCell.self,
                forCellWithReuseIdentifier: "cell")

    gridCollectionView.delegate = self
    gridCollectionView.dataSource = self

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 4

    gridCollectionView
      .setCollectionViewLayout(layout, animated: false)

    setupParticles()
  }

  internal func setupBall(level: Level) {
    let startingPocketIndex = level.startPocket.0 * level.startPocket.1 - 1
    let startingPocketCenter = centerPoint(pocketIndex: startingPocketIndex)

    let ballSize = pocktetSize * 0.8
    paintBall.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)

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

    let pocket = pockets.remove(at: indexPath.row)

    pocket.translatesAutoresizingMaskIntoConstraints = false
    pocket.globalCenter = gridCollectionView.convert(cell.center, to: view)
    pocket.index = indexPath.row

    let containerView = UIView()
    containerView.addSubview(pocket)

    NSLayoutConstraint.activate([
      pocket.heightAnchor.constraint(equalToConstant: pocktetSize),
      pocket.widthAnchor.constraint(equalToConstant: pocktetSize),
      pocket.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      pocket.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ])

    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
    cell.contentView.addSubview(containerView, pinTo: .viewEdges)

    pockets.insert(pocket, at: indexPath.row)
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
