//
//  CelebrantViewController.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import UIKit

class CelebrantViewController: UIViewController {
    
    var completion: ((Celebrant) -> Void)?
    
    private var celebrant: Celebrant
    
    private let ageLabel = UILabel()
    private let numberOfDaysUntilNextBirthdayLabel = UILabel()
    
    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    
    private let birthdayDatePicker = UIDatePicker()
    private let notifySwitch = UISwitch()
    
    private let contentView = UIView()
    
    init(celebrant: Celebrant) {
        self.celebrant = celebrant
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isEditing ? "Save" : "Edit", image: nil, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem?.tintColor = isEditing ? .systemGreen : .label
        navigationItem.rightBarButtonItem?.isEnabled = nameTextField.hasText ? true : false
        navigationItem.hidesBackButton = isEditing
    }
    
    @objc private func editTapped() {
        
        isEditing.toggle()
        
        navigationItem.rightBarButtonItem?.title = isEditing ? "Save" : "Edit"
        navigationItem.rightBarButtonItem?.tintColor = isEditing ? .systemGreen : .label
        navigationItem.hidesBackButton = isEditing
        
        nameTextField.isEnabled = isEditing
        surnameTextField.isEnabled = isEditing
        notifySwitch.isEnabled = isEditing
        birthdayDatePicker.isEnabled = isEditing
        
        celebrant.name = nameTextField.text ?? ""
        celebrant.surname = surnameTextField.text ?? ""
        celebrant.birthday = birthdayDatePicker.date
        celebrant.notify = notifySwitch.isOn
        
        ageLabel.text = "Age: \(celebrant.age)"
        numberOfDaysUntilNextBirthdayLabel.text = "\(celebrant.daysUntilNextBirthday)"
        
        if !isEditing {
            
            completion?(celebrant)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        let photoView = UIImageView()
        photoView.backgroundColor = .systemGray6
        
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.placeholder = "Name"
        nameTextField.text = celebrant.name
        nameTextField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        nameTextField.isEnabled = isEditing
        nameTextField.delegate = self
        
        surnameTextField.placeholder = "Surname"
        surnameTextField.text = celebrant.surname
        surnameTextField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        surnameTextField.isEnabled = isEditing
        
        ageLabel.text = "Age: \(celebrant.age)"
        ageLabel.font = .preferredFont(forTextStyle: .headline)
        ageLabel.textColor = .secondaryLabel
        
        birthdayDatePicker.date = celebrant.birthday
        birthdayDatePicker.datePickerMode = .date
        birthdayDatePicker.preferredDatePickerStyle = .compact
        birthdayDatePicker.isEnabled = isEditing
        
        let ageInfoStack = UIStackView(arrangedSubviews: [ageLabel, birthdayDatePicker])
        
        let divider = UIView()
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider.layer.cornerRadius = 1
        divider.backgroundColor = .separator
        
        let notifyLabel = UILabel()
        notifyLabel.text = "Notify"
        notifyLabel.font = .preferredFont(forTextStyle: .headline)
        notifyLabel.textColor = .secondaryLabel
        
        notifySwitch.isOn = celebrant.notify
        notifySwitch.isEnabled = isEditing
        
        let notifyStack = UIStackView(arrangedSubviews: [notifyLabel, notifySwitch])
        
        let daysUntilNextBirthdayLabel = UILabel()
        daysUntilNextBirthdayLabel.text = "Days until next birthday"
        daysUntilNextBirthdayLabel.font = .preferredFont(forTextStyle: .headline)
        daysUntilNextBirthdayLabel.textColor = .secondaryLabel
        
        numberOfDaysUntilNextBirthdayLabel.text = "\(celebrant.daysUntilNextBirthday)"
        numberOfDaysUntilNextBirthdayLabel.font = .preferredFont(forTextStyle: .headline)
        
        if celebrant.daysUntilNextBirthday < 12 {
            numberOfDaysUntilNextBirthdayLabel.textColor = .systemRed
        }
        else if celebrant.daysUntilNextBirthday < 30 {
            numberOfDaysUntilNextBirthdayLabel.textColor = .systemOrange
        }
        else if celebrant.daysUntilNextBirthday < 60 {
            numberOfDaysUntilNextBirthdayLabel.textColor = .systemYellow
        }
        else {
            numberOfDaysUntilNextBirthdayLabel.textColor = .systemGreen
        }
        
        let daysLeftStack = UIStackView(arrangedSubviews: [daysUntilNextBirthdayLabel, numberOfDaysUntilNextBirthdayLabel])
        daysLeftStack.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [nameTextField, surnameTextField, ageInfoStack, divider, notifyStack, daysLeftStack])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(0, after: nameTextField)
        stackView.setCustomSpacing(0, after: surnameTextField)
        stackView.layer.cornerRadius = 12
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 30
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -30),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

extension CelebrantViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

#Preview {
    
    let celebrant = MockRepository().celebrants[2]
    let view = CelebrantViewController(celebrant: celebrant)
    return UINavigationController(rootViewController: view)
}
