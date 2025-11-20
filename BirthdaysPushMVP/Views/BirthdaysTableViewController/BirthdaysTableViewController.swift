//
//  BirthdaysTableViewController.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import UIKit

protocol BirthdaysTableViewProtocol: AnyObject {
    
    func reloadTableView()
}

class BirthdaysTableViewController: UIViewController, BirthdaysTableViewProtocol {
    
    private let tableView = UITableView()
    private var presenter: BirthdaysPresenter
    
    init(presenter: BirthdaysPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "🎂 Birthdays"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addCelebrant))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CelebrantTableViewCell.self, forCellReuseIdentifier: CelebrantTableViewCell.reuseID)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func addCelebrant() {
        
        presenter.createCelebrant()
    }
}

extension BirthdaysTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CelebrantTableViewCell.reuseID) as? CelebrantTableViewCell else {
            return UITableViewCell()
        }
        
        let celebrant = presenter.celebrant(for: indexPath.row)
        cell.configure(for: celebrant)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.selectCelebrant(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // TODO: вызов deleteRow через презентер ?
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            presenter.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
