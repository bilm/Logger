//
//  Logger.swift
//  Logger
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation

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
	func debug(_ message:Any..., function: String = #function) {
		Level.debug(message:message, function:function)
	}
	public
	func debug(_ message:Any..., function: String = #function) {
		debug(message:message, function:function)
	}
	
	
	public
	static
	func info(_ message:Any..., function: String = #function) {
		Level.info(message:message, function:function)
	}
	public
	func info(_ message:Any..., function: String = #function) {
		info(message:message, function:function)
	}
	
	
	public
	static
	func warning(_ message:Any..., function: String = #function) {
		Level.warning(message:message, function:function)
	}
	public
	func warning(_ message:Any..., function: String = #function) {
		warning(message:message, function:function)
	}
	
	
	public
	static
	func error(_ message:Any..., function: String = #function) {
		Level.error(message:message, function:function)
	}
	public
	func error(_ message:Any..., function: String = #function) {
		error(message:message, function:function)
	}
	
	
	public
	static
	func fatal(_ message:Any..., function: String = #function) {
		Level.fatal(message:message, function:function)
	}
	public
	func fatal(_ message:Any..., function: String = #function) {
		fatal(message:message, function:function)
	}
	
}

extension Logger: Comparable {
	public static func ==(lhs:Logger,rhs:Logger) ->Bool { return lhs.rawValue == rhs.rawValue }
	public static func <(lhs:Logger,rhs:Logger) ->Bool { return lhs.rawValue < rhs.rawValue }
}

extension Logger {
	private
	func debug(message:[Any], function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .DEBUG, message:message, tag:"DEBUG", function:function)
	}
	
	private
	func info(message:[Any], function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .INFO, message:message, tag:"INFO", function:function)
	}
	
	private
	func warning(message:[Any], function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .WARNING, message:message, tag:"WARNING", function:function)
	}
	
	private
	func error(message:[Any], function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .ERROR, message:message, tag:"ERROR", function:function)
	}
	
	private
	func fatal(message:[Any], function: String = #function) {
		if case .off = Logger.Level { return }
		Log(self <= .FATAL, message:message, tag:"FATAL", function:function)
	}
	
}

extension Logger {
	
	public
	func requires(_ logger:Logger, closure:(Logger) -> Void) {
		guard logger <= self else { return }
		closure(self)
	}
	
}
