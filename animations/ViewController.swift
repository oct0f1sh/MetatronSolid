//
//  ViewController.swift
//  animations
//
//  Created by Duncan MacDonald on 4/30/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var solid: GeometricActivityIndicator!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0: // LEFT BUTTON TAPPED
            solid.shapeTypeIndex -= 1
        case 1: // RIGHT BUTTON TAPPED
            solid.shapeTypeIndex += 1
        case 2: // START BUTTON TAPPED
            solid.startAnimating()
        case 3: // STOP BUTTON TAPPED
            solid.stopAnimating()
        default:
            break
        }
    }
}
