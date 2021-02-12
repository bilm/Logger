// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Logger",
	platforms: [ .iOS(.v13), .macOS(.v10_15) ],
	products: [
		.library(name: "Logger", targets: ["Logger"]),
	],
	targets: [
		.target( name: "Logger", dependencies: []),
		.testTarget( name: "LoggerTests", dependencies: ["Logger"]),
	]
)
