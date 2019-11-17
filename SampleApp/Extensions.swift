//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import AVFoundation
import CoreLocation
import RxCocoa
import RxSwift
import UIKit

extension ViewController {

    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
                .subscribe()
                .disposed(by: disposeBag)
    }

    func alert(title: String, text: String? = nil) -> Completable {

        return Completable.create { observer -> Disposable in

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

    func speak(phrase: String) {
        print("Speaking: \(phrase)")
        let synthesizer = AVSpeechSynthesizer()
        var utterance = AVSpeechUtterance(string: "")
        utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
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
