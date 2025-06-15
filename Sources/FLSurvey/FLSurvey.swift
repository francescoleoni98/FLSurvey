import Foundation

public class FLSurvey {

	@MainActor
	public static func configure(_ config: Config) {
		Config.shared = config
	}
}
