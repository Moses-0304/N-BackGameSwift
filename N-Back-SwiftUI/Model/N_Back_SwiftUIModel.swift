//
//  N_Back_SwiftUIModel.swift
//  N-Back-SwiftUI
//
//  Created by Jonas Willén on 2023-09-19.
//

import Foundation

struct N_BackSwiftUIModel {
    private var count : Int
    private let letters = ["A", "B", "C", "D", "E"] // Lista av bokstäver
    
    init(count: Int) {
        self.count = count
    }
    
    func getString() -> String {
            // Returnerar en slumpmässig bokstav från listan
            return letters.randomElement() ?? "A"
    }
    
    func getHighScore() -> Int{
        return count
    }
    
    mutating func addScore(){
        count += 1
    }
      
    mutating func resetNback(){
        let Nback = create(20, 9, 20, 1)
        
        for i in 1...3 {
            let test:Int32 = Int32(i)
            print("aValue: \(getIndexOf(Nback, test))")
        }
    }

   
}
