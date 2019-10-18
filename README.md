# Logger
###### _(The Lightswitch Way)_
by using the stand alone functions **Log(Bool,Any...)** and **Label(Any...)** 
or by using the **Logger.debug(Any)** and its siblings

- - - 

## _functions_
the basic function are:

* **Log(Bool, Any...)** -- _if true, print the items to STDERR_
* **Label(Any...)** -- _print the items to STDERR_
* **Log(Error, message:Any?)** -- _if there is an Error, print the message or the Error description_

```swift
Log(true, "bullseye")
Log(true, "scoping", "scrying", 12)
Label("targetting")
Label(12, "discovering")

enum FalseError:Int,LocalizedError { 
	case DOOM=911
	public var errorDescription: String? { return "\(rawValue) -- DOOM and GLOOM" }
}
Log(FalseError.DOOM)
```

## _"globally"_
there are 7 "logging" levels:  `ALL`, `DEBUG`, `INFO`, `WARNING`, `ERROR`, `FATAL` and `OFF`  
there are 5 logging functions: `debug`, `info`, `warning`, `error` and `fatal`  

these methods are present both as a class method and a normal instance method.
there is a class variable (`Level`) that controls the currently visible levels
that can be displayed and when set to `OFF`, no messages are displayed at all.
for example, setting the `Level` to `WARNING` means that _warning_, _error_
and _fatal_ messages are displayed, but _debug_ and _info_ messages are not.

```swith
Logger.Level = .WARNING

print( Logger.Level )

Logger.debug("sayit")
Logger.info("sayit")
Logger.warning("sayit", "warning")
Logger.error("sayit")
Logger.fatal("sayit")
```

## _"locally"_
_when logging locally, an instance is used._
_this instance determines which method will (or will not) display a message._  

**NOTE:** _when the `Logger.Level` is set to `OFF`, no method will display a message._
```swift
let logger:Logger = .FATAL

logger.debug("sayitagain")
logger.info("sayitagain")
logger.warning("sayitagain")
logger.error("sayitagain")
logger.fatal("sayitagain")
print()
```
## As a `fileprivate` variable
```swift
import Foundation

fileprivate let MyLogger = Logger.DEBUG

public
struct BasicLogging {
	public static func test() {
		Logger.info("everything")
		MyLogger.info("something")
	}
}

BasicLogging.test()
```

## Using OSLog
```swift
extension OSLog {
	public static func playground(_ category:String) ->OSLog {
		return OSLog(subsystem: "com.lsi.playground", category: category)
	}
}

Logger.warning("sayit", "oslog", oslog:.playground("test"))
Logger.error("demoIt", oslog:.playground("demo"))
Logger.info("displayIt", oslog:.playground("demo"))
```

## Requiring a minimal level
_the main reason for this is when we are debugging and do not want side effects to occur when the level is higher than what is required._
```swift
logger.requires(.INFO) {
	logger in
	logger.debug("we are debuging")
	logger.info("we must informative")
	logger.warning("this is too high")
	logger.error("we are in bad shape")
	logger.fatal("we are done")
}
```
