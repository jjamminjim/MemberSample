//
//  Syncable.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//
// Protocol that provides a simple syncing ability between backing-server and local core-data store.
// Note that the implementation is quick and dirty, simply supporting the requirements of this coding
// sample.
//

import Foundation
import CoreData
import DBC
import Alamofire

protocol Syncable: FetchableDecodable {
	static func simpleSync(from url: URL, dataPath: String?, parentContect: NSManagedObjectContext)
}

extension Syncable {
	static func simpleSync(from url: URL, dataPath: String?, parentContect: NSManagedObjectContext) {
		Alamofire.request(url).responseJSON { response in
			print("Request: \(String(describing: response.request))")   // original url request
			print("Response: \(String(describing: response.response))") // http url response
			print("Result: \(response.result)")                         // response serialization result
			
			switch response.result {
			case .success:
				// We also should support single objects, arrays of objects, but for now ...
				if let jsonResponse = response.result.value as? [String: Any] {
					if let dataPath = dataPath, let syncdata = jsonResponse[dataPath] as? [[String: Any]] {
						
						// Do this work in a private background context...
						let type: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType
						let localContext = NSManagedObjectContext(concurrencyType: type)
						localContext.parent = parentContect
						localContext.undoManager = nil

						localContext.perform {
							do {
								for json in syncdata {
									_ = try Self.findOrCreate(for: json, in: parentContect)
								}
								
								try localContext.save()
							}
							catch {
								print(error)
							}
						}
					}
				
					print("Validation Successful")
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}
