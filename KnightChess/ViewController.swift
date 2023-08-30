//
//  ViewController.swift
//  KnightChess
//
//  Created by Athanasleri, Despoina on 29/8/23.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    
    var viewModel: ChessboardViewModel!
    var chessboardCollectionView: UICollectionView!
    var messageLabel: UILabel!

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ChessboardViewModel(size: 8) // Adjust the size as needed
        setupUI()
        viewModel.setupCells()
    }

    // MARK: UI Setup
    
    func setupUI() {
        // Configure collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        // Create and configure collection view
        chessboardCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        chessboardCollectionView.backgroundColor = .white
        chessboardCollectionView.delegate = self
        chessboardCollectionView.dataSource = self
        chessboardCollectionView.register(ChessCell.self, forCellWithReuseIdentifier: "ChessCell")

        // Create and configure message label
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        // Add collection view and message label to the view
        view.addSubview(chessboardCollectionView)
        view.addSubview(messageLabel)

        // Set autoresizing masks
        chessboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Apply constraints
        NSLayoutConstraint.activate([
            // Collection view constraints
            chessboardCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            chessboardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chessboardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chessboardCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Message label constraints
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: UI Updates
    
    func updateChessboardCells() {
        if let selectedStart = viewModel.selectedStart,
           let selectedEnd = viewModel.selectedEnd {
            let startIndexPath = IndexPath(item: selectedStart.0 * viewModel.chessboard.size + selectedStart.1, section: 0)
            let endIndexPath = IndexPath(item: selectedEnd.0 * viewModel.chessboard.size + selectedEnd.1, section: 0)
            chessboardCollectionView.reloadItems(at: [startIndexPath, endIndexPath])
        }
    }
    
    func updateUIWithPaths(_ paths: [[(Int, Int)]]) {
        if paths.isEmpty {
            messageLabel.text = "No paths found."
        } else {
            messageLabel.text = "\(paths.count) \(paths.count == 1 ? "path" : "paths") found."
            
            // Clear previous selections and update the collection view
            viewModel.clearSelections()
            chessboardCollectionView.reloadData()
            
            // Iterate through all cells and reset their isSelected property
            for row in 0..<viewModel.chessboard.size {
                for column in 0..<viewModel.chessboard.size {
                    let indexPath = IndexPath(item: row * viewModel.chessboard.size + column, section: 0)
                    if let cell = chessboardCollectionView.cellForItem(at: indexPath) as? ChessCell {
                        cell.isSelected = false
                    }
                }
            }
            
            // Iterate through paths and highlight cells
            for path in paths {
                for position in path {
                    let indexPath = IndexPath(item: position.0 * viewModel.chessboard.size + position.1, section: 0)
                    if let cell = chessboardCollectionView.cellForItem(at: indexPath) as? ChessCell {
                        cell.highlight()
                    }
                }
            }
        }
    }
}

// MARK: Collection View Data Source

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.chessboard.size * viewModel.chessboard.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChessCell", for: indexPath) as? ChessCell else {
            fatalError("Unable to dequeue ChessCell")
        }
        
        let row = indexPath.row / viewModel.chessboard.size
        let column = indexPath.row % viewModel.chessboard.size
        
        cell.isSelected = viewModel.isCellSelected(at: row, column: column)
        
        return cell
    }
}

// MARK: Collection View Delegate and Flow Layout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = collectionView.bounds.width / CGFloat(viewModel.chessboard.size)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row / viewModel.chessboard.size
        let column = indexPath.row % viewModel.chessboard.size
        
        if viewModel.isStartSet() && viewModel.isEndSet() {
            viewModel.clearSelections()
            updateChessboardCells()
        }
        
        if !viewModel.isStartSet() {
            viewModel.selectedStart = (row, column)
            updateChessboardCells()
        } else if !viewModel.isEndSet() {
            viewModel.selectedEnd = (row, column)
            updateChessboardCells()
        }
        
        if viewModel.isStartSet() && viewModel.isEndSet() {
            let paths = viewModel.findPaths()
            updateUIWithPaths(paths)
        }
    }
}
