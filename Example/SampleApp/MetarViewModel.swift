//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import Foundation

import AVWXKit

struct EntryViewModel {

    let title: String
    let value: String
}

struct MetarViewModel {

    let metar: Metar

    var sectionTitle: String {
        return ""
    }
    var rowsCount: Int {
        return rowValues.count
    }

    func viewModel(at indexPath: IndexPath) -> EntryViewModel {
        return rowValues[indexPath.row]
    }

    private let rowValues: [EntryViewModel]

    init(metar: Metar) {
        self.metar = metar
        self.rowValues = MetarViewModel.generateRows(metar: metar)
    }

    static func generateRows(metar: Metar) -> [EntryViewModel] {
        var values = [EntryViewModel]()

        values.append(EntryViewModel(title: "Issued", value: "\(metar.minutesOld)min ago"))
        values.append(EntryViewModel(title: "Flight Rules", value: metar.flightRules.rawValue))
        values.append(EntryViewModel(title: "Report", value: metar.rawReport))
        values.append(EntryViewModel(title: "Remarks", value: metar.remarks))

        if let speech = metar.speech {
            values.append(EntryViewModel(title: "Speech", value: speech))
        }

        if let translations = metar.translations {
            values.append(EntryViewModel(title: "Altimeter", value: translations.altimeter))
            values.append(EntryViewModel(title: "Temperature", value: translations.temperature))
            values.append(EntryViewModel(title: "Visibility", value: translations.visibility))
            values.append(EntryViewModel(title: "Wind", value: translations.wind))
            values.append(EntryViewModel(title: "Clouds", value: translations.clouds.replacingOccurrences(of: ", ", with: "\n")))
            values.append(EntryViewModel(title: "Dew Point", value: translations.dewpoint))
            values.append(EntryViewModel(title: "Other", value: translations.other))

            for (remark, remarkValue) in translations.remarks {
                values.append(EntryViewModel(title: "Remark \(remark)", value: remarkValue))
            }
        }
        return values
    }
}
