//
//  HapticEventView.swift
//  HapSnap
//
//  Created by Giovanni Palusa on 2023-11-28.
//

import SwiftUI
import CoreHaptics

struct HapticEventView: View {
	@Binding var hapticEvents: [HapticEvent]
	@State private var newEvent = HapticEvent(time: 0.0, eventType: .hapticTransient, eventDuration: 1.0, intensity: 0.5, sharpness: 0.5, attackTime: 0.1, decayTime: 0.1, delay: 0.0, sustained: false, eventParameters: [])
	let engine: CHHapticEngine?

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Haptic Event")) {
					Picker("Event Type", selection: $newEvent.eventType) {
						ForEach(CHHapticEvent.EventType.allCases, id: \.self) { eventType in
							Text(eventType.rawValue)
						}
					}

					Toggle("Sustained", isOn: $newEvent.sustained)

					Slider(value: $newEvent.time, in: 0...10)
					Text("Time: \(newEvent.time, specifier: "%.2f")")

					Slider(value: $newEvent.intensity, in: 0...1)
					Text("Intensity: \(newEvent.intensity, specifier: "%.2f")")

					Slider(value: $newEvent.sharpness, in: 0...1)
					Text("Sharpness: \(newEvent.sharpness, specifier: "%.2f")")

					Slider(value: $newEvent.attackTime, in: 0...1)
					Text("Attack Time: \(newEvent.attackTime, specifier: "%.2f")")

					Toggle("Has Decay Time", isOn: Binding(
						get: { newEvent.decayTime > 0 },
						set: { newValue in
							if !newValue {
								newEvent.decayTime = 0
							} else {
								newEvent.decayTime = 0.5 // Set a default value or use your own logic
							}
						}
					))

					if newEvent.decayTime != 0 {
						Slider(value: $newEvent.decayTime, in: 0...1)
						Text("Decay Time: \(newEvent.decayTime, specifier: "%.2f")")
					}

					Slider(value: $newEvent.delay, in: 0...1)
					Text("Delay: \(newEvent.delay, specifier: "%.2f")")
				}

				Section {
					Button("Test Haptic") {
						playHapticPreview(event: newEvent, 
										  engine: engine)
					}.buttonStyle(.borderedProminent)

					Button("Play all haptics") {
						playHapticPreview(events: hapticEvents, 
										  engine: engine)
					}.buttonStyle(.borderedProminent)

					Button("Save") {
						hapticEvents.append(newEvent)
						print("Haptic Event saved!")
					}.buttonStyle(.borderedProminent)
				}
			}
			.listStyle(GroupedListStyle()) // Apply a list style
			.navigationTitle("Haptic Event Editor")
		}
	}
}

#Preview {
	@State var events = [HapticEvent]()
	let engine = try? CHHapticEngine()
	return HapticEventView(hapticEvents: $events, engine: engine!)
}
