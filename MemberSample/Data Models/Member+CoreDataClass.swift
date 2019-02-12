//
//  Member+CoreDataClass.swift
//  
//
//  Created by Jim Boyd on 2/11/19.
//
//

import Foundation
import CoreData
import DBC

enum Affiliation: String {
	case firstOrder = "FIRST_ORDER"
	case jedi = "JEDI"
	case resistance = "RESISTANCE"
	case sith = "SITH"
	case unknown = "UNKNOWN"
	
	var localizedString: String {
		let result = rawValue.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
		return NSLocalizedString(result, comment: "Affiliation Type")
	}
}

@objc(Member)
public class Member: NSManagedObject, Fetchable {
	
	public var fullName: String {
		if let firstName = self.firstName, let lastName = self.lastName, !firstName.isEmpty, !lastName.isEmpty {
			return "\(firstName) \(lastName)"
		}
		else if let firstName = self.firstName, !firstName.isEmpty {
			return firstName
		}
		else if let lastName = self.lastName, !lastName.isEmpty {
			return lastName
		}
		
		return "NO NAME!" // Fix it : Not localized!
	}
	
	var profileURL: URL? {
		if let profilePicture = profilePicture, let url = URL(string: profilePicture) {
			return url
		}
		
		return nil
	}
	
	var affiliation: Affiliation {
		if let type = affiliationType, let affiliation = Affiliation(rawValue: type) {
			return affiliation
		}
		
		return .unknown
	}

	static func syncIndividuals(to parentContect: NSManagedObjectContext) {
		guard let syncURL = URL(string: "https://edge.ldscdn.org/mobile/interview/directory") else {
			checkFailure("Could not create URL form string")
			return
		}
		
		self.simpleSync(from: syncURL, dataPath: "individuals", parentContect: parentContect)
	}
}
