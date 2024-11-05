//
//  ContentView.swift
//  N-Back-SwiftUI
//
//  Created by Jonas Willén on 2023-09-19.
//

import SwiftUI


// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView: View {
    @EnvironmentObject var theViewModel: N_Back_SwiftUIVM
    @State private var showGameView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Display High Score
                Text("High-Score: \(theViewModel.highScore)")
                    .font(.title2)
                    .padding(.bottom, 10)
                
                // Display N-back value
                Text("N-Back: \(theViewModel.nBack)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                // Time between events
                VStack(spacing: 5) {
                    HStack {
                        Text("Time between events (ms):")
                            .font(.subheadline)
                        TextField("1500", value: $theViewModel.timeBetweenEvents, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .font(.subheadline)
                            .background(Color.clear) // Remove background
                            .frame(width: 80)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Number of events in a round
                    HStack {
                        Text("Number of events in a round:")
                            .font(.subheadline)
                        TextField("20", value: $theViewModel.imageTotalEvents, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .font(.subheadline)
                            .background(Color.clear) // Remove background
                            .frame(width: 80)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Start Game title
                Text("Start Game")
                    .font(.title)
                    .padding(.bottom, 5)
                
                // Choose Stimulus
                Text("Välj stimuli")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                // Stimulus buttons
                HStack(spacing: 40) {
                    Button(action: {
                        theViewModel.selectStimulus("image")
                        showGameView = true
                    }) {
                        ImageIconView()
                    }
                    Button(action: {
                        theViewModel.selectStimulus("sound")
                        showGameView = true
                    }) {
                        SoundIconView()
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showGameView) {
                GameView()
                    .environmentObject(theViewModel)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(["iPhone 15", "iPhone 15"], id: \.self) { deviceName in
                ContentView()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
                    .environmentObject(N_Back_SwiftUIVM())
            }
            
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
                .previewDisplayName("iPhone 15")
                .environmentObject(N_Back_SwiftUIVM())
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}





