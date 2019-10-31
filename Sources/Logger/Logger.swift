//
//  Logger.swift
//  Logger
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os.log

public
enum Logger:Int {
	case all = 0
	case DEBUG
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
	private
	func debug(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .DEBUG, message:message, tag:"DEBUG", oslog:oslog, oslogtype:.debug, function:function)
	}
	
	private
	func info(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .INFO, message:message, tag:"INFO", oslog:oslog, oslogtype:.info, function:function)
	}
	
	private
	func warning(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .WARNING, message:message, tag:"WARNING", oslog:oslog, oslogtype:.`default`, function:function)
	}
	
	private
	func error(message:[Any], oslog:OSLog? = nil, function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .ERROR, message:message, tag:"ERROR", oslog:oslog, oslogtype:.error, function:function)
	}
	
	private
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
		case "INFO":	self = .INFO
		case "WARNING":	self = .WARNING
		case "ERROR":	self = .ERROR
		case "FATAL":	self = .FATAL
		case "OFF":		self = .off
		default:		self = .all
		}

	}

//	public static subscript(type: Any.Type) ->Logger {
//		
//		func lookup(_ key: String) ->String? {
//			ProcessInfo.processInfo.environment[key]
//			?? UserDefaults.standard.string(forKey: key)
//		}
//		
//		do {
//			let tName = String(reflecting:type)
//			if let lggr = lookup("\(tName).logger").map( { Logger(named: $0) } ) {
//				return lggr
//			}
//		
//			let table = try lookup("LOGGER")
//				.map { Data($0.utf8) }
//				.map { try JSONDecoder().decode([String:String].self, from: $0) }
//			return table?[tName].map{ Logger(named: $0) } ?? Level
//		}
//		catch { return Level }
//		
//	}
	
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
