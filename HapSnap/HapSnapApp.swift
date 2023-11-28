//
//  HapSnapApp.swift
//  HapSnap
//
//  Created by Giovanni Palusa on 2023-11-28.
//

import SwiftUI

class AppSettings: ObservableObject {
	@Published var hapticEvents = [HapticEvent]()
}

@main
struct HapSnapApp: App {
	@StateObject var settings = AppSettings()

	var body: some Scene {
		WindowGroup {
			MainView()
				.environmentObject(settings)
		}
	}
}
