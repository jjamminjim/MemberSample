//
//  FetchableDecodableArrayTest.swift
//  MemberSampleTests
//
//  Created by Jim Boyd on 2/19/19.
//  Copyright © 2019 Cabosoft. All rights reserved.
//

import XCTest
import DBC
@testable import class MemberSample.Member

class FetchableDecodableArrayTest: CoreDataTestCase {

    override func setUp() {
		super.setUp()
	}

    override func tearDown() {
		super.tearDown()
    }

	func testCoreDataCreate() {
		guard let context = self.managedObjectContext else {
			require(self.managedObjectContext != nil)
			return
		}
		
		let theData = responseData
		
		self.measure {
			do {
				let results: [[String:Any]]? = theData.toJSON()?.asArray("individuals")
				XCTAssertTrue(results != nil)
				
				var items = [Member]()
				items.reserveCapacity(results!.count)
				
				var setItems = Set<Member>()
				setItems.reserveCapacity(results!.count / 3)
				
				for json in results! {
					let member = try Member.findOrCreate(for: json, in: context)
					
					XCTAssertTrue(member.firstName != nil)
					XCTAssertTrue(member.birthdate != nil)
					
					items.append(member)
					setItems.insert(member)
				}
				XCTAssertTrue(items.count == 24)
				XCTAssertTrue(setItems.count == 8)
			}
			catch {
				print(error as NSError)
				XCTAssertFalse(true, "failed with error \(error)")
			}
		}
		
		let count = Member.mr_numberOfEntities(with: context)
		XCTAssertTrue(count == 8)
	}
}

fileprivate let responseData = """
{
  "individuals": [
    {
      "id":1,
      "firstName":"Luke",
      "lastName":"Skywalker",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/07.png",
      "forceSensitive":true,
      "affiliation":"JEDI"
    },
    {
      "id":2,
      "firstName":"Leia",
      "lastName":"Organa",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/06.png",
      "forceSensitive":true,
      "affiliation":"RESISTANCE"
    },
    {
      "id":3,
      "firstName":"Han",
      "lastName":"Solo",
      "birthdate":"1956-08-22",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/04.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":4,
      "firstName":"Chewbacca",
      "lastName":"",
      "birthdate":"1782-11-15",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/01.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":5,
      "firstName":"Kylo",
      "lastName":"Ren",
      "birthdate":"1987-10-31",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/05.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":6,
      "firstName":"Supreme Leader",
      "lastName":"Snoke",
      "birthdate":"1947-01-01",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/08.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":7,
      "firstName":"General",
      "lastName":"Hux",
      "birthdate":"1982-07-04",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/03.png",
      "forceSensitive":false,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":8,
      "firstName":"Darth",
      "lastName":"Vader",
      "birthdate":"1947-07-13",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/02.jpg",
      "forceSensitive":true,
      "affiliation":"SITH"
    },
    {
      "id":1,
      "firstName":"Luke",
      "lastName":"Skywalker",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/07.png",
      "forceSensitive":true,
      "affiliation":"JEDI"
    },
    {
      "id":2,
      "firstName":"Leia",
      "lastName":"Organa",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/06.png",
      "forceSensitive":true,
      "affiliation":"RESISTANCE"
    },
    {
      "id":3,
      "firstName":"Han",
      "lastName":"Solo",
      "birthdate":"1956-08-22",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/04.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":4,
      "firstName":"Chewbacca",
      "lastName":"",
      "birthdate":"1782-11-15",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/01.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":5,
      "firstName":"Kylo",
      "lastName":"Ren",
      "birthdate":"1987-10-31",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/05.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":6,
      "firstName":"Supreme Leader",
      "lastName":"Snoke",
      "birthdate":"1947-01-01",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/08.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":7,
      "firstName":"General",
      "lastName":"Hux",
      "birthdate":"1982-07-04",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/03.png",
      "forceSensitive":false,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":8,
      "firstName":"Darth",
      "lastName":"Vader",
      "birthdate":"1947-07-13",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/02.jpg",
      "forceSensitive":true,
      "affiliation":"SITH"
    },
    {
      "id":1,
      "firstName":"Luke",
      "lastName":"Skywalker",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/07.png",
      "forceSensitive":true,
      "affiliation":"JEDI"
    },
    {
      "id":2,
      "firstName":"Leia",
      "lastName":"Organa",
      "birthdate":"1963-05-05",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/06.png",
      "forceSensitive":true,
      "affiliation":"RESISTANCE"
    },
    {
      "id":3,
      "firstName":"Han",
      "lastName":"Solo",
      "birthdate":"1956-08-22",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/04.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":4,
      "firstName":"Chewbacca",
      "lastName":"",
      "birthdate":"1782-11-15",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/01.png",
      "forceSensitive":false,
      "affiliation":"RESISTANCE"
    },
    {
      "id":5,
      "firstName":"Kylo",
      "lastName":"Ren",
      "birthdate":"1987-10-31",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/05.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":6,
      "firstName":"Supreme Leader",
      "lastName":"Snoke",
      "birthdate":"1947-01-01",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/08.jpg",
      "forceSensitive":true,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":7,
      "firstName":"General",
      "lastName":"Hux",
      "birthdate":"1982-07-04",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/03.png",
      "forceSensitive":false,
      "affiliation":"FIRST_ORDER"
    },
    {
      "id":8,
      "firstName":"Darth",
      "lastName":"Vader",
      "birthdate":"1947-07-13",
      "profilePicture":"https://edge.ldscdn.org/mobile/interview/02.jpg",
      "forceSensitive":true,
      "affiliation":"SITH"
    }
  ]
}
""".data(using: .utf8)!
