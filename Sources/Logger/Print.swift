//
//  Print.swift
//  Miscellany
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os.log

///
/// Internal "Print" interface
///
///- parameter items: the items you want printed
///- parameter separator: the string to put between the items
///- parameter terminator: the string to end the output
///- parameter tag: a tag to add to the prefix between the data and the function
///- parameter oslog: (Optional) a OSLog to send the message to
///- parameter oslogtype: the OSLog type of the message
///- parameter reflecting: by default, uses `String(reflecting:)` to convert the items to Strings
///- parameter prefixed: by default, has a prefix of _"[date]tag «function» - "_
///- parameter function: the function being called from; defaults to the actual one
///
internal
func Print(
	_ items: [Any],
	separator: String = " ",
	terminator: String = "\n",
	tag:String = "",
	oslog:OSLog? = nil,
	oslogtype:OSLogType = .`default`,
	reflecting: Bool = true,
	prefixed: Bool = true,
	function: String = #function
) {
	
	let message = reflecting
		? items.map{ String(reflecting: $0) }.joined(separator: separator)
		: items.map{ String(describing: $0) }.joined(separator: separator)
	
	if prefixed {
	
		let prefix = "[\(Formatter.pretty(Date()))]\(tag) «\(function)»"
		print(prefix, "-", message, terminator:terminator)
		
	}
	else { print(message, terminator:terminator) }
	
	PrintOSLog(message: message, oslog: oslog, oslogtype: oslogtype)

}

func PrintOSLog(
	message: String,
	oslog:OSLog? = nil,
	oslogtype:OSLogType = .`default`
) {
	
	guard let oslog = oslog else { return }
	os_log("%@", dso:#dsohandle, log:oslog, type:oslogtype, message)

}

//func Print(message: String, oslog:OSLog? = nil, oslogtype:OSLogType = .`default`) {
//	
//	guard let oslog = oslog else { return }
//	os.Logger(oslog).log(level: oslogtype, "\(message)")
//
//}


///
///	A Formatter for the date on the log messages.
///
fileprivate
class Formatter
{
	private
	static
	let formatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		return dateFormatter
	}()
	
	private
	static
	let moat = Moat(formatter)
	
	static
	func pretty(_ date: Date) -> String
	{
		return moat.sync { $0.string(from: date) }
	}
}


///
/// A confiment Class to synchronize access to the Formatter
///
final
fileprivate
class Moat<Value>
{
	private var value : Value
	private let lock:Any = Data()
	
	required 
	public 
	init(_ value: Value) {
		self.value = value
	}
	
	public 
	func sync<S>(_ block : (inout Value) throws -> S) rethrows -> S {
		objc_sync_enter(lock)
		defer { objc_sync_exit(lock) }
		var copy = value
		defer { value = copy }
		
		return try block(&copy)
	}
	
}
