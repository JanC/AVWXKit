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
import AVWXKitRx

import RxCocoa
import RxSwift
import MBProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var icaoTextField: UITextField!
    @IBOutlet var metarRequestButton: UIButton!
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    
    let client = AVWXClient()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    let disposeBag = DisposeBag()
    
    var metar: Metar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidation()
    }
    
    // MARK: - RxSwift
    
    private func setupValidation() {
        let icaoValid = icaoTextField
            .rx
            .text
            .map { value in
                return value != nil  && value!.count > 0
        }
            icaoValid.subscribe(onNext: { (valid) in
            self.metarRequestButton.isEnabled = valid
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func fetchAction(sender: Any) {
        
        // API 
        let request = client.fetchMetar(forIcao: icaoTextField.text!, options: [.speech, .info]).share()
        
        // handles the request
        request
            .observeOn(MainScheduler.instance)
            .map { $0.rawReport }
            .subscribe(onNext: { [weak self] metar in
                self?.textView.text = metar
            }, onError: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            }, onCompleted: {
                print("on completed")
            }).disposed(by: disposeBag)
        
        // handle the UI state
        MBProgressHUD.showAdded(to: view, animated: true)
        request
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                //
            }, onCompleted: {
                MBProgressHUD.hide(for: self.view, animated: true)
            }).disposed(by: disposeBag)
        
        
//        // handles the speech
//        request
//            .flatMap({ (metar) -> Observable<String> in
//                guard var speech = metar.speech else {
//                    return Observable.empty()
//                }
//
//                if let info = metar.info {
//                    speech = info.name + " information Juliette. " + speech
//                }
//
//                return Observable.just(speech)
//            })
//            .map({ speech -> String in
//                speech.replacingOccurrences(of: "kt", with: "knots")
//            })
//            .subscribe(onNext: { [weak self] speech in
//                self?.speak(phrase: speech)
//            })
//            .disposed(by: disposeBag)
    }
    
    @IBAction func speekAction(sender: Any) {
        if
            let speech = metar?.speech
        {
            speak(phrase: speech.replacingOccurrences(of: "kt", with: "knots"))
        }
    }
    
    func speak(phrase: String) {
        print("Speaking: \(phrase)")
        myUtterance = AVSpeechUtterance(string: phrase)
        myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synth.speak(myUtterance)
    }
    
}

extension ViewController {
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func alert(title: String, text: String? = nil) -> Completable  {
        
        return Completable.create { (observer) -> Disposable in
            
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                observer(.completed)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
