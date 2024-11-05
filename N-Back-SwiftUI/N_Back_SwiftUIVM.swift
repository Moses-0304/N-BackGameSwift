import AVFAudio
import SwiftUI

class N_Back_SwiftUIVM: ObservableObject {
    let synthesizer = AVSpeechSynthesizer()
    private var theModel: N_BackSwiftUIModel
    @Published var highScore: Int
    @Published var selectedStimulus: String?
    @Published var gameOver: Bool = false
    @Published var timeBetweenEvents: Int = 1500
    @Published var nBack: Int
    
    // Image Game State
    @Published var imageCurrentEvent: Int = 0
    @Published var imageTotalEvents: Int
    @Published var imageScore: Int = 0
    @Published var imageCorrectResponses: Int = 0
    @Published var activeIndex: Int = -1
    private var imageNBackString: [Int] = []
    
    // Sound Game State
    @Published var soundCurrentEvent: Int = 0
    @Published var soundTotalEvents: Int
    @Published var soundScore: Int = 0
    @Published var soundCorrectResponses: Int = 0
    @Published var currentLetter: String = ""
    private var soundNBackString: [Int] = []
    private var lastSoundMatched = false
    
    var displayedEvent: Int {
        return selectedStimulus == "image" ? imageCurrentEvent : soundCurrentEvent
    }
    
    var displayedScore: Int {
        return selectedStimulus == "image" ? imageScore : soundScore
    }
    
    var displayedCorrectResponses: Int {
        return selectedStimulus == "image" ? imageCorrectResponses : soundCorrectResponses
    }
    
    init(nBack: Int = 1, totalEvents: Int = 20) {
        self.nBack = nBack
        self.imageTotalEvents = totalEvents
        self.soundTotalEvents = totalEvents
        self.theModel = N_BackSwiftUIModel(count: 0)
        self.highScore = theModel.getHighScore()
        
        generateImageNBackString()
        generateSoundNBackString()
    }
    
    // MARK: - N-back String Generation
    private func generateImageNBackString() {
        imageNBackString = []
        let nBackObj = create(Int32(imageTotalEvents), 8, 20, Int32(nBack))
        for i in 0..<imageTotalEvents {
            imageNBackString.append(Int(getIndexOf(nBackObj, Int32(i))))
        }
    }
    
    private func generateSoundNBackString() {
        soundNBackString = []
        let nBackObj = create(Int32(soundTotalEvents), 8, 20, Int32(nBack))
        for i in 0..<soundTotalEvents {
            soundNBackString.append(Int(getIndexOf(nBackObj, Int32(i))))
        }
    }
    
    // MARK: - Game Controls
    func selectStimulus(_ stimulus: String) {
        selectedStimulus = stimulus
    }
    
    func resetGame() {
        gameOver = false
        lastSoundMatched = false
        if selectedStimulus == "image" {
            resetImageGame()
        } else if selectedStimulus == "sound" {
            resetSoundGame()
        }
    }
    
    private func resetImageGame() {
        imageCurrentEvent = 0
        imageScore = 0
        imageCorrectResponses = 0
        activeIndex = -1
        generateImageNBackString()
    }
    
    private func resetSoundGame() {
        soundCurrentEvent = 0
        soundScore = 0
        soundCorrectResponses = 0
        currentLetter = ""
        lastSoundMatched = false
        generateSoundNBackString()
    }
    
    private func incrementCorrectResponses() {
        if selectedStimulus == "image" {
            imageCorrectResponses += 1
            imageScore += 10
        } else if selectedStimulus == "sound" && !lastSoundMatched {
            soundCorrectResponses += 1
            soundScore += 10
            lastSoundMatched = true
        }
        updateHighScoreIfNeeded()
    }
    
    private func updateHighScoreIfNeeded() {
        let currentScore = max(imageScore, soundScore)
        if currentScore > highScore {
            highScore = currentScore
            newHighScoreValue()
        }
    }
    
    func newHighScoreValue() {
        theModel.addScore()
        highScore = theModel.getHighScore()
    }
    
    // MARK: - Image Stimulus Handling
    func nextImageEvent() {
        guard imageCurrentEvent < imageTotalEvents else {
            gameOver = true
            return
        }
        
        imageCurrentEvent += 1
        let nextIndex = imageNBackString[imageCurrentEvent - 1]
        
        if activeIndex == nextIndex {
            activeIndex = -1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.activeIndex = nextIndex
            }
        } else {
            activeIndex = nextIndex
        }
    }
    
    func checkImageMatch() {
        guard imageCurrentEvent >= nBack else { return }
        
        let currentIndex = imageCurrentEvent - 1
        let matchIndex = currentIndex - nBack
        
        // Ensure matchIndex is within bounds of imageNBackString
        guard matchIndex >= 0 && matchIndex < imageNBackString.count else { return }
        
        if imageNBackString[currentIndex] == imageNBackString[matchIndex] {
            incrementCorrectResponses()
        }
    }
    
    // MARK: - Sound Stimulus Handling
    func nextSoundEvent() {
        guard soundCurrentEvent < soundTotalEvents else {
            gameOver = true
            return
        }

        soundCurrentEvent += 1
        currentLetter = theModel.getString()
        speak(currentLetter)

        lastSoundMatched = false // Reset match flag for new event
    }

    func checkSoundMatch() {
        guard soundCurrentEvent >= nBack else { return }
        
        let currentIndex = soundCurrentEvent - 1
        let matchIndex = currentIndex - nBack
        
        // Ensure matchIndex is within bounds of soundNBackString
        guard matchIndex >= 0 && matchIndex < soundNBackString.count else { return }
        
        if soundNBackString[currentIndex] == soundNBackString[matchIndex] && !lastSoundMatched {
            incrementCorrectResponses()
            lastSoundMatched = true // Mark that a match was found for this event
        }
    }

    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
