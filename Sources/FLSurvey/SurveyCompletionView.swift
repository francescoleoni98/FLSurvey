//
//  SurveyCompletionView.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI

struct SurveyCompletionView: View {

	@Environment(\.navigation) var navigation

	@EnvironmentObject var networkMonitor: NetworkMonitor
	@EnvironmentObject var surveyManager: SurveyManager
	
	var onDismiss: (Bool) -> Void

	var body: some View {
		VStack {
			Spacer()

			VStack(spacing: 12) {
				if let icon = Config.shared.appIcon {
					Image(icon)
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.clipShape(.rect(cornerRadius: 12))
						.overlay {
							RoundedRectangle(cornerRadius: 12)
								.stroke(.gray.opacity(0.5), lineWidth: 1)
						}
				}

				Text("Survey completed!")
					.font(.title)
					.fontWeight(.semibold)

				Text("Thank you for your help.")
					.foregroundColor(.secondary)
			}
			.multilineTextAlignment(.center)

			Spacer()
			Spacer()

			RectangularButton(title: Config.shared.hasReward ? "Get reward" : "Close") {
				if networkMonitor.isConnected {
					onDismiss(Config.shared.hasReward)
					navigation(.dismiss)
				}
			}

			if !networkMonitor.isConnected {
				Text("Internet connection required")
					.font(.footnote)
					.foregroundStyle(.secondary)
			}

//			VStack(alignment: .leading, spacing: 8) {
//				Text("Summary:")
//					.font(.headline)
//
//				Text("Questions answered: \(surveyManager.answers.count)/\(surveyManager.survey.pages.count)")
//					.font(.body)
//					.foregroundColor(.secondary)
//
//				Text("\(surveyManager.answers)")
//			}
//			.frame(maxWidth: .infinity, alignment: .leading)
//			.padding()
//			.background(Color(.systemGray6))
//			.cornerRadius(8)
		}
	}
}
