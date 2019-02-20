//
//  JSONSerialization+Additions.swift
//  RxTrax
//
//  Created by Jim Boyd on 2/14/17.
//  Copyright © 2017 busybusy. All rights reserved.
//

import Foundation
import DBC

public extension JSONSerialization {
	@objc public static func toJSONString(_ json: Any, prettyPrint: Bool = false) -> String? {
		let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
		if let json = JSONSerialization.toJSONData(json, options: options) {
			return String(data: json, encoding: String.Encoding.utf8)
		}
		
		return nil
	}
	
	/// Converts an Object to JSON data with options
	@objc public static func toJSONData(_ json: Any, options: JSONSerialization.WritingOptions) -> Data? {
		if JSONSerialization.isValidJSONObject(json) {
			let jsonData: Data?
			do {
				jsonData = try JSONSerialization.data(withJSONObject: json, options: options)
			} catch let error {
				print(error)
				jsonData = nil
			}
			
			return jsonData
		}
		
		return nil
	}
	
	@objc public static func toJSON(with jsonString:String, options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		guard let data = jsonString.data(using: .utf8) else {
//			checkFailure("Failed to convert String to Data")
			return nil
		}

		return JSONSerialization.toJSON(from:data, options:options)
	}

	@objc public static func toJSON(from jsonData:Data, options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		
		guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
			//			checkFailure("Failed to convert data to JSON dictionary")
			return nil
		}
		
		guard let json = jsonObject as? [String:Any] else {
			//			checkFailure("Failed to convert data to JSON dictionary")
			return nil
		}
		
		return json
	}
}

public extension Dictionary {
	public func toJSONString(prettyPrint: Bool = false) -> String? {
		guard JSONSerialization.isValidJSONObject(self) else {
//			checkFailure("Could not covert dictionary to valid JSON object")
			return nil
		}
		
		return JSONSerialization.toJSONString(self, prettyPrint:prettyPrint)
	}
}

public extension String {
	public func toJSON(options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		return JSONSerialization.toJSON(with:self, options:options)
	}
}

public extension Data {
	public func toJSON(options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		return JSONSerialization.toJSON(from:self, options:options)
	}
}

public extension NSString {
	@objc public func toJSON(options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		return JSONSerialization.toJSON(with:self as String, options:options)
	}
}

public extension NSData {
	@objc public func toJSON(options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		return JSONSerialization.toJSON(from:self as Data, options:options)
	}
}
