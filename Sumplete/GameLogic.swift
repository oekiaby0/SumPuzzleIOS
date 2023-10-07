//
//  GameLogic.swift
//  Sumplete
//
//  Created by Omar Elekiaby on 11/03/2023.
//

import Foundation

struct Game {
    let matrix: [[Int]]
    let solutions: [(Int, Int)]
    let sums: ([Int], [Int])
    let n: Int
}

func calculateSums(matrix: [[Int]], n: Int) -> ([Int], [Int]) {
    var row: [Int] = Array(repeating: 0, count: n)
    for i in 0..<n {
        for j in 0..<n {
            row[i] += matrix[i][j]
        }
    }
    
    var column: [Int] = Array(repeating: 0, count: n)
    for j in 0..<n {
        for i in 0..<n {
            column[j] += matrix[i][j]
        }
    }
    return (row, column)
}

func makeMatrix(n: Int) -> Game {
    var matrix = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
    var falseValues = [(Int, Int)]();
    for i in 0..<n {
        for j in 0..<n {
            if Bool.random() {
                matrix[i][j] = Int.random(in: 1..<10)
            } else {
                falseValues.append( (i,j) )
            }
        }
    }
    let sums = calculateSums(matrix: matrix, n: n)
    for val in falseValues {
        matrix[val.0][val.1] = Int.random(in: 1..<10)
    }
    return Game(matrix: matrix, solutions: falseValues, sums: sums, n:n)
}
