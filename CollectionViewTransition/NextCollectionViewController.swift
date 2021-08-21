//
//  NextCollectionViewController.swift
//  CollectionViewTransition
//
//  Created by Adam Wulf on 8/21/21.
//

import UIKit

class NextCollectionViewController: UICollectionViewController {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 400, height: 400)

        super.init(collectionViewLayout: flowLayout)
        useLayoutToLayoutNavigationTransitions = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        useLayoutToLayoutNavigationTransitions = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        let lbl = UILabel()
        lbl.text = "\(indexPath)"
        lbl.sizeToFit()
        cell.addSubview(lbl)
        cell.backgroundColor = .lightGray
        return cell
    }
}
