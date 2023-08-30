//
//  ChessBoardViewModel.swift
//  KnightChess
//
//  Created by Athanasleri, Despoina on 29/8/23.
//

import Foundation

class ChessboardViewModel {
    // MARK: Properties
    
    var chessboard: Chessboard
    var selectedStart: (Int, Int)?
    var selectedEnd: (Int, Int)?
    
    // MARK: Initialization
    
    init(size: Int) {
        chessboard = Chessboard(size: size)
    }
    
    // MARK: Public Methods
    
    /// Sets up the cells of the chessboard.
    func setupCells() {
        chessboard.setupCells()
    }
    
    /// Clears the selected cells on the chessboard.
    func clearSelections() {
        selectedStart = nil
        selectedEnd = nil
        
        // Clear selection state for all cells
        for row in 0..<chessboard.size {
            for column in 0..<chessboard.size {
                chessboard.cells[row][column].isSelected = false
            }
        }
        
        // Update the UI to reflect changes
        updateChessboardCells()
    }
    
    /// Checks if a cell at a given position is selected.
    /// - Parameters:
    ///   - row: The row index of the cell.
    ///   - column: The column index of the cell.
    /// - Returns: `true` if the cell is selected, otherwise `false`.
    func isCellSelected(at row: Int, column: Int) -> Bool {
        return chessboard.isCellSelected(at: row, column: column)
    }
    
    /// Checks if a starting cell has been set.
    /// - Returns: `true` if a starting cell is set, otherwise `false`.
    func isStartSet() -> Bool {
        return selectedStart != nil
    }
    
    /// Checks if an ending cell has been set.
    /// - Returns: `true` if an ending cell is set, otherwise `false`.
    func isEndSet() -> Bool {
        return selectedEnd != nil
    }
    
    /// Finds paths for the knight from the selected starting cell to the selected ending cell.
    /// - Returns: An array of paths, where each path is an array of cell coordinates.
    func findPaths() -> [[(Int, Int)]] {
        guard let start = selectedStart, let end = selectedEnd else {
            return []
        }
        
        let knight = Knight(x: start.0, y: start.1)
        let paths = knight.findPathsTo(destination: end, maxMoves: 3, onBoardWithSize: chessboard.size)
        
        return paths
    }
    
    // MARK: Internal Methods
    
    /// Updates the selection state of the cells on the chessboard.
    internal func updateChessboardCells() {
        chessboard.clearSelections()
        
        if let start = selectedStart {
            chessboard.cells[start.0][start.1].isSelected = true
        }
        
        if let end = selectedEnd {
            chessboard.cells[end.0][end.1].isSelected = true
        }
    }
}
