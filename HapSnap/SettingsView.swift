//
//  SettingsView.swift
//  HapSnap
//
//  Created by Giovanni Palusa on 2023-11-28.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var settings: AppSettings
	@State var metaData: HapticMetadata = .init(project: "", created: "", description: "")
	@State var jsonString: String = ""

	var body: some View {
		Form {
			Section(header: Text("Metadata")) {
				TextField("Project", text: $metaData.project)
				TextField("Created", text: $metaData.created)
				TextField("Description", text: $metaData.description)
			}
			Button("Create JSON") {
				jsonString = generateAhapJson(metadata: metaData, hapticEvents: settings.hapticEvents)
			}.buttonStyle(.borderedProminent)
			Text(jsonString)
		}
		.navigationTitle("Settings")
	}

	func generateAhapJson(metadata: HapticMetadata, hapticEvents: [HapticEvent], audioEvents: [AudioEvent] = []) -> String {
		var patternArray: [[String: Any]] = []

			// Loop through haptic events and construct their dictionary representations
		for event in hapticEvents {
			var eventDict: [String: Any] = [
				"Time": event.time,
				"EventType": event.eventType
			]

			if let duration = event.eventDuration {
				eventDict["EventDuration"] = duration
			}

			let eventParams: [[String: Any]] = event.eventParameters.map { param in
				["ParameterID": param.parameterID, "ParameterValue": param.parameterValue]
			}

			eventDict["EventParameters"] = eventParams
			patternArray.append(["Event": eventDict])
		}

			// Optionally, loop through audio events and add them to the pattern array
		for audioEvent in audioEvents {
			let eventParams: [[String: Any]] = audioEvent.eventParameters.map { param in
				["ParameterID": param.parameterID, "ParameterValue": param.parameterValue]
			}

			let eventDict: [String: Any] = [
				"Time": audioEvent.time,
				"EventType": "AudioCustom",
				"EventWaveformPath": audioEvent.eventWaveformPath,
				"EventParameters": eventParams
			]

			patternArray.append(["Event": eventDict])
		}

			// Combine everything into the final dictionary
		let ahapDict: [String: Any] = [
			"Version": 1,
			"Metadata": [
				"Project": metadata.project,
				"Created": metadata.created,
				"Description": metadata.description
			],
			"Pattern": patternArray
		]

			// Convert the final dictionary into a JSON string
		if let jsonData = try? JSONSerialization.data(withJSONObject: ahapDict, options: .prettyPrinted),
		   let jsonString = String(data: jsonData, encoding: .utf8)
		{
			return jsonString
		} else {
			return "Error in JSON Generation"
		}
	}
}

#Preview {
    SettingsView()
}
