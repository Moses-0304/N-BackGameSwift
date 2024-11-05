import SwiftUI

struct ImageGameView: View {
    @EnvironmentObject var theViewModel: N_Back_SwiftUIVM
    let gridSize = 3
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Game type: Image")
                .font(.title)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(80), spacing: 15), count: gridSize), spacing: 15) {
                ForEach(0..<(gridSize * gridSize), id: \.self) { index in
                    Rectangle()
                        .foregroundColor(theViewModel.activeIndex == index ? .blue : .clear)
                        .frame(width: 80, height: 80)
                        .border(Color.black, width: 1)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 30)
            
            Button(action: { theViewModel.checkImageMatch() }) {
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
        .onAppear { startHighlighting() }
        .onDisappear { stopHighlighting() }
    }

    func startHighlighting() {
        stopHighlighting()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            theViewModel.nextImageEvent()
        }
    }

    func stopHighlighting() {
        timer?.invalidate()
        timer = nil
    }
}
