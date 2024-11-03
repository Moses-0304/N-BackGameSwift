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
    @EnvironmentObject var theViewModel : N_Back_SwiftUIVM
    @State private var orientation = UIDeviceOrientation.portrait
    
    var body: some View {
        VStack() {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("High-Score \(theViewModel.highScore)")
            Spacer()
            Button {
                theViewModel.newHighScoreValue()
            } label: {
                Text("Generate eventValue")
                    .font(.title)
            }
            .padding()
            Spacer()
            ActionIconView()
            
        }
        .padding()
    }
}





struct ContentView_Previews:     {
    static var previews: some View {
        Group{
            ForEach(["iPhone SE (3rd generation)", "iPhone 14 Pro Max"], id: \.self) { deviceName in
                           ContentView()
                                .previewDevice(PreviewDevice(rawValue: deviceName))
                                .previewDisplayName(deviceName)
                                .environmentObject(N_Back_SwiftUIVM())
                      }
            
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
                .previewDisplayName("iPhone 14 Pro Max Landscape")
                .environmentObject(N_Back_SwiftUIVM())
                .previewInterfaceOrientation(.landscapeRight)
        }
        
    }
}





