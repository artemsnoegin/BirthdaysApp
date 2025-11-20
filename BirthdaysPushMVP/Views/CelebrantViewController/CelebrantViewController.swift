//
//  CelebrantViewController.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import UIKit
import PhotosUI

protocol CelebrantViewProtocol: AnyObject {
    
    func configureNameProperties(name: String, surname: String)
    func configureDateProperties(age: Int, daysBeforeCelebration: Int, birthday: Date?)
    func configureNotifySwitch(isOn: Bool)
    func configurePhoto(path: String)
}

class CelebrantViewController: UIViewController, CelebrantViewProtocol, PHPickerViewControllerDelegate {
    
    private var presenter: CelebrantPresenterProtocol
    
    private let ageLabel = UILabel()
    private let numberOfDaysBeforeCelebrationLabel = UILabel()
    
    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    
    private let birthdayDatePicker = UIDatePicker()
    private let notifySwitch = UISwitch()
    
    private let photoView = UIImageView()
    private let addPhotoButton = UIButton()
    
    private let contentView = UIView()
    private var contentViewBottomAnchorConstraint: NSLayoutConstraint!
    
    init(presenter: CelebrantPresenterProtocol, isEditing: Bool) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.isEditing = isEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        addHideKeyboardOnTapGesture()
        subscribeNotification()
    }
    
    func configureNameProperties(name: String, surname: String) {
        
        nameTextField.text = name
        surnameTextField.text = surname
    }
    
    func configureDateProperties(age: Int, daysBeforeCelebration: Int, birthday: Date?) {
        
        if let date = birthday {
            birthdayDatePicker.date = date
        }
        
        ageLabel.text = "Age: \(age)"
        numberOfDaysBeforeCelebrationLabel.text = "\(daysBeforeCelebration)"
        
        if daysBeforeCelebration > 60 {
            numberOfDaysBeforeCelebrationLabel.textColor = .systemGreen
        }
        else if daysBeforeCelebration > 30 {
            numberOfDaysBeforeCelebrationLabel.textColor = .systemYellow
        }
        else if daysBeforeCelebration > 12 {
            numberOfDaysBeforeCelebrationLabel.textColor = .systemOrange
        }
        else {
            numberOfDaysBeforeCelebrationLabel.textColor = .systemRed
        }
    }
    
    func configureNotifySwitch(isOn: Bool) {
        
        notifySwitch.isOn = isOn
    }
    
    func configurePhoto(path: String) {
        
        photoView.image = ImageFileManager.shared.loadImage(path)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        photoView.backgroundColor = .systemGray6
        photoView.contentMode = .scaleAspectFill
        
        view.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        addPhotoButton.setTitle("Change photo", for: .normal)
        addPhotoButton.configuration = .plain()
        addPhotoButton.isHidden = !isEditing
        addPhotoButton.addTarget(self, action: #selector(presentPHPicker), for: .touchUpInside)
        
        nameTextField.placeholder = "Name"
        nameTextField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        nameTextField.isEnabled = isEditing
        nameTextField.delegate = self
        
        surnameTextField.placeholder = "Surname"
        surnameTextField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        surnameTextField.isEnabled = isEditing
        
        ageLabel.font = .preferredFont(forTextStyle: .headline)
        ageLabel.textColor = .secondaryLabel
        
        birthdayDatePicker.datePickerMode = .date
        birthdayDatePicker.preferredDatePickerStyle = .compact
        birthdayDatePicker.addTarget(self, action: #selector(changeBirthday), for: .valueChanged)
        
        let ageInfoStack = UIStackView(arrangedSubviews: [ageLabel, birthdayDatePicker])
        
        let divider = UIView()
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        divider.layer.cornerRadius = 1.5 / 2
        divider.backgroundColor = .separator
        
        let notifyLabel = UILabel()
        notifyLabel.text = "Notify (on birthday's eve)"
        notifyLabel.font = .preferredFont(forTextStyle: .headline)
        notifyLabel.textColor = .secondaryLabel
        
        notifySwitch.addTarget(self, action: #selector(changeNotify), for: .valueChanged)
        
        let notifyStack = UIStackView(arrangedSubviews: [notifyLabel, notifySwitch])
        
        let daysBeforeCelebrationLabel = UILabel()
        daysBeforeCelebrationLabel.text = "Days before celebration"
        daysBeforeCelebrationLabel.font = .preferredFont(forTextStyle: .headline)
        daysBeforeCelebrationLabel.textColor = .secondaryLabel
        
        numberOfDaysBeforeCelebrationLabel.font = .preferredFont(forTextStyle: .headline)
        
        let daysLeftStack = UIStackView(arrangedSubviews: [daysBeforeCelebrationLabel, numberOfDaysBeforeCelebrationLabel])
        daysLeftStack.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [addPhotoButton, nameTextField, surnameTextField, ageInfoStack, divider, notifyStack, daysLeftStack])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(0, after: nameTextField)
        stackView.setCustomSpacing(0, after: surnameTextField)
                
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemBackground
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentViewBottomAnchorConstraint = contentView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -32)
        contentViewBottomAnchorConstraint.isActive = true
        
        if #available(iOS 26, *) {
            photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        else {
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // TODO: вынести в router и presenter
    @objc private func presentPHPicker() {
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let photo = object as? UIImage {
                    
                    DispatchQueue.main.async {
                        
                        self?.photoView.image = photo
                    }
                    if let data = photo.pngData() {
                        
                        self?.presenter.updatePhoto(data)
                    }
                }
            }
        }
  
        if let sheet = picker.sheetPresentationController {
            sheet.animateChanges {
                picker.dismiss(animated: true)
            }
        }
    }
    
    @objc private func changeNotify() {
        
        presenter.updateNotify(notifySwitch.isOn)
    }
    
    @objc private func changeBirthday() {
        
        presenter.updateBirthday(birthdayDatePicker.date)
    }
    
    private func setupNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isEditing ? "Save" : "Edit", image: nil, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem?.isEnabled = nameTextField.hasText ? true : false
        navigationItem.hidesBackButton = isEditing
        
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.style = isEditing ? .prominent : .plain
        }
    }
    
    @objc private func editTapped() {
        
        isEditing.toggle()
        
        navigationItem.rightBarButtonItem?.title = isEditing ? "Save" : "Edit"
        navigationItem.hidesBackButton = isEditing
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.style = isEditing ? .prominent : .plain
            navigationItem.rightBarButtonItem?.tintColor = isEditing ? .systemGreen : .label
        }
        
        nameTextField.isEnabled = isEditing
        surnameTextField.isEnabled = isEditing
        addPhotoButton.isHidden = !isEditing
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if !isEditing {
            
            presenter.updateName(name: nameTextField.text ?? "",
                                      surname: surnameTextField.text ?? "")
        }
    }
    
    private func addHideKeyboardOnTapGesture() {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func hideKeyboardOnTap() {
        
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
        else {
            surnameTextField.resignFirstResponder()
        }
    }
    
    private func subscribeNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow() {
        
        contentViewBottomAnchorConstraint.constant = -(view.frame.width - view.safeAreaInsets.top)
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide() {
        
        contentViewBottomAnchorConstraint.constant = -32
        view.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
