//
//  ContentView.swift
//  HapSnap
//
//  Created by Giovanni Palusa on 2023-11-28.
//

import CoreHaptics
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
	@State private var hapticEngine: CHHapticEngine?
	@EnvironmentObject var settings: AppSettings

	var body: some View {
		NavigationView {
			VStack {
				HapticEventView(hapticEvents: $settings.hapticEvents, engine: hapticEngine)

				VStack {
					ForEach(settings.hapticEvents.indices, id: \.self) { index in
						Text("\(index)")
					}
					.onDelete(perform: deleteHapticEvent)
				}
			}
			.onAppear(perform: prepareHaptics)
		}
	}

	func deleteHapticEvent(at offsets: IndexSet) {
		settings.hapticEvents.remove(atOffsets: offsets)
	}

	func prepareHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		do {
			hapticEngine = try CHHapticEngine()
			try hapticEngine?.start()
		} catch {
			print("There was an error creating the haptic engine: \(error.localizedDescription)")
		}
	}
}

#Preview {
	ContentView()
}

func playHapticPreview(event: HapticEvent, engine: CHHapticEngine?) {
	guard let engine else { return }
	// Determine the CHHapticEvent.EventType based on the eventType string
	let eventType: CHHapticEvent.EventType = (event.eventType == .hapticTransient) ? .hapticTransient : .hapticContinuous

	// Create the event parameters
	var parameters: [CHHapticEventParameter] = []
	parameters.append(CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(event.intensity)))
	parameters.append(CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(event.sharpness)))
	parameters.append(CHHapticEventParameter(parameterID: .attackTime, value: Float(event.attackTime)))
	parameters.append(CHHapticEventParameter(parameterID: .decayTime, value: Float(event.decayTime)))

	// Create the haptic event
	let hapticEvent = CHHapticEvent(eventType: eventType, parameters: parameters, relativeTime: event.delay, duration: TimeInterval(event.eventDuration ?? 1.0))

	do {
		// Create a haptic pattern from the event and play it
		let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
		let player = try engine.makePlayer(with: pattern)
		try player.start(atTime: 0)
	} catch {
		print("Failed to play pattern: \(error.localizedDescription)")
	}
}

func playHapticPreview(events: [HapticEvent], engine: CHHapticEngine?) {
	guard let engine else { return }
	var cumulativeTime = 0.0
	var hapticEvents: [CHHapticEvent] = []

	for event in events {
		let eventType: CHHapticEvent.EventType = (event.eventType == .hapticTransient) ? .hapticTransient : .hapticContinuous

		var parameters: [CHHapticEventParameter] = []
		parameters.append(CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(event.intensity)))
		parameters.append(CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(event.sharpness)))
		parameters.append(CHHapticEventParameter(parameterID: .attackTime, value: Float(event.attackTime)))

		parameters.append(CHHapticEventParameter(parameterID: .decayTime, value: Float(event.decayTime)))

		// Cumulative time is used as the relative start time for the event
		cumulativeTime += event.delay
		let hapticEvent = CHHapticEvent(eventType: eventType, parameters: parameters, relativeTime: cumulativeTime, duration: TimeInterval(event.eventDuration ?? 1.0))
		hapticEvents.append(hapticEvent)

		// Update cumulative time with the duration of the event
		cumulativeTime += (event.eventDuration ?? 1.0)
	}

	do {
		let pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
		let player = try engine.makePlayer(with: pattern)
		try player.start(atTime: 0)
	} catch {
		print("Failed to play pattern: \(error.localizedDescription)")
	}
}
