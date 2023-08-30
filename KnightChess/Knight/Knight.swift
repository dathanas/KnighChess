//
//  Knight.swift
//  KnightChess
//
//  Created by Athanasleri, Despoina on 29/8/23.
//

import Foundation

struct Knight {
    // MARK: Properties
    
    let x: Int
    let y: Int
    
    // MARK: Public Methods
    
    /// Returns an array of possible moves for the knight on a board of the given size.
    /// - Parameter size: The size of the board.
    /// - Returns: An array of tuples representing possible moves.
    func possibleMoves(onBoardWithSize size: Int) -> [(Int, Int)] {
        let moves: [(Int, Int)] = [
            (2, 1), (1, 2),
            (-1, 2), (-2, 1),
            (-2, -1), (-1, -2),
            (1, -2), (2, -1)
        ]
        
        var validMoves: [(Int, Int)] = []
        
        for move in moves {
            let newX = x + move.0
            let newY = y + move.1
            
            if newX >= 0 && newX < size && newY >= 0 && newY < size {
                validMoves.append((move.0, move.1))
            }
        }
        
        return validMoves
    }
    
    /// Finds paths from the current position of the knight to a destination on a board of the given size within a maximum number of moves.
    /// - Parameters:
    ///   - destination: The destination position.
    ///   - maxMoves: The maximum number of moves allowed to reach the destination.
    ///   - size: The size of the board.
    /// - Returns: An array of paths, where each path is an array of positions.
    func findPathsTo(destination: (Int, Int), maxMoves: Int, onBoardWithSize size: Int) -> [[(Int, Int)]] {
        var paths: [[(Int, Int)]] = []
        
        // Backtracking function to explore paths
        func backtrack(_ currentPath: [(Int, Int)]) {
            let currentMoves = currentPath.count - 1
            let currentPosition = currentPath.last!
            
            // Check if the destination is reached within the move limit
            if currentPosition == destination && currentMoves <= maxMoves {
                paths.append(currentPath)
                return
            }
            
            // Stop exploring if move limit is exceeded
            if currentMoves >= maxMoves {
                return
            }
            
            let possibleMoves = self.possibleMoves(onBoardWithSize: size)
            
            // Explore possible moves
            for move in possibleMoves {
                let newX = currentPosition.0 + move.0
                let newY = currentPosition.1 + move.1
                
                if newX >= 0 && newX < size && newY >= 0 && newY < size {
                    let newPath = currentPath + [(newX, newY)]
                    backtrack(newPath)
                }
            }
        }
        
        // Start backtracking from the knight's initial position
        backtrack([(x, y)])
        return paths
    }
}
