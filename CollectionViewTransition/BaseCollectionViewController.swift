//
//  BaseCollectionViewController.swift
//  CollectionViewTransition
//
//  Created by Adam Wulf on 8/21/21.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)

        super.init(collectionViewLayout: flowLayout)
        useLayoutToLayoutNavigationTransitions = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        useLayoutToLayoutNavigationTransitions = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)

        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .white

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(NextCollectionViewController(), animated: true)
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
