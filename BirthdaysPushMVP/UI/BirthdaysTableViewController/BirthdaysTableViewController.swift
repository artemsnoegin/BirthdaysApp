//
//  BirthdaysTableViewController.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import UIKit

class BirthdaysTableViewController: UIViewController {
    
    private var birthdays = [Celebrant]()
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBirthdays()
        setupUI()
    }
    
    private func getBirthdays() {
        
        birthdays = MockRepository().celebrants
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
        
        let newCelebrant = Celebrant(name: "", surname: "", birthday: .now)
        birthdays.append(newCelebrant)
        tableView.reloadData()
        let lastIndex = birthdays.count - 1
        
        let celebrantViewController = CelebrantViewController(celebrant: newCelebrant)
        celebrantViewController.isEditing = true
        
        celebrantViewController.completion = { [weak self] celebrant in

            self?.birthdays[lastIndex] = celebrant
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(celebrantViewController, animated: true)
    }
}

extension BirthdaysTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        birthdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CelebrantTableViewCell.reuseID) as? CelebrantTableViewCell else {
            return UITableViewCell()
        }
        
        let celebrant = birthdays[indexPath.row]
        cell.configure(for: celebrant)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let celebrant = birthdays[indexPath.row]
        let celebrantViewController = CelebrantViewController(celebrant: celebrant)
        
        celebrantViewController.completion = { [weak self] celebrant in
            
            self?.birthdays[indexPath.row] = celebrant
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.pushViewController(celebrantViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            birthdays.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

#Preview {
    
    UINavigationController(rootViewController: BirthdaysTableViewController())
}
