//
//  OSLog-ext.swift
//  
//
//  Created by Bil Moorhead on 6/25/20.
//

import Foundation
import os.log

extension OSLog {
	
	public static func loggerTests(_ category:String) ->OSLog {
		OSLog(subsystem: "com.lsi.logger.tests", category: category)
	}
	
}

