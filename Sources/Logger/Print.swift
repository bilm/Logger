//
//  Print.swift
//  Miscellany
//
//  Created by Bil on 4/13/17.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os

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
func Print(_ items: [Any], separator: String = " ", terminator: String = "\n", tag: String = "", oslog: OSLog? = nil, oslogtype: OSLogType = .`default`, reflecting: Bool = true, prefixed: Bool = true, function: String = #function) {
	
	let message = reflecting
		? items.map{ String(reflecting: $0) }.joined(separator: separator)
		: items.map{ String(describing: $0) }.joined(separator: separator)
	
	if prefixed {
	
		let prefix = "[\(Date().formatted(.iso8601))]\(tag) «\(function)»"
		print(prefix, "-", message, terminator:terminator)
		
	}
	else { print(message, terminator:terminator) }
	
	PrintOSLog(message: message, oslog: oslog, oslogtype: oslogtype)

}

@available(OSX 11.0, iOS 14.0, *)
func PrintOSLog(message: String, oslog: OSLog? = nil, oslogtype: OSLogType = .`default`) {
	
	guard let oslog = oslog else { return }
	os.Logger(oslog).log(level: oslogtype, "\(message)")

}
