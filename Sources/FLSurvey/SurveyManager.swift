//
//  SurveyManager.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 08/06/25.
//

import SwiftUI

public enum QuestionType {

		case textInput
		case vote
}

public struct SurveyPage: Identifiable, Equatable {
	public static func == (lhs: SurveyPage, rhs: SurveyPage) -> Bool {
		lhs.id == rhs.id
	}


	public let id: String = UUID().uuidString
	let title: String
	let subtitle: String?
	let type: QuestionType
	let minValue: String?
	let maxValue: String?
	let values: [(String, Bool)]?
	let questions: [SurveyQuestion]

	public init(title: String, subtitle: String? = nil, type: QuestionType, minValue: String? = nil, maxValue: String? = nil, values: [(String, Bool)]? = nil, questions: [SurveyQuestion]) {
		self.title = title
		self.subtitle = subtitle
		self.type = type
		self.minValue = minValue
		self.maxValue = maxValue
		self.values = values
		self.questions = questions
	}
}

public struct SurveyQuestion: Identifiable, Hashable {

	public let id: String
	let title: String
	let options: [String]?
	let isRequired: Bool
	let minValue: Int?
	let maxValue: Int?

	public init(id: String, title: String, options: [String]? = nil, isRequired: Bool = true, minValue: Int? = nil, maxValue: Int? = nil) {
		self.id = id
		self.title = title
		self.options = options
		self.isRequired = isRequired
		self.minValue = minValue
		self.maxValue = maxValue
	}
}

public struct SurveyAnswer {

	public let questionId: String
	public let value: Any

	init(questionId: String, value: Any) {
		self.questionId = questionId
		self.value = value
	}
}

public struct Survey {

	let id = UUID()
	let title: String
	let description: String?
	let pages: [SurveyPage]

	public init(title: String, description: String? = nil, pages: [SurveyPage]) {
		self.title = title
		self.description = description
		self.pages = pages
	}
}

class SurveyManager: ObservableObject {

	@Published var currentQuestionIndex = 0
	@Published var answers: [String : SurveyAnswer] = [:]
	@Published var isCompleted = false
	@Published var currentQuestion: SurveyPage?
	
	let survey: Survey

	init(survey: Survey) {
		self.survey = survey
		self.currentQuestion = getCurrentQuestion()
	}

	var canProceed: Bool {
		guard let currentQuestion else { return false }

		return currentQuestion.questions.allSatisfy {
			guard let answer = answers[$0.id] else { return false }

			if let string = answer.value as? String {
				return !string.isEmpty
			} else {
				return true
			}
		}
	}

	var progress: Double {
		guard !survey.pages.isEmpty else { return 0 }
		return Double(currentQuestionIndex) / Double(survey.pages.count)
	}

	func saveAnswer(questionId: String, value: Any) {
		answers[questionId] = SurveyAnswer(questionId: questionId, value: value)
	}

	func nextQuestion() {
		if currentQuestionIndex < survey.pages.count - 1 {
			currentQuestionIndex += 1
		} else {
			isCompleted = true
		}

		currentQuestion = getCurrentQuestion()
	}

	func previousQuestion() {
		if currentQuestionIndex > 0 {
			currentQuestionIndex -= 1
			currentQuestion = getCurrentQuestion()
		}
	}

	private func getCurrentQuestion() -> SurveyPage? {
		guard currentQuestionIndex < survey.pages.count else { return nil }
		return survey.pages[currentQuestionIndex]
	}
}
