//
//  ChessCell.swift
//  KnightChess
//
//  Created by Athanasleri, Despoina on 29/8/23.
//

import Foundation
import UIKit

class ChessCell: UICollectionViewCell {
    // MARK: Properties
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: Public Methods
    
    /// Highlights the cell by setting its selection state to true and updating its appearance.
    func highlight() {
        isSelected = true
        updateAppearance()
    }
    
    // MARK: Private Methods
    
    /// Sets up the initial visual properties of the cell.
    private func setupCell() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        updateAppearance()
    }
    
    /// Updates the appearance of the cell based on its selection state.
    private func updateAppearance() {
        backgroundColor = isSelected ? UIColor.red : UIColor.white
    }
}
