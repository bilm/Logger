//
//  Logger.swift
//  Logger
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os

public
enum Logger: Int, Sendable {
	
	case all = 0
	case DEBUG
	case MEASURE
	case INFO
	case WARNING
	case ERROR
	case FATAL
	case off
	
	public static var Level = all
	
}

extension Logger {
	
	public
	static
	func debug(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.debug(message:message, oslog:oslog, function:function)
	}
	public
	func debug(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		debug(message:message, oslog:oslog, function:function)
	}
	
	
	public
	static
	func measure(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.measure(message:message, oslog:oslog, function:function)
	}
	public
	func measure(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		measure(message:message, oslog:oslog, function:function)
	}
	

	public
	static
	func info(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.info(message:message, oslog:oslog, function:function)
	}
	public
	func info(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		info(message:message, oslog:oslog, function:function)
	}
	
	
	public
	static
	func warning(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.warning(message:message, oslog:oslog, function:function)
	}
	public
	func warning(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		warning(message:message, oslog:oslog, function:function)
	}
	
	
	public
	static
	func error(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.error(message:message, oslog:oslog, function:function)
	}
	public
	func error(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		error(message:message, oslog:oslog, function:function)
	}
	
	
	public
	static
	func fatal(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		Level.fatal(message:message, oslog:oslog, function:function)
	}
	public
	func fatal(_ message:Any..., oslog:OSLog? = nil, function: String = #function) {
		fatal(message:message, oslog:oslog, function:function)
	}
	
}

extension Logger: Comparable {
	
	public static func ==(lhs:Logger,rhs:Logger) ->Bool { return lhs.rawValue == rhs.rawValue }
	public static func <(lhs:Logger,rhs:Logger) ->Bool { return lhs.rawValue < rhs.rawValue }
	
}

extension Logger {
	
	fileprivate
	func debug(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .DEBUG, message:message, tag:"DEBUG", oslog:oslog, oslogtype:.debug, function:function)
	}
	
	fileprivate
	func measure(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .MEASURE, message:message, tag:"MEASURE", oslog:oslog, oslogtype:.info, function:function)
	}
	
	fileprivate
	func info(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .INFO, message:message, tag:"INFO", oslog:oslog, oslogtype:.info, function:function)
	}
	
	fileprivate
	func warning(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .WARNING, message:message, tag:"WARNING", oslog:oslog, oslogtype:.`default`, function:function)
	}
	
	fileprivate
	func error(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .ERROR, message:message, tag:"ERROR", oslog:oslog, oslogtype:.error, function:function)
	}
	
	fileprivate
	func fatal(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .FATAL, message:message, tag:"FATAL", oslog:oslog, oslogtype:.fault, function:function)
	}
	
}

extension Logger {
	
	public
	func requires(_ logger:Logger, closure:(Logger) -> Void) {
		guard logger <= self else { return }
		closure(self)
	}
	
}

extension Logger {
	
	public init(named name: String) {

		switch name.uppercased() {
		case "ALL":		self = .all
		case "DEBUG":	self = .DEBUG
		case "MEASURE":	self = .MEASURE
		case "INFO":	self = .INFO
		case "WARNING":	self = .WARNING
		case "ERROR":	self = .ERROR
		case "FATAL":	self = .FATAL
		case "OFF":		self = .off
		default:		self = .all
		}

	}

	fileprivate static func make(key: Any) ->String { "logger.\(key)" }
	
	fileprivate static func lookup(_ type: Any.Type) ->String? {
		
		let qualified = String(reflecting:type)
		var parts: [String] = ["logger"] + qualified.split(separator: ".").map { String($0) }
		while !parts.isEmpty {
			let key = parts.joined(separator: ".")
			Log(false, "KEY", key)
			if let name =  UserDefaults.standard.string(forKey: key) {
				return name
			}
			parts = parts.dropLast()
		}
		
		let name = String(describing: type)
		return UserDefaults.standard.string(forKey: make(key: name) )
		
	}
	
	public static func remove(_ type: Any.Type) {
		let rKey = String(reflecting:type)
		UserDefaults.standard.set(nil, forKey: make(key: rKey))

		let dKey = String(describing: type)
		UserDefaults.standard.set(nil, forKey: make(key: dKey))
	}
	
	public static subscript(type: Any.Type) ->Logger {
		
		get {
			return lookup(type).map { Logger(named: $0) } ?? Level
		}
		
		set {
			let key = String(reflecting:type)
			let value = String(describing: newValue)
			UserDefaults.standard.register(defaults: [make(key: key):value])
		}
		
		
	}
	
}

#if canImport(Combine)
import Combine

//@available(iOS 13.0, macOS 15.0, *)
extension Publisher {
	
	public func debug(_ messages: Any..., logger: Logger = .Level, transform: @escaping (Output)->Any = { $0 }) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveOutput: { logger.debug(message: messages + [ transform($0) ]) } ) 
		
	}

	public func info(_ messages: Any..., logger: Logger = .Level, transform: @escaping (Output)->Any = { $0 }) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveOutput: { logger.info(message: messages + [ transform($0) ]) } ) 
		
	}

	public func warning(_ messages: Any..., logger: Logger = .Level, transform: @escaping (Output)->Any = { $0 }) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveOutput: { logger.warning(message: messages + [ transform($0) ]) } ) 
		
	}

	public func error(_ messages: Any..., logger: Logger = .Level, transform: @escaping (Output)->Any = { $0 }) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveOutput: { logger.error(message: messages + [ transform($0) ]) } ) 
		
	}

	public func fatal(_ messages: Any..., logger: Logger = .Level, transform: @escaping (Output)->Any = { $0 }) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveOutput: { logger.fatal(message: messages + [ transform($0) ]) } ) 
		
	}

}


//@available(iOS 13.0, macOS 15.0, *)
extension Publisher {
	
	public func measure(_ messages: Any..., logger: Logger = .Level, from then: Date = Date(), tag: String = "MEASURE" ) ->Publishers.HandleEvents<Self> {
		
		handleEvents(receiveCompletion: {
			
			_ in
			logger.measure(message: messages + [ -then.timeIntervalSinceNow ])
			
		})
		
	}
	
}


#endif
