//
//  Logger.swift
//  Logger
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os.log

//
//	Simplistic Logger
//
//	usage:
//		Logger.Level = .WARNING
//
//		Logger.debug("sayit")
//		Logger.info("sayit")
//		Logger.warning("sayit")
//		Logger.error("sayit")
//		Logger.fatal("sayit")
//
//		let logger:Logger = .FATAL
//
//		logger.debug("sayitagain")
//		logger.info("sayitagain")
//		logger.warning("sayitagain")
//		logger.error("sayitagain")
//		logger.fatal("sayitagain")
//
//  NOTE:
//
//      setting Logger.Level = .OFF will turn off ALL logging through 
//      this class/functionality
//
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
