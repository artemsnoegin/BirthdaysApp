//
//  MockRepository.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 13.11.2025.
//

import Foundation

class MockRepository: Repository {
    
    private var storage = [
        Celebrant(name: "Artem", surname: "Snoegin",
                birthday: Calendar.current.date(from: DateComponents(year: 1998, month: 08, day: 17))!),
        Celebrant(name: "Andrey", surname: "Zarecky",
                birthday: Calendar.current.date(from: DateComponents(year: 1990, month: 01, day: 12))!),
        Celebrant(name: "Bulat", surname: "Karamov",
                birthday: Calendar.current.date(from: DateComponents(year: 2003, month: 12, day: 01))!),
        Celebrant(name: "Kaspi", surname: "Atlas Jerry",
                birthday: Calendar.current.date(from: DateComponents(year: 2014, month: 11, day: 20))!),
    ]
    
    func fetch() -> [Celebrant] {
        storage
    }
    
    func save(_ celebrant: Celebrant) {
        storage.append(celebrant)
    }
    
    func update(_ celebrant: Celebrant) {
        guard let index = storage.firstIndex(where: { $0.id == celebrant.id }) else { return }
        storage[index] = celebrant
    }
    
    func delete(_ celebrant: Celebrant) {
        guard let index = storage.firstIndex(where: { $0.id == celebrant.id }) else { return }
        storage.remove(at: index)
    }
}
