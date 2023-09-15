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
    
    var timerTbl: Timer?
    var timerColV: Timer?
    
    var isNilTblTimer: Bool {
        return timerTbl == nil
    }
    
    var isNilColVTimer: Bool {
        return timerColV == nil
    }
    
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
        
        if let first = arrForTbl.first, let last = arrForTbl.last {
            arrForTbl.insert(last, at: 0)
            arrForTbl.append(first)
        }
        
        if let first = arrForCol.first, let last = arrForCol.last {
            arrForCol.insert(last, at: 0)
            arrForCol.append(first)
        }
        
        pr("--> arrForTbl : \(arrForTbl)")
        pr("--> arrForCol : \(arrForCol)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startTimerTbl(isNilTblTimer)
        startTimerColv(isNilColVTimer)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        startTimerTbl(isNilTblTimer)
        startTimerColv(isNilColVTimer)
    }

    // MARK: ------------------- IBAction functions -------------------
    
    
    // MARK: ------------------- function -------------------
    func startTimerTbl(_ isNil: Bool) {
        if isNil {
            timerTbl = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { [weak self] _ in
                guard let `self` else { return }
                if let crntIdx = self.tblView.visibleCells.first?.tag {
                    let lstIdx = (self.arrForTbl.count - 1)
                    let nxtIdx = crntIdx + 1 > lstIdx ? 0 : crntIdx + 1
                    
                    // 2 - [ 0 - 1 - 2 ] - 0
                    self.tblView.scrollToRow(at: .init(row: nxtIdx, section: 0), at: .middle, animated: true)
                }
            })
            
            pr("--> 1. 타이머 시작")
            
        } else {
            timerTbl?.invalidate()
            timerTbl = nil
            pr("--> 1. 타이머 해제")
        }
    }
    
    func startTimerColv(_ isNil: Bool) {
        if isNil {
            timerColV = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { [weak self] _ in
                guard let `self` else { return }
                if let crntIdx = self.colView.visibleCells.first?.tag {
                    let lstIdx = (self.arrForCol.count - 1)
                    let nxtIdx = crntIdx + 1 > lstIdx ? 0 : crntIdx + 1
                    
                    // 2 - [ 0 - 1 - 2 ] - 0
                    self.colView.scrollToItem(at: .init(item: nxtIdx, section: 0), at: .centeredHorizontally, animated: true)
                }
            })
            
            pr("--> 2. 타이머 시작")
            
        } else {
            timerColV?.invalidate()
            timerColV = nil
            pr("--> 2. 타이머 해제")
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTbl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell", for: indexPath) as? tblCell else { return UITableViewCell() }

        cell.tag = indexPath.row
        cell.backgroundColor = .getCol(indexPath.row)
        cell.selectionStyle = .none
        
        let obj = arrForTbl[indexPath.row]
        cell.label.text = String(describing: obj)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pr("--> tableView didSelected = \(indexPath.row)")
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForCol.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as? cvCell else { return UICollectionViewCell() }

        cell.tag = indexPath.item
        cell.backgroundColor = .getCol(indexPath.row)
        
        
        let obj = arrForCol[indexPath.item]
        cell.label.text = String(describing: obj)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pr("--> collectionView didSelected = \(indexPath.item)")
    }
}
