//
//  Dictionary+Json.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import Foundation
import DBC

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
	@inline(__always) public func asString(_ key: Key) -> String? {
		if let value = self[key] as? String {
			return value
		}
		
		return nil
	}
	
	@inline(__always) public func requireString(_ key: Key) -> String {
		guard let value = self.asString(key) else {
			checkFailure("Could not load a String from dictionary with key : \(key)")
			return ""
		}
		
		return value
	}
	
	@inline(__always) public func asArray<T>(_ key: Key) -> [T]? {
		if let value = self[key] as? [T] {
			return value
		}
		
		return nil
	}
	
	@inline(__always) public func requireArray<T>(_ key: Key) -> [T] {
		guard let value: [T] = self.asArray(key) else {
			checkFailure("Could not load an array of \(T.self) from dictionary with key : \(key)")
			return  [T]()
		}
		
		return value
	}
	
	@inline(__always) public func asDictionary(_ key: Key) -> [String: Any]? {
		if let value = self[key] as? [String: Any] {
			return value
		}
		
		return nil
	}
	
	@inline(__always) public func requireDictionary(_ key: Key) -> [String: Any] {
		guard let value = self.asDictionary(key) else {
			checkFailure("Could not load an dictionary from dictionary with key : \(key)")
			return  [String: Any]()
		}
		
		return value
	}
	
	@inline(__always) public func asNumber(_ key: Key) -> NSNumber? {
		if let value = self[key] as? NSNumber {
			return value
		}
		
		return nil
	}
	
	@inline(__always) public func requireNumber(_ key: Key) -> NSNumber {
		guard let value = self.asNumber(key) else {
			checkFailure("Could not load a NSNumber from dictionary with key : \(key)")
			return NSNumber(value: 0)
		}
		
		return value
	}
	
	@inline(__always) public func asDouble(_ key: Key) -> Double? {
		if let numberVal = self.asNumber(key) {
			return numberVal.doubleValue
		}
		else if let stringVal = self.asString(key) {
			return Double(stringVal)
		}
		
		return nil
	}
	
	@inline(__always) public func requireDouble(_ key: Key) -> Double {
		guard let value = self.asDouble(key) else {
			checkFailure("Could not load a Double from dictionary with key : \(key)")
			return 0.0
		}
		
		return value
	}
	
	@inline(__always) public func asInt(_ key: Key) -> Int? {
		if let numberVal = self.asNumber(key) {
			return numberVal.intValue
		}
		else if let stringVal = self.asString(key) {
			return Int(stringVal)
		}
		
		return nil
	}
	
	@inline(__always) public func requireInt(_ key: Key) -> Int {
		guard let value = self.asInt(key) else {
			checkFailure("Could not load a Int from dictionary with key : \(key)")
			return 0
		}
		
		return value
	}
	
	@inline(__always) public func asBool(_ key: Key) -> Bool? {
		if let numberVal = self.asNumber(key) {
			return numberVal.boolValue
		}
		else if let stringVal = self.asString(key) {
			return Bool(stringVal)
		}
		
		return nil
	}
	
	@inline(__always) public func requireBool(_ key: Key) -> Bool {
		guard let value = self.asBool(key) else {
			checkFailure("Could not load a Bool from dictionary with key : \(key)")
			return false
		}
		
		return value
	}
}
