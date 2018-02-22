//
//  ViewController.swift
//  SampleApp
//
//  Created by Jan Chaloupecky on 14.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

import AVWXKit
import AVWXKitRx

import RxCocoa
import RxSwift
import MBProgressHUD
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var icaoTextField: UITextField!
    @IBOutlet var coordinatesTextField: UITextField!
    @IBOutlet var metarRequestButton: UIButton!
    @IBOutlet var coordinatesRequestButton: UIButton!
    
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
        setupActions()
    }
    
    // MARK: - RxSwift
    
    private func setupValidation() {
        icaoTextField
            .rx
            .text
            .map { value in
                return value != nil  && value!.count > 0
            }
            .subscribe(onNext: { (valid) in
                self.metarRequestButton.isEnabled = valid
            }).disposed(by: disposeBag)
        
        coordinatesTextField
            .rx
            .text
            .map { value in
                guard let coordinates = value else { return false }
                return CLLocationCoordinate2D(coordinatesString: coordinates) != nil
            }
            .subscribe(onNext: { valid in
               self.coordinatesRequestButton.isEnabled = valid
            }).disposed(by: disposeBag)
    }
    
    private func setupActions() {
        
        // this doesnt work as on the 1st API error the button observable completes
//        metarRequestButton.rx.tap
//            .withLatestFrom(icaoTextField.rx.text.orEmpty)
//            .filter { $0.count > 0 }
//            .flatMap { icao -> Single<Metar> in
//                SVProgressHUD.show()
//
//                return self.client.fetchMetar(forIcao: icao, options: [.speech, .info]).do(onError: { (error) in
//                    SVProgressHUD.dismiss()
//                    print("API error: ", error)
//                }).catchError({ (_) -> PrimitiveSequence<SingleTrait, Metar> in
//
//                })
//            }
//            .map { $0.rawReport }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] result in
//                SVProgressHUD.dismiss()
//
//                guard let sself = self else { return }
//                sself.textView.text = result
//
//            }, onError: { [weak self] error in
//                guard let sself = self else { return }
//                SVProgressHUD.dismiss()
//                sself.showMessage("Error", description: error.localizedDescription)
//            }).disposed(by: disposeBag)
    }
    
    
    
    @IBAction func requestByCoordinatesAction(sender: Any) {
        
        SVProgressHUD.show()
        
        guard let coordinates = CLLocationCoordinate2D(coordinatesString: coordinatesTextField.text!) else { return }
        
        client.fetchMetar(at: coordinates, options: [.speech, .info])
            .observeOn(MainScheduler.instance)
            .map { $0.rawReport + "\n\n" + $0.speech! + "\n\n" + "\($0.minutesOld)min"}
            .subscribe(onSuccess: { [weak self] metar in
                
                guard let sself = self else { return }
                sself.textView.text = metar
                SVProgressHUD.dismiss()
                
                }, onError: { [weak self] error in
                    
                    guard let sself = self else { return }
                    SVProgressHUD.dismiss()
                    sself.showMessage("Error", description: error.localizedDescription)
                    
            }).disposed(by: disposeBag)
    }
    
    @IBAction func fetchAction(sender: Any) {
        
        SVProgressHUD.show()
        
        client.fetchMetar(forIcao: icaoTextField.text!, options: [.speech, .info])
            .observeOn(MainScheduler.instance)
            .map { $0.rawReport + "\n\n" + $0.speech! + "\n\n" + "\($0.minutesOld) min"}
            .subscribe(onSuccess: { [weak self] metar in
                
                guard let sself = self else { return }
                sself.textView.text = metar
                SVProgressHUD.dismiss()
                
            }, onError: { [weak self] error in
                
                guard let sself = self else { return }
                SVProgressHUD.dismiss()
                sself.showMessage("Error", description: error.localizedDescription)
                
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

extension CLLocationCoordinate2D {
    
    /// 35.237,-120.644
    init?(coordinatesString: String) {
        let stringArray = coordinatesString.split(separator: ",")
        guard
            stringArray.count == 2,
            let lat = Double(stringArray[0]),
            let lon = Double(stringArray[1]) else {
                return nil
        }
        self.init(latitude: lat, longitude: lon)
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
