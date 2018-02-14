//
//  ViewController.swift
//  SampleApp
//
//  Created by Jan Chaloupecky on 14.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import UIKit
import AVFoundation
import AVWXKit

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var icaoTextField: UITextField!
    
    let client = AVWXClient()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var metar: Metar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func requestIcaoAction(sender: Any) {
        
        client.fetchMetar(forIcao: icaoTextField.text!, options: [.speech ]) { result in
            OperationQueue.main.addOperation {
                
                switch result {
                case .success(let metar):
                    print("Metar: \(metar.rawReport)")
                    var textValue = metar.rawReport
                    if let speech = metar.speech {
                        textValue = "\(textValue)\n\(speech)"
                    }
                    self.textView.text = textValue
                    self.metar = metar
                    
                    break;
                case .failure(let error):
                    self.show(message: error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @IBAction func requestCoordinatesAction(sender: Any) {
    
    }
    
    @IBAction func speekAction(sender: Any) {
        if
            let speech = metar?.speech
        {
            speak(phrase: speech)
        }
    }
    
    @IBAction func testSpeech() {
        speak(phrase: "Winds Calm. Visibility one zero miles. Temperature nine degrees Celsius. Dew point five degrees Celsius. Altimeter three zero point one five. Overcast layer at 9000ft")
    }
    
    func speak(phrase: String) {
        myUtterance = AVSpeechUtterance(string: phrase)
        myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synth.speak(myUtterance)
    }
    
}

extension UIViewController {
    func show(message: String) {
        let alertViewController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertViewController, animated: true)
    }
}
