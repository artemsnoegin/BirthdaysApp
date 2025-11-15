//
//  Celebrant.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import Foundation

struct Celebrant {
    
    var id: UUID
    var name: String
    var surname: String
    var birthday: Date
    var notify: Bool
    
    init(id: UUID = UUID(), name: String = "", surname: String = "", birthday: Date = .now, notify: Bool = true) {
        self.id = id
        self.name = name
        self.surname = surname
        self.birthday = birthday
        self.notify = notify
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthday, to: .now).year ?? 0
    }
    
    var daysUntilNextBirthday: Int {
            let calendar = Calendar.current
            let now = Date()
            
            let birthComponents = calendar.dateComponents([.month, .day], from: birthday)
            var next = DateComponents(
                year: calendar.component(.year, from: now),
                month: birthComponents.month,
                day: birthComponents.day
            )
            
            var nextBirthday = calendar.date(from: next)!
            
            if nextBirthday < now {
                next.year! += 1
                nextBirthday = calendar.date(from: next)!
            }
            
            return calendar.dateComponents([.day], from: now, to: nextBirthday).day ?? 0
        }
}
