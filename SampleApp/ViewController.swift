//
//  ViewController.swift
//  SampleApp
//
//  Created by Jan Chaloupecky on 14.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import UIKit
import AVWXKit

class ViewController: UIViewController {

    let client = AVWXClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func requestIcaoAction(sender: Any) {
        
        client.fetchMetar(forIcao: "KSBP") { result in
            switch result {
            case .success(let metar):
                print("Metar: \(metar.rawReport)")
                break;
            case .failure(let error):
                print("Could not fetch: \(error)")
                break
            }
        }
    }
    
    @IBAction func requestCoordinatesAction(sender: Any) {
    
    }
}

