//
//  ViewController.swift
//  combine-demo
//
//  Created by Abhishek Ravi on 19/01/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var observer: AnyCancellable?
    
    private lazy var api = APIClient()
    private var dataSource: [UserModel]? = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getData()
    }
    
    private func getData() {
        api.delegate = self
        
        observer = api.get(URL(string: "https://jsonplaceholder.typicode.com/users")!)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionState in
                switch completionState {
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { models in
                print("Receive Value: \(models.count)")
                self.dataSource = models
            })
    }
    
    private func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ViewController: APIClientDelegate {
    
    func onAPISuccess(_ data: [UserModel]) {
        self.dataSource?.removeAll()
        self.dataSource = data
    }
    
    func onAPIFailure(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.dataSource?[indexPath.row].name
        return cell
    }
}
