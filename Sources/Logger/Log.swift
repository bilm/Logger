//
//  Log.swift
//	Logger
//
//  Simple logging functions, Log, Label
//
//  Created by Bil on 12/9/15.
//  Copyright © 2017 Lightswitch Ink. All rights reserved.
//

import Foundation
import os

///
/// main Logging function
///
/// - parameter conditional: anything that returns a Bool; it will be wrapped in a block as necesary
/// - parameter message: the message(s) you want printed
/// - parameter separator: the string to put between the items
/// - parameter terminator: the string to end the output
/// - parameter tag: a tag to add to the prefix between the data and the function
/// - parameter oslog: (Optional) a OSLog to send the message to
/// - parameter oslogtype: the OSLog type of the message
/// - parameter reflecting: by default, uses `String(reflecting:)` to convert the items to Strings
/// - parameter prefixed: by default, has a prefix of _"[date]tag «function» - "_
/// - parameter function: the function being called from; defaults to the actual one
///
/// - note: the outout includes the date, and optional tag, the function and the message
///
/// ```
///		Log(true, "found the bug!")
/// ```
/// - seealso: Print(_:separator:terminator:tag:function:)
///
public
func Log(_ conditional:  @autoclosure() -> Bool, _ message: Any..., separator: String = " ", terminator: String = "\n", tag:String = "", oslog:OSLog? = nil, oslogtype:OSLogType = .`default`, reflecting: Bool = true, prefixed: Bool = true, function: String = #function) {
	
	guard conditional() else { return }
	Print(
		message,
		separator: separator,
		terminator: terminator,
		tag:tag, oslog:oslog,
		oslogtype:oslogtype,
		reflecting: reflecting,
		prefixed: prefixed,
		function:function
	)
	
}

///
/// main Logging function
///
/// - parameter conditional: anything that returns a Bool; it will be wrapped in a block as necesary
/// - parameter message: the message(s) you want printed
/// - parameter separator: the string to put between the items
/// - parameter terminator: the string to end the output
/// - parameter tag: a tag to add to the prefix between the data and the function
/// - parameter oslog: (Optional) a OSLog to send the message to
/// - parameter oslogtype: the OSLog type of the message
/// - parameter reflecting: by default, uses `String(reflecting:)` to convert the items to Strings
/// - parameter prefixed: by default, has a prefix of _"[date]tag «function» - "_
/// - parameter function: the function being called from; defaults to the actual one
///
/// - note: the outout includes the date, and optional tag, the function and the message
///
/// ```
///		Log(true, "found the bug!")
/// ```
/// - seealso: Print(_:separator:terminator:tag:function:)
///
public
func Log(_ conditional:  @autoclosure() -> Bool, message: [Any], separator: String = " ", terminator: String = "\n", tag:String = "", oslog:OSLog? = nil, oslogtype:OSLogType = .`default`, reflecting: Bool = true, prefixed: Bool = true, function: String = #function) {
	
	guard conditional() else { return }
	Print(
		message,
		separator: separator,
		terminator: terminator,
		tag:tag,
		oslog:oslog,
		oslogtype:oslogtype,
		reflecting: reflecting,
		prefixed: prefixed,
		function:function
	)
	
}

///
///  convience Logging function
///
/// - parameter message(s): the message you want printed
/// - parameter function: the function being called from; defaults to the actual one
///
/// - note: the outout includes the date, and optional tag, the function and the message
/// - note: uses `Print(...)`
///```
///Label("starting now!")
///```
///
public
func Label(_ message: Any..., function: String = #function) {
	
	Print(message, function:function)
	
}

///
/// convenience Logging function
///
/// - parameter error: an Optional error
/// - parameter message: an Optional message you want printed
/// - parameter oslog: (Optional) a OSLog to send the message to
/// - parameter oslogtype: the OSLog type of the message
/// - parameter function: the function being called from; defaults to the actual one
///
/// - note: if the error is nil, then nothing is outputted  
/// if the message is nil, then error's localized description is used  
/// - note: uses Print(...)
/// - note:the outout includes the date, the fuction and the message
///
/// ```
///	let error = ...
///	Log(error)
/// ```
///
public
func Log(_ error: Error?, message: Any? = nil, oslog:OSLog? = nil, oslogtype:OSLogType = .`default`, function: String = #function) {
	
	guard let error = error else { return }
	Print(
		[message ?? (error as NSError).localizedDescription],
		oslog:oslog,
		oslogtype:oslogtype,
		function:function
	)
	
}

