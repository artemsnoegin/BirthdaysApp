//
//  BirthdaysRouter.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 15.11.2025.
//

import UIKit

class BirthdaysRouter {
    
    weak var viewController: UIViewController?
    
    func showCelebrantViewController(_ celebrant: Celebrant, isEditing: Bool, completion: @escaping ((Celebrant) -> Void)) {
        
        let celebrantViewController = CelebrantViewController(celebrant: celebrant, isEditing: isEditing)
        celebrantViewController.completion = { celebrant in
            completion(celebrant)
        }
        
        viewController?.navigationController?.pushViewController(celebrantViewController, animated: true)
    }
    
    static func createModule() -> UIViewController {
        
        let router = BirthdaysRouter()
        let repository = MockRepository()
        let presenter = BirthdaysPresenter(router: router, repository: repository)
        let view = BirthdaysTableViewController(presenter: presenter)
        router.viewController = view
        presenter.view = view
        
        return view
    }
}
