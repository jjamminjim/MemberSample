//
//  Fetchable.swift
//  Pods
//
//  Created by Jim Boyd on 2/8/16.
//
//  Utility protocol for custom NSManagedObjects context querying.
//  See https://gist.github.com/capttaco/adb38e0d37fbaf9c004e
//

import class CoreData.NSManagedObject
import class CoreData.NSManagedObjectID
import class CoreData.NSManagedObjectContext
import class CoreData.NSFetchRequest
import class CoreData.NSEntityDescription
import protocol CoreData.NSFetchRequestResult
import DBC


public protocol Fetchable where Self: NSManagedObject {
	static func objectsInContext<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> [T]
	
	static func objectsInContext<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]?) throws -> [T]
	
	static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) throws -> Self?
	
	static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]?) throws -> Self?
	
	static func objectCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate?) -> Int
	
	static func values(for keys: [String], predicate: NSPredicate?, in context: NSManagedObjectContext) -> [[String: Any]]
	
	static func values<T>(for key: String, predicate: NSPredicate?, in context: NSManagedObjectContext) -> [T]
	
	static func ids(with predicate: NSPredicate?, in context: NSManagedObjectContext) -> [NSManagedObjectID]
	
	static func fetchRequest<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> NSFetchRequest<T>
	
	static func fetchRequest<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<T>
}

public extension Fetchable {
	
	private static func cachedEntityDescriptionKey(_ context: NSManagedObjectContext) -> String {
		return "CachedEntityDescriptionKey+\(Self.nameOfClass())+\(context.hashValue)"
	}
	
	public static func entityDescription(_ context: NSManagedObjectContext) -> NSEntityDescription {
		let threadDictionary = Thread.current.threadDictionary
		var entityDescription = threadDictionary[cachedEntityDescriptionKey(context)] as? NSEntityDescription
		
		if entityDescription == nil {
			entityDescription = NSEntityDescription.entity(forEntityName: nameOfClass(), in: context)
			threadDictionary[cachedEntityDescriptionKey(context)] = entityDescription
		}
		
		return entityDescription!
	}
	
	public static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> Self? {
		let request:NSFetchRequest<Self> = fetchRequest(context, predicate: predicate, sortedBy: sortedBy, ascending: ascending)
		request.fetchLimit = 1
		
		let fetchResults = try context.fetch(request)
		guard fetchResults.count > 0 else { return nil }
		
		return fetchResults.first
	}
	
	public static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]?) throws -> Self? {
		let request:NSFetchRequest<Self> = fetchRequest(context, predicate: predicate, sortedBy: sortDescriptors)
		request.fetchLimit = 1
		
		let fetchResults = try context.fetch(request)
		guard fetchResults.count > 0 else { return nil }
		
		return fetchResults.first
	}
	
	public static func objectCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
		let request:NSFetchRequest<Self> = fetchRequest(context, predicate: predicate)
		
		let result = try? context.count(for: request)
		guard let count = result else {
			NSLog("Error retrieving data in call to countForFetchRequest")
			return 0
		}
		
		return count
	}
	
	public static func objectsInContext<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) throws -> [T] {
		let request:NSFetchRequest<T> = fetchRequest(context, predicate: predicate, sortedBy: sortedBy, ascending: ascending)
		let fetchResults = try context.fetch(request)
		
		return fetchResults
	}
	
	public static func objectsInContext<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]?) throws -> [T] {
		let request:NSFetchRequest<T> = fetchRequest(context, predicate: predicate, sortedBy: sortDescriptors)
		let fetchResults = try context.fetch(request)
		
		return fetchResults
	}
	
	public static func fetchRequest<T: Fetchable>(_ context: NSManagedObjectContext) -> NSFetchRequest<T> {
		let request = NSFetchRequest<T>()
		request.entity = Self.entityDescription(context)
		
		return request
	}
	
	public static func fetchRequest<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) -> NSFetchRequest<T> {
		var sortBy: [NSSortDescriptor]? = nil
		
		if (sortedBy != nil) {
			let sort = NSSortDescriptor(key: sortedBy, ascending: ascending)
			sortBy = [sort]
		}
		
		return fetchRequest(context, predicate: predicate, sortedBy: sortBy)
	}
	
	
	public static func fetchRequest<T: Fetchable>(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<T> {
		let request:NSFetchRequest<T> = self.fetchRequest(context)
		
		if predicate != nil {
			request.predicate = predicate
		}
		
		if (sortDescriptors != nil) {
			request.sortDescriptors = sortDescriptors
		}
		
		return request
	}
	
	public static func values(for keys: [String], predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> [[String: Any]] {
		let request = NSFetchRequest<NSFetchRequestResult>()
		request.entity = Self.entityDescription(context)
		request.predicate = predicate
		request.propertiesToFetch = keys
		request.returnsDistinctResults = true
		request.resultType = .dictionaryResultType
		
		do {
			return (try context.fetch(request) as! [[String: Any]])
		} catch {
			requireFailure("Failed to get values from keys \(keys) for type \(nameOfClass()).")
			return [[:]]
		}
	}
	
	public static func values<T>(for key: String, predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> [T] {
		let request = NSFetchRequest<NSFetchRequestResult>()
		request.entity = Self.entityDescription(context)
		request.predicate = predicate
		request.propertiesToFetch = [key]
		request.returnsDistinctResults = true
		request.resultType = .dictionaryResultType
		
		do {
			let result = try context.fetch(request)
			let mappedResult = (result as NSArray).value(forKey: key)
			return mappedResult as! [T]
		} catch {
			requireFailure("Failed to get values from key \(key) for type \(nameOfClass()) : \(error).")
			return []
		}
	}
	
	static func ids(with predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> [NSManagedObjectID] {
		do {
			let allItems:[Self] = try self.objectsInContext(context, predicate: predicate, sortedBy: nil, ascending: false)
			
			let result = allItems.reduce([NSManagedObjectID]()) { (list, item) -> [NSManagedObjectID] in
				var list = list
				list.append(item.objectID)
				
				return list
			}
			
			return result
			
		} catch {
			requireFailure("Failed to get items for type \(nameOfClass()).")
			return []
		}
	}
}

