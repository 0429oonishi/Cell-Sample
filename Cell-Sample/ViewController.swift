//
//  ViewController.swift
//  Cell-Sample
//
//  Created by 大西玲音 on 2021/06/07.
//

import UIKit

/*
 enum State: 状態によってタップ時の処理を切り替える時に使う
 dataSource: どの行が何色かを表す
 didSelectメソッド: 現在のstateによって、dataSourceの書き換え、tableViewのreload、新たなstateへの移行を行う
 cellForRowメソッド: dataSourceの内容を元にセルへどう表示するかを書く
 */

final class ViewController: UIViewController {
    
    enum State {
        case initial(IndexPath?, IndexPath?)
        case firstTapped(IndexPath)
        case secondTapped(IndexPath, IndexPath)
        case thirdTapped(IndexPath, IndexPath, IndexPath)
    }
    struct Item {
        var name: String
        var color: UIColor
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource = [Item](repeating: Item(name: "AAA", color: .black), count: 10)
    private var state: State = .initial(nil, nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(CustomTableViewCell.nib,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var items = [IndexPath]()
        switch state {
            case .initial(let thirdIndexPath, let fourthIndexPath):
                if let thirdIndexPath = thirdIndexPath,
                   let fourthIndexPath = fourthIndexPath {
                    items = [thirdIndexPath, fourthIndexPath, indexPath]
                    changeDefaultColor(thirdIndexPath, fourthIndexPath)
                }
                state = .firstTapped(indexPath)
            case .firstTapped(let firstIndexPath):
                changeSelectedColor(firstIndexPath, indexPath)
                items = [firstIndexPath, indexPath]
                state = .secondTapped(firstIndexPath, indexPath)
            case .secondTapped(let firstIndexPath, let secondIndexPath):
                changeDefaultColor(firstIndexPath, secondIndexPath)
                items = [firstIndexPath, secondIndexPath, indexPath]
                state = .thirdTapped(firstIndexPath, secondIndexPath, indexPath)
            case .thirdTapped(let firstIndexPath, let secondIndexPath, let thirdIndexPath):
                changeDefaultColor(firstIndexPath, secondIndexPath)
                changeSelectedColor(thirdIndexPath, indexPath)
                items = [firstIndexPath, secondIndexPath, thirdIndexPath, indexPath]
                state = .initial(thirdIndexPath, indexPath)
        }
        reloadTable(at: items)
    }
    
    private func changeDefaultColor(_ i: IndexPath, _ j: IndexPath) {
        dataSource[i.row].color = .black
        dataSource[j.row].color = .black
    }
    
    private func changeSelectedColor(_ i: IndexPath, _ j: IndexPath) {
        dataSource[i.row].color = .red
        dataSource[j.row].color = .red
    }
    
    private func reloadTable(at items: [IndexPath]) {
        tableView.reloadRows(at: items, with: .automatic)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                 for: indexPath) as! CustomTableViewCell
        let dataSource = dataSource[indexPath.row]
        cell.configure(name: dataSource.name, color: dataSource.color)
        return cell
    }
}



