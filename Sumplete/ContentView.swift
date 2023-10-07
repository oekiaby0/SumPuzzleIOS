//
//  ContentView.swift
//  Sumplete
//
//  Created by Omar Elekiaby on 11/03/2023.
//

import SwiftUI


struct MatrixItem: View {
    var val: Int
    var state: Int
    var body: some View {
        Text(String(val)).bold()
            .foregroundColor(UIScreen.main.traitCollection.userInterfaceStyle == .light ? .black : .white)
            .padding(10)
            .border(.primary)
            .background(
                state == 0 ? (
                    UIScreen.main.traitCollection.userInterfaceStyle == .light ? .white : .gray
                ) :
                    state == 1 ? .red : .green
            )
    }
}


struct GameView: View {
    @State var n: Int = 5
    @State var game: Game = makeMatrix(n: 5)
    @State var elementState: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 5)
    @State private var isPresentingSelection: Bool = false
    
    func restart() {
        game = makeMatrix(n: n)
        clear()
    }
    
    func hint() {
        for i in game.matrix.indices {
            for j in game.matrix.indices {
                if game.solutions.contains(where: {$0 == (i,j)}) {
                    if elementState[i][j] != 1 {
                        elementState[i][j] = 1
                        return
                    }
                } else {
                    if elementState[i][j] == 1 {
                        elementState[i][j] = 0
                        return
                    }
                }
            }
        }
    }
    
    func reveal() {
        elementState = [[Int]](repeating: [Int](repeating: 2, count: n), count: n)
        for solution in game.solutions {
            elementState[solution.0][solution.1] = 1
        }
    }
    
    func clear() {
        elementState = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
    }
    
    func toggle(i: Int, j: Int) {
        if elementState[i][j] == 2 {
            elementState[i][j] = 0
        } else {
            elementState[i][j] += 1
        }
    }
    
    func rowSum(i: Int) -> Bool {
        var sum: Int = 0
        for j in 0..<n {
            if elementState[i][j] != 1 {
                sum += game.matrix[i][j]
            }
        }
        return sum == game.sums.0[i]
    }
    
    func columnSum(j: Int) -> Bool {
        var sum: Int = 0
        for i in 0..<n {
            if elementState[i][j] != 1 {
                sum += game.matrix[i][j]
            }
        }
        return sum == game.sums.1[j]
    }
    
    var body: some View {
        VStack(spacing: 13) {
            HStack {
                Button("Restart") {
                    isPresentingSelection = true
                }
                .confirmationDialog("Select size",
                  isPresented: $isPresentingSelection) {
                  Button("3x3 (beginner)", role: .destructive) {
                      n = 3
                      restart()
                   }
                    Button("4x4 (easy)", role: .destructive) {
                        n = 4
                        restart()
                     }
                    Button("5x5 (intermediate)", role: .destructive) {
                        n = 5
                        restart()
                     }
                    Button("6x6 (challenging)", role: .destructive) {
                        n = 6
                        restart()
                     }
                    Button("7x7 (advanced)", role: .destructive) {
                        n = 7
                        restart()
                     }
                    Button("8x8 (Master)", role: .destructive) {
                        n = 8
                        restart()
                     }
                    Button("9x9 (Expert)", role: .destructive) {
                        n = 9
                        restart()
                     }
                 }

                .buttonStyle(.borderedProminent)
                Button("Reveal") {
                    reveal()
                }.buttonStyle(.borderedProminent)
                Button("Clear") {
                    clear()
                }.buttonStyle(.borderedProminent)
                Button("Hint") {
                    hint()
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible(maximum: 45)), count: n+1), spacing: 10) {
                ForEach(game.matrix.indices) { i in
                    ForEach(game.matrix[i].indices) { j in
                        MatrixItem(val: game.matrix[i][j], state: elementState[i][j]).onTapGesture {
                            toggle(i: i, j: j)
                        }
                    }.id(game.matrix[i])
                    Text(String(game.sums.0[i]))
                        .foregroundColor(rowSum(i: i) ? .primary : .secondary)
                        .bold()
                        .onTapGesture {
                            for j in game.matrix.indices {
                                if elementState[i][j] == 0 {
                                    elementState[i][j] = 2
                                }
                            }
                        }
                }.id(game.matrix)
            }
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible(maximum: 45)), count: n+1), spacing: 10) {
                ForEach(game.sums.1.indices) { j in
                    Text(String(game.sums.1[j]))
                        .foregroundColor(columnSum(j: j) ? .primary : .secondary)
                        .bold()
                        .onTapGesture {
                            for i in game.matrix.indices {
                                if elementState[i][j] == 0 {
                                    elementState[i][j] = 2
                                }
                            }
                        }
                }.id(game.sums.1)
            }
            Spacer()
        }.padding(.vertical)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            GameView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
