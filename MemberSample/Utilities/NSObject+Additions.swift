//
//  NSObject+Additions.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//
// Inspired by https://www.natashatherobot.com/nsstringfromclass-in-swift/
//

import Foundation
import DBC

extension NSObject {
	class func nameOfClass() -> String {
		guard let result = NSStringFromClass(self).components(separatedBy: ".").last else {
			checkFailure("Could not get the class name for this NSObject : \(self)")
			return ""
		}
		
		ensure(!result.isEmpty)
		return result
	}

	func nameOfClass() -> String {
		guard let result = NSStringFromClass(type(of: self)).components(separatedBy: ".").last else {
			checkFailure("Could not get the class name for this NSObject : \(self)")
			return ""
		}
		
		ensure(!result.isEmpty)
		return result
	}
}
