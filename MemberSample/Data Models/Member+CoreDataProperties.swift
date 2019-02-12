//
//  Member+CoreDataProperties.swift
//  
//
//  Created by Jim Boyd on 2/11/19.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var memberId: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthdate: Date?
    @NSManaged public var profilePicture: String?
    @NSManaged public var forceSensitive: Bool
    @NSManaged public var affiliationType: String?

}
