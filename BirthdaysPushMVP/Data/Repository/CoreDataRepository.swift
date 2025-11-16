//
//  CoreDataRepository.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 16.11.2025.
//

import CoreData

class CoreDataRepository: Repository {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { _, error in
            
            if let error = error {
                
                fatalError("Error loading Core Data: \(error)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                try context.save()
            } catch {
                fatalError("Error saving: \(error)")
            }
        }
    }
    
    
    func fetch() -> [Celebrant] {
        
        let request = CelebrantEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return map(entities)
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(_ celebrant: Celebrant) {
        
        let entity = CelebrantEntity(context: context)
        
        entity.id = celebrant.id
        entity.name = celebrant.name
        entity.surname = celebrant.surname
        entity.birthday = celebrant.birthday
        entity.notify = celebrant.notify
        entity.photoPath = celebrant.photoPath
        
        saveContext()
    }
    
    func update(_ celebrant: Celebrant) {
        
        let request = CelebrantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", celebrant.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                
                entity.name = celebrant.name
                entity.surname = celebrant.surname
                entity.birthday = celebrant.birthday
                entity.notify = celebrant.notify
                entity.photoPath = celebrant.photoPath
                
                saveContext()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ celebrant: Celebrant) {
        
        let request = CelebrantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", celebrant.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                
                context.delete(entity)
                saveContext()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataRepository {
    
    private func map(_ entities: [CelebrantEntity]) -> [Celebrant] {
        
        entities.map { entity in
            Celebrant(id: entity.id,
                      name: entity.name,
                      surname: entity.surname,
                      birthday: entity.birthday,
                      notify: entity.notify,
                      photoPath: entity.photoPath)
        }
    }
}
