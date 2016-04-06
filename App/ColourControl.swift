//
//  ColourControl.swift
//  App
//
//  Created by Mark Naylor on 23/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class ColourControl: UIView {
    
    // MARK: Properties
    
    var colour = UIColor(){
        didSet {
            setNeedsLayout()
            setSelection()
        }
    }
    var selected = UIButton()
    var selectedIndex = 0
    
    var colourButtons = [UIButton]()
    var colours = [UIColor]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgRed = UIColor(netHex:0xFFB6C1)
        let bgGreen = UIColor(netHex:0xCCFF99)
        let bgYellow = UIColor(netHex: 0xFFFF7F)
        let bgWhite = UIColor(netHex: 0xFFFFFF)
        let bgOrange = UIColor(netHex: 0xFFA500)
        let bgBlue = UIColor(netHex: 0x99CCFF)
        
        colours.append(bgRed)
        colours.append(bgGreen)
        colours.append(bgYellow)
        colours.append(bgWhite)
        colours.append(bgOrange)
        colours.append(bgBlue)
        
        for i in 0..<6 {
            let button = UIButton()
            button.setImage(UIImage(named: "correct"), forState: [.Selected])
            button.adjustsImageWhenHighlighted = false
            button.backgroundColor = colours[i]
            button.layer.borderWidth = 0.6
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.addTarget(self, action: #selector(ColourControl.colourButtonTapped(_:)), forControlEvents: .TouchDown)
            colourButtons.append(button)
            addSubview(button)
        }
    }
    
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        let spacing = buttonSize / 2
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in colourButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
    }
    
    func colourButtonTapped(button: UIButton) {
        selectedIndex = colourButtons.indexOf(button)!
        colour = colours[selectedIndex]
        setSelection()
    }
    
    
    func setSelection() {
        for i in 0..<6 {
            if colours[i].toHexString() == colour.toHexString()  {
                colourButtons[i].selected = true
            }
            else {
                colourButtons[i].selected = false
            }
        }
    }
}
