//
//  DispatchQueueDictionary.swift
//  MemberSample
//
//  Created by Jim Boyd on 2/11/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import Foundation

public class DispatchQueueDictionary {
	
	private var dictionary = [String: DispatchQueue]()
	private let queue = DispatchQueue(label: "DispatchQueueDictionary")
	
	public func cleanup() {
		queue.sync {
			self.dictionary = [String: DispatchQueue]()
		}
	}
	
	public subscript(key: String) -> DispatchQueue {
		get {
			return queue.sync {
				if let contained = self.dictionary[key] {
					return contained
				}
				else {
					let contained = DispatchQueue(label: key)
					self.dictionary[key] = contained
					//					print("Created new DispatchQueue for key : \(key)")
					return contained
				}
			}
		}
	}
}
