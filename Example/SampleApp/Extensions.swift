//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import AVFoundation
import CoreLocation
import UIKit

extension ViewController {

    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
    }

    func alert(title: String, text: String? = nil) {

        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
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
