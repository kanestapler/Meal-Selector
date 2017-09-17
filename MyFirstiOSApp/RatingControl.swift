//
//  RatingControl.swift
//  MyFirstiOSApp
//
//  Created by Kane Stapler on 9/5/17.
//  Copyright © 2017 Kane Stapler. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    @IBInspectable var starSize: CGSize = CGSize(width:44.0, height:44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    private var ratingButtons = [UIButton]()
    var rating = 3 {
        didSet {
            updateStarsToRatings()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(filledStar, for: .selected)
            button.setImage(emptyStar, for: .normal)
            button.accessibilityLabel = "Set \(index + 1) star rating"
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        updateStarsToRatings()
    }
    
    func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("Button not in array")
        }
        
        let selectedRating = index + 1
        if (rating == selectedRating) {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    func updateStarsToRatings() {
        for (index, button) in ratingButtons.enumerated() {
            let hintText: String?
            let valueText: String
            button.isSelected = index < rating
            if (rating == index + 1) {
                hintText = "Tap to reset rating"
            } else {
                hintText = nil
            }
            
            switch (rating) {
            case 0:
                valueText = "No rating set"
            case 1:
                valueText = "1 star set"
            default:
                valueText = "\(rating) stars set"
            }
            button.accessibilityHint = hintText
            button.accessibilityValue = valueText
        }
        
    }
}
