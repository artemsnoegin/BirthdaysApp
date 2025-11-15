//
//  Repository.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 15.11.2025.
//

protocol Repository {
    
    func fetch() -> [Celebrant]
    func save(_ celebrant: Celebrant)
    func update(_ celebrant: Celebrant)
    func delete(_ celebrant: Celebrant)
}
