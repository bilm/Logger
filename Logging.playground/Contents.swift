import UIKit
import Logger
import os.log


//: # Logging
//: ###### _(The Lightswitch Way)_
//: by using the stand alone functions
//: **Log(Bool,Any...)** and **Label(Any...)**
//: or by using
//:	**Logger.debug(Any)** and its siblings

var str = "Hello, Lightswitch Logging"

//:
//: #### **Logging** _functions_
//: the basic function are:
//: * Log(Bool, Any...) -- _if true, print the items to STDERR_
//: * Label(Any...) -- _print the items to STDERR_
//: * Log(Error, message:Any?) -- _if there is an Error, print the message or the Error description_
//:
Log(true, "bullseye")
Log(true, "scoping", "scrying", 12)
Label("targetting")
Label(12, "discovering")

enum FalseError:Int,LocalizedError {
	case DOOM=911
	public var errorDescription: String? { return "\(rawValue) -- DOOM and GLOOM" }
}
Log(FalseError.DOOM)

print()

//:
//: ##### **Logger** _"globally"_
//: there are 7 "logging" levels:
//: `ALL`, `DEBUG`, `INFO`, `WARNING`, `ERROR`, `FATAL` and `OFF`
//: there are 5 logging functions:
//:	`debug`, `info`, `warning`, `error` and `fatal`
//:
//: these methods are present both as a class method and a normal instance method.
//: there is a class variable (`Level`) that controls the currently visible levels
//: that can be displayed and when set to `OFF`, no messages are displayed at all.
//: for example, setting the `Level` to `WARNING` means that _warning_, _error_
//: and _fatal_ messages are displayed, but _debug_ and _info_ messages are not.
//:
Logger.Level = .WARNING

print( Logger.Level )

Logger.debug("sayit")
Logger.info("sayit")
Logger.warning("sayit", "warning")
Logger.error("sayit")
Logger.fatal("sayit")

//:
//: ##### **Logger** _"locally"_
//: when logging locally, an instance is used.
//: this instance determines which method will (or will not) display a message.
//:
//: **NOTE:** then the `Logger.Level` is set to `OFF`, no method will display
//: message.
//:
let logger:Logger = .FATAL

logger.debug("sayitagain")
logger.info("sayitagain")
logger.warning("sayitagain")
logger.error("sayitagain")
logger.fatal("sayitagain")
print()
//:
//: #### basic test
//:
//:	import Foundation
//:
//:	fileprivate let MyLogger = Logger.DEBUG
//:
//:	public
//:	struct BasicLogging
//:	{
//:		public
//:		static
//:		func test() {
//:			Logger.info("everything")
//:			MyLogger.info("something")
//:		}
//:	}
//:
//BasicLogging.test()
//print()

//:
//: #### Using OSLog
//:

extension OSLog {
	public static func playground(_ category:String) ->OSLog {
		return OSLog(subsystem: "com.lsi.playground", category: category)
	}
}

Logger.warning("sayit", "oslog", oslog:.playground("test"))
Logger.error("demoIt", oslog:.playground("demo"))
Logger.info("displayIt", oslog:.playground("demo"))

print()

//:
//: #### Requiring a minimal level
//: the main reason for this is when we are debugging
//: and do not want side effects to occur when the level
//: is higher than what is required.
//:
logger.requires(.INFO) {
	logger in
	logger.debug("we are debuging")
	logger.info("we must informative")
	logger.warning("this is too high")
	logger.error("we are in bad shape")
	logger.fatal("we are done")
}

print("done")
