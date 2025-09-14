// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "FLSurvey",
	platforms: [
		.iOS(.v16),
		.macOS(.v13),
		.visionOS(.v1),
		.watchOS(.v9),
		.tvOS(.v16)
	],
	products: [
		.library(
			name: "FLSurvey",
			targets: ["FLSurvey"]),
	],
	dependencies: [
		.package(url: "https://github.com/francescoleoni98/FLNavigation.git", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/francescoleoni98/FLShared.git", .upToNextMajor(from: "1.0.0"))
	],
	targets: [
		.target(
			name: "FLSurvey",
			dependencies: [
				.product(name: "FLNavigation", package: "FLNavigation"),
				.product(name: "FLShared", package: "FLShared")
			]
		),
		.testTarget(
			name: "FLSurveyTests",
			dependencies: ["FLSurvey"]
		)
	]
)
