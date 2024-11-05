import SwiftUI

struct GameView: View {
    @EnvironmentObject var theViewModel: N_Back_SwiftUIVM
    
    var body: some View {
        VStack {
            // Display current score based on selected stimulus
            Text("Score: \(theViewModel.displayedScore)")
                .font(.title)
            
            // Display correct responses count based on selected stimulus
            Text("Correct Responses: \(theViewModel.displayedCorrectResponses)")
                .font(.title2)
            
            // Display the current event count and total events based on selected stimulus
            if theViewModel.selectedStimulus == "image" {
                Text("Event: \(theViewModel.imageCurrentEvent)/\(theViewModel.imageTotalEvents)")
                    .font(.title2)
                    .padding(.bottom, 20)
            } else if theViewModel.selectedStimulus == "sound" {
                Text("Event: \(theViewModel.soundCurrentEvent)/\(theViewModel.soundTotalEvents)")
                    .font(.title2)
                    .padding(.bottom, 20)
            }
            
            // Display the correct game view based on the stimulus type
            if theViewModel.selectedStimulus == "image" {
                ImageGameView()
            } else if theViewModel.selectedStimulus == "sound" {
                SoundGameView()
            }
            
            Spacer()
        }
        .navigationTitle("N-Back Game")
        .padding()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(N_Back_SwiftUIVM())
    }
}
