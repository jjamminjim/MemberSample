//
//  Member+FetchableDecodable.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import Foundation
import CoreData
import DBC


extension Member: Syncable {
	private enum JsonKey: String {
		case memberId = "id"
		case firstName
		case lastName
		case birthdate
		case profilePicture
		case forceSensitive
		case affiliation
	}
	
	private static let kCachedDateFormatterKey = "CachedDateFormatterKey"
	public static var dateFormatter:  DateFormatter {
		let threadDictionary = Thread.current.threadDictionary
		var dateFormatter = threadDictionary[kCachedDateFormatterKey] as? DateFormatter
		
		if dateFormatter == nil {
			dateFormatter = DateFormatter()
			dateFormatter?.dateFormat = "yyyy-MM-dd"
			//make sure you format the date in GMT (what the server stores it as)
			dateFormatter?.timeZone = TimeZone(abbreviation: "GMT")
			threadDictionary[kCachedDateFormatterKey] = dateFormatter
		}
		
		return dateFormatter!
	}
	
	public func update(with json: [String : Any], in context: NSManagedObjectContext) throws -> Self {
		// For now just require the data to exist in the json stream. We'll adjust as needed later.
		// Also for now, simply overwrite the existing data if already set.
		self.memberId = Int32(json.requireInt(JsonKey.memberId.rawValue))
		self.firstName = json.requireString(JsonKey.firstName.rawValue)
		self.lastName = json.requireString(JsonKey.lastName.rawValue)
		self.forceSensitive = json.requireBool(JsonKey.forceSensitive.rawValue)
		self.affiliationType = json.requireString(JsonKey.affiliation.rawValue)
		self.profilePicture = json.requireString(JsonKey.profilePicture.rawValue)
		
		// For now just require the dara to exist in the json stream. We'll adjust as needed, later.
		if let birthStr = json.asString(JsonKey.birthdate.rawValue),
			let birthDate = Member.dateFormatter.date(from: birthStr) {
			self.birthdate = birthDate
		}
		
		return self
	}
}
