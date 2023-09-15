//
//  ViewController.swift
//  infinity-scrolling-banner
//
//  Created by inooph on 2023/09/15.
//

import UIKit

class ViewController: UIViewController {


    // MARK: ------------------- IBOutlets -------------------
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var colView: UICollectionView!
    
    
    // MARK: ------------------- Variables -------------------
    var arrForTbl: [Int] = []
    var arrForCol: [Int] = []
    
    
    // MARK: ------------------- View Life Cycle -------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 가능
        //arrForTbl.do {
        //    for i in 0...2 {
        //        $0.append(i)
        //    }
        //}
        
        for i in 0...2 {
            arrForTbl.append(i)
            arrForCol.append(i)
        }
        
        pr("--> arrForTbl : \(arrForTbl)")
        pr("--> arrForCol : \(arrForCol)")
        
        print("")
    }


    // MARK: ------------------- IBAction functions -------------------
    
    
    // MARK: ------------------- function -------------------
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTbl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell", for: indexPath) as? tblCell else { return UITableViewCell() }

        cell.tag = indexPath.row
        cell.backgroundColor = .getCol(indexPath.row)
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForCol.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as? cvCell else { return UICollectionViewCell() }

        cell.tag = indexPath.item
        cell.backgroundColor = .getCol(indexPath.row)
        
        return cell
    }
}
