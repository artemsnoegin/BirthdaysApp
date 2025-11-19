//
//  CelebrantTableViewCell.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 14.11.2025.
//

import UIKit

class CelebrantTableViewCell: UITableViewCell {
    
    static let reuseID = "CelebrantTableViewCell"
    
    private let photoView = UIImageView()
    private let nameLabel = UILabel()
    private let birthdayLabel = UILabel()
    private let daysBeforeCelebrationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for celebrant: Celebrant) {
        
        nameLabel.text = celebrant.name + " " + celebrant.surname
        birthdayLabel.text = celebrant.birthday.formatted(date: .numeric, time: .omitted)
        daysBeforeCelebrationLabel.text = "\(celebrant.daysBeforeCelebration) days"
        
        if let path = celebrant.photoPath {
            photoView.image = ImageFileManager.shared.loadImage(path)
            photoView.contentMode = .scaleAspectFill
        }
        else {
            photoView.image = UIImage(systemName: "gift")
            photoView.contentMode = .center
        }
    }
    
    private func setupUI() {
        
        photoView.tintColor = .systemBrown
        photoView.clipsToBounds = true
        photoView.backgroundColor = .systemGray6
        photoView.layer.cornerRadius = 45 / 2
        photoView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        birthdayLabel.font = .preferredFont(forTextStyle: .subheadline)
        birthdayLabel.textColor = .secondaryLabel
        
        daysBeforeCelebrationLabel.font = .preferredFont(forTextStyle: .footnote)
        daysBeforeCelebrationLabel.textColor = .secondaryLabel
        
        let basicInfoStack = UIStackView(arrangedSubviews: [nameLabel, birthdayLabel])
        basicInfoStack.axis = .vertical
        basicInfoStack.alignment = .leading
        basicInfoStack.distribution = .fillEqually
        basicInfoStack.spacing = 0

        
        let hStack = UIStackView(arrangedSubviews: [photoView, basicInfoStack, daysBeforeCelebrationLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
       
        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hStack.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

//#Preview {
//    
//    let celebrant = Celebrant(name: "Artem", surname: "Snoegin", birthday: .now)
//    
//    let cell = CelebrantTableViewCell()
//    cell.configure(for: celebrant)
//    
//    return UINavigationController(rootViewController: BirthdaysTableViewController())
//}
