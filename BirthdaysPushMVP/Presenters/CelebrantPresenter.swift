//
//  CelebrantPresenter.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 18.11.2025.
//

import Foundation

protocol CelebrantPresenterProtocol {
    
    func viewDidLoad()
    func updateName(name: String, surname: String)
    func updateNotify(_ notify: Bool)
    func updateBirthday(_ date: Date)
}

class CelebrantPresenter: CelebrantPresenterProtocol {
    
    weak var view: CelebrantViewProtocol?
    
    var completion: ((Celebrant) -> Void)?
    
    private var userNotificationManager = UserNotificationManager.shared
    private var celebrant: Celebrant
    
    init(celebrant: Celebrant) {
        self.celebrant = celebrant
    }
    
    func viewDidLoad() {
        
        view?.configureNameProperties(name: celebrant.name, surname: celebrant.surname)
        view?.configureDateProperties(age: celebrant.age,
                        daysBeforeCelebration: celebrant.daysBeforeCelebration,
                        birthday: celebrant.birthday)
        view?.configureNotifySwitch(isOn: celebrant.notify)
    }
    
    func updateName(name: String, surname: String) {
        
        celebrant.name = name
        celebrant.surname = surname
        updateNotification()
        
        view?.configureNameProperties(name: celebrant.name, surname: celebrant.surname)
        completion?(celebrant)
    }
    
    func updateBirthday(_ date: Date) {
        
        celebrant.birthday = date
        updateNotification()
        
        completion?(celebrant)
        view?.configureDateProperties(age: celebrant.age,
                                      daysBeforeCelebration: celebrant.daysBeforeCelebration,
                                      birthday: nil)
    }
    
    func updateNotify(_ notify: Bool) {
        
        celebrant.notify = notify
        
        if celebrant.notify {
            userNotificationManager.addNotification(id: celebrant.id.uuidString, celebrantName: celebrant.name, birthday: celebrant.birthday)
        } else {
            userNotificationManager.removeNotification(id: celebrant.id.uuidString)
        }
        
        completion?(celebrant)
    }
    
    private func updateNotification() {
        
        if celebrant.notify {
            
            userNotificationManager.removeNotification(id: celebrant.id.uuidString)
            userNotificationManager.addNotification(id: celebrant.id.uuidString, celebrantName: celebrant.name, birthday: celebrant.birthday)
        }
    }
}
