//
//  SurveyView.swift
//  BrainDump
//
//  Created by Francesco Leoni on 10/06/25.
//

import SwiftUI
import FLShared
import FLNavigation

public struct SurveyView: View {

	@Environment(\.navigation) var navigation

	@StateObject private var networkMonitor = NetworkMonitor()
	@StateObject private var surveyManager: SurveyManager

	var didComplete: (([String : SurveyAnswer]) -> Void)?
	var onDismiss: (Bool) -> Void

	public init(survey: Survey, didComplete: (([String : SurveyAnswer]) -> Void)? = nil, onDismiss: @escaping (Bool) -> Void) {
		self._surveyManager = StateObject(wrappedValue: SurveyManager(survey: survey))
		self.didComplete = didComplete
		self.onDismiss = onDismiss
	}

	public var body: some View {
		VStack(spacing: 32) {
			ScrollView {
				VStack(spacing: 32) {
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

						//				HStack(spacing: 8) {
						//					Image(systemName: "crown.fill")
						//						.font(.system(size: 20))
						//						.foregroundColor(.orange)
						//
						//					Text("PREMIUM")
						//						.font(.caption)
						//						.fontWeight(.bold)
						//						.foregroundColor(.orange)
						//						.tracking(1)
						//				}
						//				.padding(.horizontal, 16)
						//				.padding(.vertical, 6)
						//				.background(Color.orange.opacity(0.1))
						//				.cornerRadius(20)

						if Config.shared.hasReward {
							Text("Get One Month of Premium for Free")
								.font(.title.bold())
								.padding(.bottom)
						}

						VStack(spacing: 8) {
							Text("Help us improve \(Config.shared.appName ?? "")")
								.font(.title3.bold())

							Text("Share your thoughts to help us create a better experience.")
								.foregroundColor(.secondary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
					.multilineTextAlignment(.center)

					if Config.shared.hasReward {
						VStack(alignment: .leading, spacing: 16) {
							Text("What You'll Get:")
								.font(.title3)
								.fontWeight(.semibold)
								.foregroundColor(.primary)

							VStack(spacing: 14) {
								FeatureRow(icon: .named("askyournotes"), text: "Ask & trasform your notes", accent: Color("black"))
								FeatureRow(icon: .system("bell"), text: "Remind my notes", accent: Color("black"))
								FeatureRow(icon: .system("tag"), text: "Unlimited tags", accent: Color("black"))
								FeatureRow(icon: .system("square.and.arrow.up"), text: "Export note markdown", accent: Color("black"))
							}
						}
						.padding(.horizontal, 24)
						.padding(.vertical, 20)
						.overlay(content: {
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color("black").opacity(0.5), lineWidth: 1)
						})
						.padding(1)
					}
				}
				.padding(.top)
			}
			.scrollIndicators(.hidden)

			VStack(spacing: 12) {
				NavigationLink {
					SurveyContentView(didComplete: didComplete, onDismiss: onDismiss)
					.environmentObject(networkMonitor)
					.environmentObject(surveyManager)
				} label: {
					HStack(spacing: 8) {
						Text("Start Survey")
							.font(.headline)
							.fontWeight(.semibold)

						Image(systemName: "arrow.right")
							.font(.system(size: 16, weight: .semibold))
					}
					.foregroundColor(Color("white"))
					.frame(maxWidth: .infinity)
					.padding(.vertical, 18)
					.background(Color("black"))
					.cornerRadius(14)
					.shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
				}
				.disabled(!networkMonitor.isConnected)
				.buttonStyle(.plain)

				HStack {
					if networkMonitor.isConnected {
						Image(systemName: "clock")
						Text("Only 1-2 minutes")
					} else {
						Image(systemName: "bolt.horizontal.circle")
						Text("Internet connection required")
					}
				}
				.font(.caption)
				.foregroundColor(.secondary)
			}
		}
		.padding(.bottom)
		.padding(.horizontal, 24)
#if !os(macOS)
		.navigationBarTitleDisplayMode(.inline)
#else
		.frame(height: 500)
#endif
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Close") {
					navigation(.dismiss)
				}
			}
		}
	}
}

struct FeatureRow: View {

	let icon: ImageType
	let text: String
	let accent: Color

	var body: some View {
		HStack(spacing: 14) {
			if icon.isSystem {
				icon.image
					.foregroundColor(accent)
					.font(.system(size: 18, weight: .medium))
					.frame(width: 24)
			} else {
				icon.image
					.resizable()
					.scaledToFit()
					.foregroundColor(accent)
					.frame(width: 24, height: 24)
			}

			Text(text)
				.font(.body)
				.fontWeight(.medium)
				.foregroundColor(.primary)

			Spacer()
		}
	}
}
