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
    
    @IBOutlet var btnTmArrs: [UIButton]!
    
    // MARK: ------------------- Variables -------------------
    var arrForTbl: [Int] = []
    var arrForCol: [Int] = []
    
    var timerTbl: Timer? {
        didSet {
            btnTmArrs[0].setTitle(timerStr.tbl, for: .normal)
        }
    }
    var timerColV: Timer? {
        didSet {
            btnTmArrs[1].setTitle(timerStr.col, for: .normal)
        }
    }
    
    var isNilTblTimer: Bool {
        return timerTbl == nil
    }
    
    var timerStr: (tbl: String, col: String) {
        let first = "타이머 테이블 : \(isNilTblTimer ? "시작" : "멈춤")"
        let second = "타이머 컬렉션 : \(isNilColVTimer ? "시작" : "멈춤")"
        return (first, second)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tblView.scrollToRow(at: .init(row: 1, section: 0), at: .middle, animated: false)
        colView.scrollToItem(at: .init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //startTimerTbl(isNilTblTimer)
        //startTimerColv(isNilColVTimer)
        
        btnTmArrs.do {
            for (i, btn) in $0.enumerated() {
                btn.tag = i
                btn.addTarget(self, action: #selector(btnStartTimer), for: .touchUpInside)
                let isTbl: Bool = i == 0
                btn.setTitle("\(isTbl ? timerStr.tbl : timerStr.col)", for: .normal)
                
                btn.cornerRadi = 10
                btn.borderWidth = 1
                btn.borderCol = .systemBlue
            }
        }

        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        startTimerTbl(isNilTblTimer)
        startTimerColv(isNilColVTimer)
    }

    // MARK: ------------------- IBAction functions -------------------
    @objc func btnStartTimer(_ sender: UIButton) {
        pr("--> \(sender.tag)")
        
        switch sender.tag {
        case 0:
            startTimerTbl(isNilTblTimer)
        
        case 1:
            startTimerColv(isNilColVTimer)
            
        default:
            break
        }
    }
    
    
    // MARK: ------------------- function -------------------
    func startTimerTbl(_ isNil: Bool) {
        if isNil {
            timerTbl = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
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
            timerColV = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
                guard let `self` else { return }
                if let crntIdx = self.colView.visibleCells.first?.tag {
                    let lstIdx = (self.arrForCol.count - 1)
                    let nxtIdx = crntIdx + 1 > lstIdx ? 0 : crntIdx + 1
                    
                    // 2 - [ 0 - 1 - 2 ] - 0
                    self.colView.scrollToItem(at: .init(item: nxtIdx, section: 0), at: .left, animated: true)
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


// MARK: ------------------- tableView -------------------
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTbl.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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


// MARK: ------------------- collectionView -------------------
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForCol.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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


// MARK: ------------------- scrollView -------------------
extension ViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch scrollView {
        case tblView:
            startTimerTbl(false)
            
        case colView:
            startTimerColv(false)
            
        default:
            break
        }
    }
    
    // 2 - [ 0 - 1 - 2 ] - 0
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case tblView:
            if let tvcIdx = tblView.visibleCells.first?.tag {
                
                switch tvcIdx {
                case 0: //  2 -> [ 2 ]
                    tblView.scrollToRow(at: .init(row: arrForTbl.count - 2, section: 0), at: .middle, animated: false)
                    
                case arrForTbl.count - 1: // 0 -> [ 0 ]
                    tblView.scrollToRow(at: .init(row: 1, section: 0), at: .middle, animated: false)
                    
                default: break
                }
                
                startTimerTbl(isNilTblTimer)
            }
            
        case colView:
            if let cvIdx = colView.visibleCells.first?.tag {
                
                switch cvIdx {
                case 0: //  2 -> [ 2 ]
                    colView.scrollToItem(at: .init(item: arrForCol.count - 2, section: 0), at: .centeredHorizontally, animated: false)
                
                case arrForCol.count - 1: // 0 -> [ 0 ]
                    colView.scrollToItem(at: .init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
                
                default: break
                }
                
                startTimerColv(isNilColVTimer)
            }
            
        default:
            break
        }
    }
    
    
    /**
     2 - [ 0 - 1 - 2 ] - 0
     자동 페이징 후 괄호 밖 0일 때 괄호 안 0으로 이동함
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        switch scrollView {
        case tblView:
            if let tblIdx = tblView.visibleCells.first?.tag, tblIdx == (arrForTbl.count - 1) {
                tblView.scrollToRow(at: .init(row: 1, section: 0), at: .middle, animated: false)
            }
            
        case colView:
            if let cvIdx = colView.visibleCells.first?.tag, cvIdx == (arrForCol.count - 1) {
                colView.scrollToItem(at: .init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
            
        default:
            break
        }
    }
    
    
}
