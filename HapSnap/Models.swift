import Foundation
import CoreHaptics

struct HapticMetadata {
	var project: String
	var created: String
	var description: String
}

struct HapticEvent {
	var time: Double // The start time of the event
	var eventType: CHHapticEvent.EventType // e.g., "HapticTransient", "HapticContinuous"
	var eventDuration: Double? // Duration of the event, applicable for continuous events
	var intensity: Double // Intensity of the haptic event
	var sharpness: Double // Sharpness of the haptic event
	var attackTime: Double // Attack time of the haptic event
	var decayTime: Double // Optional, decay time for the event
	var delay: Double // Delay before this event starts
	var sustained: Bool // Optional, whether the event is sustained
	var eventParameters: [EventParameter] // Additional parameters if needed
}

struct EventParameter {
	var parameterID: String
	var parameterValue: Double
}

	// If you include audio events
struct AudioEvent {
	var time: Double
	var eventWaveformPath: String
	var eventParameters: [EventParameter]
}

class HapticEventViewModel: ObservableObject {
	@Published var hapticEvent: HapticEvent

	init(hapticEvent: HapticEvent) {
		self.hapticEvent = hapticEvent
	}
}


import CoreHaptics

extension CHHapticEvent.EventType {
	static var allCases: [CHHapticEvent.EventType] {
		return [
			.hapticTransient,
			.hapticContinuous,
			.audioContinuous,
			.audioCustom
		]
	}
}
