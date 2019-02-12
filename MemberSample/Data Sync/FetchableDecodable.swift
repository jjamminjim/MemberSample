//
// FetchableDecodable.swift
//
// Created by Jim Boyd on 11/2/17.
//
// Allows us to decode json data directly into NSManagedObject instances.
// Existing objects are first queried from the data-store, and if not present, the object is created.
// The object is then updated with the json data. Duplicate objects creted on multiple threads are avoided
// by syncronizing through a DispatchQueue supplied by a DispatchQueueDictionary keyed by NSManagedObject class names.
//
// This is a simple, fast implementation of this concept. There are a few assumptions made in the default
// implementations, but these can be overridden in the class implementation as needed. Also, a caching mechanism
// should be (but is not) employed to avoid frequent queries to the data-store for commonly referenced objects.
//
// Inspired by :
// http://ffried.codes/2017/10/20/codable-coredata/
//


import CoreData
import DBC

public var sFindOrCreatelLockQueue = DispatchQueueDictionary()

public protocol FetchableDecodable: Fetchable {

	// If all assumptions and defaults are correct then this is the only method that is required
	// to be implemented to sync core-data with JSON.
	@discardableResult
	func update(with json: [String: Any], in context: NSManagedObjectContext) throws -> Self
	
	// The below methods all have default implementations
	static func keyForEntity(in context: NSManagedObjectContext) -> String // represents the id field in core-data
	static func jsonKeyForEntity(in context: NSManagedObjectContext) -> String // represent the id field in the json data.
	
	static func findOrCreate<T>(withId id:T, in context: NSManagedObjectContext, saveOnCreate: Bool) throws -> Self
	static func findOrCreate(for json: [String: Any], in context: NSManagedObjectContext) throws -> Self
}

extension FetchableDecodable {
	// Default is pulled from a "key" field set in the user-data of the model.
	public static func keyForEntity(in context: NSManagedObjectContext) -> String {
		guard let userInfo = Self.entityDescription(context).userInfo,
			let keyValue = userInfo["key"] as? String else {
				requireFailure("Unable to aquire NSEntityDescription.userinfo for `key` for entity of type \(self.nameOfClass())")
				return ""
		}
		
		return keyValue
	}
	
	// Default simply returns the mySQL default
	public static func jsonKeyForEntity(in context: NSManagedObjectContext) -> String {
		return "id" // SQL default
	}
	
	public static func withId<T>(_ id:T, in context: NSManagedObjectContext) throws -> Self? {
		guard let userInfo = Self.entityDescription(context).userInfo,
			let keyValue = userInfo["key"] as? String else {
				requireFailure("Unable to aquire NSEntityDescription.userinfo for `key` for entity of type \(self.nameOfClass())")
				return nil
		}
		
		let predicate = NSPredicate(format: "%K == %@", argumentArray:[keyValue, id])
		return try singleObjectInContext(context, predicate: predicate);
	}

	public static func create<T>(withId id:T, insertInto context: NSManagedObjectContext) -> Self {
		let entity = Self.entityDescription(context)
		let result = NSEntityDescription.insertNewObject(forEntityName: Self.nameOfClass(), into: context) as? Self
		require(result != nil, "Could not create a \(Self.nameOfClass()) managed object")
		
		guard let userInfo = entity.userInfo,
			let keyValue = userInfo["key"] as? String else {
				requireFailure("Unable to aquire NSEntityDescription.userinfo for `key` for entity of type \(Self.nameOfClass())")
				return result!
		}
		
		result!.setValue(id, forKey: keyValue)
		
		return result!
	}

	public static func findOrCreate<T>(withId id:T, in context: NSManagedObjectContext, saveOnCreate: Bool = false) throws -> Self {
		
		if let result = try Self.withId(id, in: context) {
			return result
		}
		else {
			let result = Self.create(withId: id, insertInto: context)
			
			if (saveOnCreate) {
				try context.obtainPermanentIDs(for: [result])
				try context.save()
			}
			
			return result
		}
	}

	public static func findOrCreate(for json: [String: Any], in context: NSManagedObjectContext) throws -> Self {
		let lockKey = Self.nameOfClass()
		let lockQueue = sFindOrCreatelLockQueue[lockKey]
		
		let result: Self = try lockQueue.sync {
			let key = self.jsonKeyForEntity(in: context)
			let childKey = json[key]
			
			return try findOrCreate(withId: childKey, in: context, saveOnCreate: true).update(with: json, in: context)
		}
		
		return result
	}
}
