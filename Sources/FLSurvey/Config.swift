//
//  Config.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI

public struct Config {

	@MainActor internal static var shared: Config = Config(appName: "Brain Dump", brandColor: .black, foregroundColor: .white, actionTitle: "Test")

	public var appName: String?
	public var appIcon: String?
	public var brandColor: Color
	public var foregroundColor: Color
	public var actionTitle: LocalizedStringKey
	public var askReview: Bool
	public var hasReward: Bool
	public var canBeDismissed: Bool

	public init(appName: String? = nil, appIcon: String? = nil, brandColor: Color = .blue, foregroundColor: Color = .white, actionTitle: LocalizedStringKey = "Continue", askReview: Bool = true, hasReward: Bool = true, canBeDismissed: Bool = true) {
		self.appName = appName
		self.appIcon = appIcon
		self.brandColor = brandColor
		self.foregroundColor = foregroundColor
		self.actionTitle = actionTitle
		self.askReview = askReview
		self.hasReward = hasReward
		self.canBeDismissed = canBeDismissed
	}
}
