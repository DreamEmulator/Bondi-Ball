//
//  GameVC.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
  @IBOutlet var gridCollectionView: UICollectionView!
  @IBOutlet var level: UILabel!
  @IBOutlet var points: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    subscribe()
  }
}

// MARK: - Setup UI

extension GameVC {
  private func setupUI() {
    if let game = UINib.game.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(game, pinTo: .layoutMargins)

      points.text = String(App.shared.game.totalPoints)
      level.text = String(App.shared.game.level.id)

      setUpCollectionView()
    }
  }

  private func setUpCollectionView() {
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
      .setCollectionViewLayout(layout, animated: true)
  }
}

// MARK: - Grid laypout

extension GameVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return App.shared.game.level.board.rows
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .randomColor()
    return cell
  }
}

extension GameVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets
  {
    return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let lay = collectionViewLayout as! UICollectionViewFlowLayout
    let widthPerItem = collectionView.frame.width / CGFloat(App.shared.game.level.board.columns) - lay.minimumInteritemSpacing
    let heightPerItem = collectionView.frame.height / CGFloat(App.shared.game.level.board.rows) - lay.minimumInteritemSpacing
    return CGSize(width: widthPerItem - 8, height: heightPerItem)
  }
}

// MARKL: - Subscribe

extension GameVC {
  func subscribe() {
    App.shared.game.state.subscribe { [weak self] state in
      switch state {
      case .Scored:
        self?.points.text = String(App.shared.game.totalPoints)
      case .LevelingUp:
        self?.level.text = String(App.shared.game.level.id)
      default:
        break
      }
    }
  }
}
