import XCTest
import os.log

@testable import Logger

final class LoggerTests: XCTestCase {
    
	override func setUp() {

		Logger[Something.self] = .WARNING
		
		UserDefaults.standard
			.register(defaults: [
				"logger": "INFO",
				"logger.Other":"FATAL",
			])
	}
	
	override class func tearDown() {
		Logger.remove(Something.self)
		Logger.remove(Other.self)
	}
	
	func testBasicLog() {
		
		Log(true, "bullseye")
		Log(true, "scoping", "scrying", 12)

	}

	func testBasicLabel() {
		
		Label("targetting")
		Label(12, "discovering")

	}

	func testErrorLog() {
		
		enum FalseError:Int,LocalizedError {
			case DOOM=911
			public var errorDescription: String? { return "\(rawValue) -- DOOM and GLOOM" }
		}
		Log(FalseError.DOOM)

	}

	func testLoggerLevel() {
		
		let saved = Logger.Level
		defer { Logger.Level = saved }
		
		Logger.Level = .WARNING
		print(Logger.Level)

	}
	
	func testGlobalLogs() {
		
		Logger.debug("sayit")
		Logger.info("sayit")
		Logger.warning("sayit", "warning")
		Logger.error("sayit")
		Logger.fatal("sayit")

	}
	
	func testLocalLogs() {
		
		let logger:Logger = .FATAL

		logger.debug("sayitagain")
		logger.info("sayitagain")
		logger.warning("sayitagain")
		logger.error("sayitagain")
		logger.fatal("sayitagain")
		
	}
	
	func testUsingOSLog() {
		
		Logger.warning("sayit", "oslog", oslog:.loggerTests("test"))
		Logger.error("demoIt", oslog:.loggerTests("demo"))
		Logger.info("displayIt", oslog:.loggerTests("demo"))

	}
	
	func testRequiredLevelSuccess() {
		
		let logger:Logger = .FATAL

		logger.requires(.INFO) {
			logger in
			logger.debug("we are debuging")
			logger.info("we must informative")
			logger.warning("this is too high")
			logger.error("we are in bad shape")
			logger.fatal("we are done")
		}
	}
	
	func testRequiredLevelFailure() {
		
		let logger:Logger = .DEBUG

		logger.requires(.INFO) {
			logger in
			logger.debug("we are debuging")
			logger.info("we must informative")
			logger.warning("this is too high")
			logger.error("we are in bad shape")
			logger.fatal("we are done")
		}
	}
	
	struct Something {}
	struct Other {}
	func testPerType() {
		
		XCTAssertEqual(Logger[ Something.self ], .WARNING)

		XCTAssertNotEqual(Logger[ Other.self ], .Level)
		XCTAssertEqual(Logger[ Other.self ], .INFO)

	}
	
    static var allTests = [
        ("testBasicLog", testBasicLog),
        ("testBasicLabel", testBasicLabel),
		("testErrorLog", testErrorLog),
		("testLoggerLevel", testLoggerLevel),
		("testLevelLogs", testGlobalLogs),
		("testLocalLogs", testLocalLogs),
		("testUsingOSLog", testUsingOSLog),
		("testRequiredLevelSuccess", testRequiredLevelSuccess),
		("testRequiredLevelFailure", testRequiredLevelFailure),
    ]
	
}

extension OSLog {
	
	public static func loggerTests(_ category:String) ->OSLog {
		OSLog(subsystem: "com.lsi.logger.tests", category: category)
	}
	
}

