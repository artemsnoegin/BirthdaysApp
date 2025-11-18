//
//  BirthdaysPresenter.swift
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

class BirthdaysPresenter: BirthdaysPresenterProtocol {
    
    weak var view: BirthdaysTableViewProtocol?
    
    private var router: Router
    
    private var repository: Repository
    private var birthdays = [Celebrant]()
    
    init(router: Router, repository: Repository) {
        self.router = router
        self.repository = repository
    }
    
    func viewDidLoad() {
        
        birthdays = repository.fetch()
        view?.reloadTableView()
    }
    
    func celebrant(for index: Int) -> Celebrant {
        birthdays[index]
    }
    
    func count() -> Int {
        birthdays.count
    }
    
    func createCelebrant() {

        let celebrant = Celebrant()
        birthdays.append(celebrant)
        repository.save(celebrant)
        
        router.showCelebrantViewController(celebrant, isEditing: true) { [weak self] celebrant in
            self?.update(celebrant)
            self?.view?.reloadTableView()
        }
    }
    
    func selectCelebrant(for index: Int) {
        
        let celebrant = birthdays[index]
        
        router.showCelebrantViewController(celebrant, isEditing: false) { [weak self] celebrant in
            self?.update(celebrant)
            self?.view?.reloadTableView()
        }
    }
    
    func update(_ celebrant: Celebrant) {
        guard let index = birthdays.firstIndex(where: { $0.id == celebrant.id }) else { return }
        
        repository.update(celebrant)
        birthdays[index] = celebrant
    }
    
    func remove(at index: Int) {
        
        repository.delete(birthdays[index])
        birthdays.remove(at: index)
    }
}
