//
//  RatingControl.swift
//  Showplace
//
//  Created by Станислав Белоусов on 03/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
   // MARK - Iitialization
    
    override init (frame:CGRect){
        super.init(frame:frame)
        setupButtons()
        
        }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    @objc func ratingButtonTapped (button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else { return }
    
    let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    
    }
    
    private func setupButtons() {
        
        let filledStar = UIImage(systemName: "star.fill")
        let emptyStar = UIImage(systemName: "star")
        let highlightedStar = UIImage(systemName: "star.fill")
        
        
        for _ in 0..<starCount {
            let button = UIButton()
          
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for:[.highlighted, .selected])
            
            button.tintColor = .lightGray
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
    }
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
