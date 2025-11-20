//
//  BirthdaysRouter.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 15.11.2025.
//

import UIKit

class ApplicationRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let router = ApplicationRouter()
        let repository = CoreDataRepository()
        
        let presenter = BirthdaysPresenter(router: router, repository: repository)
        let view = BirthdaysTableViewController(presenter: presenter)
        presenter.view = view
        
        router.viewController = view
        
        return view
    }
    
    func showCelebrantViewController(_ celebrant: Celebrant, isEditing: Bool, completion: @escaping (Celebrant) -> Void) {
        
        let presenter = CelebrantPresenter(celebrant: celebrant)
        presenter.completion = completion
        let celebrantViewController = CelebrantViewController(presenter: presenter, isEditing: isEditing)
        presenter.view = celebrantViewController
        
        viewController?.navigationController?.pushViewController(celebrantViewController, animated: true)
    }
}
