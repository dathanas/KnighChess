//
//  Chessboard.swift
//  KnightChess
//
//  Created by Athanasleri, Despoina on 29/8/23.
//

import Foundation

class Chessboard {
    // MARK: Properties
    
    let size: Int
    var cells: [[ChessCell]] = []
    
    // MARK: Initialization
    
    init(size: Int) {
        self.size = size
        setupCells()
    }
    
    // MARK: Public Methods
    
    /// Sets up the cells of the chessboard.
    func setupCells() {
        cells = Array(repeating: [], count: size)
        
        // Initialize cells for each row
        for row in 0..<size {
            for _ in 0..<size {
                let cell = ChessCell()
                cells[row].append(cell)
            }
        }
    }
    
    /// Clears the selection state of all cells on the chessboard.
    func clearSelections() {
        for row in 0..<size {
            for column in 0..<size {
                cells[row][column].isSelected = false
            }
        }
    }

    /// Checks if a cell at a given position is selected.
    /// - Parameters:
    ///   - row: The row index of the cell.
    ///   - column: The column index of the cell.
    /// - Returns: `true` if the cell is selected, otherwise `false`.
    func isCellSelected(at row: Int, column: Int) -> Bool {
        return cells[row][column].isSelected
    }
}
