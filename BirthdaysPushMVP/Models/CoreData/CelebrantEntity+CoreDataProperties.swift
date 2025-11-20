//
//  CelebrantEntity+CoreDataProperties.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 16.11.2025.
//
//

public import Foundation
public import CoreData


public typealias CelebrantEntityCoreDataPropertiesSet = NSSet

extension CelebrantEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CelebrantEntity> {
        return NSFetchRequest<CelebrantEntity>(entityName: "CelebrantEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var surname: String
    @NSManaged public var birthday: Date
    @NSManaged public var photoPath: String?
    @NSManaged public var notify: Bool

}

extension CelebrantEntity : Identifiable {

}
