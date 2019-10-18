import XCTest
import os.log

@testable import Logger

final class LoggerTests: XCTestCase {
    
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
	
}
