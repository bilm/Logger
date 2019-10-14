// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Logger",
	platforms: [ .iOS(.v13), .macOS(.v10_14) ],
	products: [
		.library(name: "Logger", targets: ["Logger"]),
	],
	dependencies: [
	],
	targets: [
		.target( name: "Logger", dependencies: []),
		.testTarget( name: "LoggerTests", dependencies: ["Logger"]),
	]
)
