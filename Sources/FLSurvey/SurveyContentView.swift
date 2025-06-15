//
//  SurveyView.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI
import StoreKit

struct SurveyContentView: View {

	@Environment(\.requestReview) var requestReview
	@Environment(\.navigation) var navigation

	@EnvironmentObject var surveyManager: SurveyManager
	@EnvironmentObject var networkMonitor: NetworkMonitor

	var didComplete: (([String : SurveyAnswer]) -> Void)?
	var onDismiss: (Bool) -> Void

	init(didComplete: (([String : SurveyAnswer]) -> Void)? = nil, onDismiss: @escaping (Bool) -> Void) {
		self.didComplete = didComplete
		self.onDismiss = onDismiss
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			if surveyManager.isCompleted {
				SurveyCompletionView(onDismiss: onDismiss)
					.environmentObject(surveyManager)
					.environmentObject(networkMonitor)
					.onAppear {
						if Config.shared.askReview {
							requestReview()
						}

						didComplete?(surveyManager.answers)
					}
			} else {
				//					SurveyProgressView(progress: surveyManager.progress)

				if let question = surveyManager.currentQuestion {
					VStack(alignment: .leading, spacing: 12) {
						Text(question.title)
							.font(.title.bold())
							.multilineTextAlignment(.leading)
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .leading)

						if let subtitle = question.subtitle {
							Text(subtitle)
								.multilineTextAlignment(.leading)
								.fixedSize(horizontal: false, vertical: true)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					.padding(.bottom)

					Group {
						switch question.type {
						case .textInput:
							OpenTextQuestionView(page: question, surveyManager: surveyManager)

						case .vote:
							NumericVoteQuestionView(page: question, surveyManager: surveyManager)
						}
					}
					.transition(.asymmetric(
						insertion: .move(edge: .trailing),
						removal: .move(edge: .leading)
					))
				}

				Spacer()

				RectangularButton(title: surveyManager.currentQuestionIndex == surveyManager.survey.pages.count - 1 ? "Finish" : "Next") {
					withAnimation(.easeInOut(duration: 0.3)) {
						surveyManager.nextQuestion()
					}
				}
				.disabled(!surveyManager.canProceed)
			}
		}
		.navigationTitle(surveyManager.survey.title + " Survey")
		#if os(macOS)
		.padding()
		.frame(height: 500)
		#else
		.navigationBarTitleDisplayMode(.inline)
		.padding(.all.subtracting(.top))
		#endif
		.toolbar {
			if Config.shared.canBeDismissed {
				ToolbarItem(placement: .cancellationAction) {
					Button("Close") {
						onDismiss(false)
						navigation(.dismiss)
					}
					.foregroundStyle(Config.shared.brandColor)
				}
			}
		}
		.background(Config.shared.foregroundColor)
		.interactiveDismissDisabled()
		.navigationBarBackButtonHidden()
	}
}
