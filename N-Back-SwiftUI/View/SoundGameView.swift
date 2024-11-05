import SwiftUI

struct SoundGameView: View {
    @EnvironmentObject var theViewModel: N_Back_SwiftUIVM
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game Type: Sound")
                .font(.title)
                .padding(.bottom, 20)

            Text("Current Sound: \(theViewModel.currentLetter)")
                .font(.largeTitle)
                .padding(.bottom, 20)

            Button(action: { theViewModel.checkSoundMatch() }) {
                Text("Match")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)

            Button(action: { theViewModel.resetGame() }) {
                Text("Reset Game")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .onAppear { startSoundPlayback() }
        .onDisappear { stopSoundPlayback() }
    }

    func startSoundPlayback() {
        stopSoundPlayback()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(theViewModel.timeBetweenEvents) / 1000.0, repeats: true) { _ in
            theViewModel.nextSoundEvent()
        }
    }

    func stopSoundPlayback() {
        timer?.invalidate()
        timer = nil
    }
}
