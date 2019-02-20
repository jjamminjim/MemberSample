//
//  main.swift
//  DBC
//
//  Created by Jim Boyd on 7/26/16.
//  Copyright © 2016 Busy, LLC. All rights reserved.
//  See: http://cleanswifter.com/broken-code-coverage-xcode-fix/
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass : AnyClass = isRunningTests ? TestingAppDelegate.self : AppDelegate.self

UIApplicationMain(
	CommandLine.argc,
	CommandLine.unsafeArgv,
	nil,
	NSStringFromClass(appDelegateClass)
)
