//
//  ViewController.swift
//  AttrLabel
//
//  Created by ENUUI on 2017/8/6.
//  Copyright © 2017年 FUHUI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let lbl = AttrLabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50))
        lbl.alText = "这是一次点击"
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .right
        lbl.isUserInteractionEnabled = true
        view.addSubview(lbl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

