//
//  MainView.swift
//  HapSnap
//
//  Created by Giovanni Palusa on 2023-11-28.
//

import SwiftUI

struct MainView: View {
	var body: some View {
		TabView {
			ContentView()
				.tabItem {
					Label("Haptics", systemImage: "waveform.path.ecg")
				}

			SettingsView()
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
		}
	}
}

#Preview {
	MainView()
}
