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

///
/// main Logging function
///
/// - parameter conditional: anything that returns a Bool; it will be wrapped in a block as necesary
/// - parameter message: the message(s) you want printed
/// - parameter tag: a tag to add to the prefix between the data and the function
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
func Log(
	_ conditional:  @autoclosure() -> Bool,
	_ message: Any...,
	tag:String = "",
	function: String = #function
	)
{
	guard conditional() else { return }
	Print(message, tag:tag, function:function)
}

///
/// main Logging function
///
/// - parameter conditional: anything that returns a Bool; it will be wrapped in a block as necesary
/// - parameter message: the message(s) you want printed
/// - parameter tag: a tag to add to the prefix between the data and the function
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
func Log(
	_ conditional:  @autoclosure() -> Bool,
	message: [Any],
	tag:String = "",
	function: String = #function
	)
{
	guard conditional() else { return }
	Print(message, tag:tag, function:function)
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
func Label(
	_ message: Any...,
	function: String = #function
	)
{
	Print(message, function:function)
}

///
/// convenience Logging function
///
/// - parameter error: an Optional error
/// - parameter message: an Optional message you want printed
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
func Log(
	_ error: Error?,
	message: Any? = nil,
	function: String = #function)
{
	guard let error = error else { return }
	Print([message ?? (error as NSError).localizedDescription], function:function)
}

