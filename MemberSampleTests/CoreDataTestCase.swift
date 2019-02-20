//
//  CoreDataTestCase.swift
//  MemberSampleTests
//
//  Created by Jim Boyd on 2/19/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import XCTest
import MagicalRecord

class CoreDataTestCase: XCTestCase {

	var managedObjectContext: NSManagedObjectContext?

    override func setUp() {
		super.setUp()
		
		MagicalRecord.setDefaultModelFrom(type(of: self))
		MagicalRecord.setupCoreDataStackWithInMemoryStore()
		
		managedObjectContext = NSManagedObjectContext.mr_default()
	}

	override func tearDown() {
		MagicalRecord.cleanUp()
		managedObjectContext = nil

		super.tearDown()
	}

	func testMOC() {
		XCTAssertNotNil(managedObjectContext)
	}
}
