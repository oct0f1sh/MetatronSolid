//
//  ViewController.swift
//  animations
//
//  Created by Duncan MacDonald on 4/30/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var solid: MetatronSolid!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        solid = MetatronSolid(frame: self.view.frame, type: .metatron)
        solid.tag = 10
        solid.backgroundColor = UIColor.clear
        self.view.addSubview(solid)
        self.view.layoutSubviews()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            if sender.isOn {
                solid.drawStencil = true
            } else {
                solid.drawStencil = false
            }
        case 1:
            if sender.isOn {
                solid.shouldRepeat = true
            } else {
                solid.shouldRepeat = false
            }
        default:
            print("error")
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("tetrahedron")
            solid.shape = .tetrahedron
        case 1:
            print("cube")
            solid.shape = .cube
        case 2:
            print("octahedron")
            solid.shape = .octahedron
        case 3:
            print("icosahedron")
            solid.shape = .icosahedron
        case 4:
            print("metatron")
            solid.shape = .metatron
        default:
            print("error")
        }
    }
}
