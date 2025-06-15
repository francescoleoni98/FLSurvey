//
//  NumericVoteQuestionView.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI

public struct NumericQuestion: Identifiable, Hashable {

	public var id: String
	public var question: String
	public var minValue: Int
	public var maxValue: Int

	public init(id: String = UUID().uuidString, question: String, minValue: Int, maxValue: Int) {
		self.id = id
		self.question = question
		self.minValue = minValue
		self.maxValue = maxValue
	}
}

struct NumericVoteQuestionView: View {

	var page: SurveyPage

	@ObservedObject var surveyManager: SurveyManager

	@State private var votes: [String : Int] = [:]

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
//			HStack {
//				if let minValue = page.minValue {
//					Text(minValue)
//				}
//
//				Spacer()
//
//				if let maxValue = page.maxValue {
//					Text(maxValue)
//				}
//			}
//			.font(.system(.subheadline, weight: .heavy))
//			.textCase(.uppercase)
//			.foregroundStyle(.secondary)

			ScrollView {
				VStack(alignment: .leading, spacing: 30) {
					ForEach(page.questions) { question in
						VStack(alignment: .leading) {
							Text(question.title)
								.bold()

							HStack(alignment: .top) {
								if let values = page.values {
									ForEach(Array(values.enumerated()), id: \.offset) { number, value in
										let isSelected = votes[question.id] == number
										
										VStack {
											Button {
												surveyManager.saveAnswer(questionId: question.id, value: number)
												votes[question.id] = number
											} label: {
												Text(String(number))
													.foregroundStyle(isSelected ? Config.shared.foregroundColor : Config.shared.brandColor)
													.frame(width: 40, height: 40)
													.background(Config.shared.brandColor.opacity(isSelected ? 1 : 0.05), in: .rect(cornerRadius: 8))
													.overlay {
														RoundedRectangle(cornerRadius: 8)
															.stroke(Config.shared.brandColor, lineWidth: 1)
													}
											}
											.buttonStyle(.plain)
											
											if value.1 {
												Text(value.0)
													.font(.footnote)
													.multilineTextAlignment(.center)
											}
										}
										.frame(maxWidth: .infinity)
									}
								} else {
									ForEach((question.minValue ?? 1)...(question.maxValue ?? 5), id: \.self) { number in
										let isSelected = votes[question.id] == number
										
										VStack {
											Button {
												surveyManager.saveAnswer(questionId: question.id, value: number)
												votes[question.id] = number
											} label: {
												Text(String(number))
													.foregroundStyle(isSelected ? Config.shared.foregroundColor : Config.shared.brandColor)
													.frame(width: 44, height: 44)
													.background(Config.shared.brandColor.opacity(isSelected ? 1 : 0.05), in: .rect(cornerRadius: 8))
													.overlay {
														RoundedRectangle(cornerRadius: 8)
															.stroke(Config.shared.brandColor, lineWidth: 1)
													}
											}
											.buttonStyle(.plain)
											
											if number == (question.minValue ?? 1), let minValue = page.minValue {
												Text(minValue)
													.font(.footnote)
											} else if number == (question.maxValue ?? 5), let maxValue = page.maxValue {
												Text(maxValue)
													.font(.footnote)
											}
										}
										.frame(maxWidth: .infinity)
									}
								}
							}
						}
					}
				}
			}
			.scrollIndicators(.hidden)
		}
	}
}
