//
//  BirthdaysPresenterProtocol.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 15.11.2025.
//

protocol BirthdaysPresenterProtocol {
    
    func viewDidLoad()
    
    func celebrant(for index: Int) -> Celebrant
    func count() -> Int
    
    func createCelebrant()
    func selectCelebrant(for index: Int)
    func update(_ celebrant: Celebrant)
    func remove(at index: Int)
}
