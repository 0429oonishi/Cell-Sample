//
//  ViewController.swift
//  Cell-Sample
//
//  Created by 大西玲音 on 2021/06/07.
//

import UIKit

final class ViewController: UIViewController {
    
    private struct OneCardDetail {
        var firstIndexPath: IndexPath
    }
    private struct TwoCardsDetail {
        var firstIndexPath: IndexPath
        var secondIndexPath: IndexPath
    }
    private enum FlipOverState {
        case none
        case oneCard(OneCardDetail)
        case twoCards(TwoCardsDetail)
        func nextState(tappedIndexPath: IndexPath) -> FlipOverState {
            switch self {
                case .none:
                    return .oneCard(OneCardDetail(firstIndexPath: tappedIndexPath))
                case .oneCard(let detail):
                    return .twoCards(TwoCardsDetail(firstIndexPath: detail.firstIndexPath,
                                                    secondIndexPath: tappedIndexPath))
                case .twoCards:
                    return .none
            }
        }
    }
    private struct Item {
        var name: String
        var color: UIColor
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource = [Item](repeating: Item(name: "AAA", color: .black), count: 10)
    private var state: FlipOverState = .none
    
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
        switch state {
            case .none:
                break
            case .oneCard(let detail):
                dataSource[detail.firstIndexPath.row].color = .red
                dataSource[indexPath.row].color = .red
                tableView.reloadRows(at: [detail.firstIndexPath,
                                          indexPath],
                                     with: .automatic)
            case .twoCards(let detail):
                dataSource[detail.firstIndexPath.row].color = .black
                dataSource[detail.secondIndexPath.row].color = .black
                tableView.reloadRows(at: [detail.firstIndexPath,
                                          detail.secondIndexPath],
                                     with: .automatic)
        }
        state = state.nextState(tappedIndexPath: indexPath)
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



