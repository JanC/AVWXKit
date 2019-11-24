//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet private var entryTitleLabel: UILabel!
    @IBOutlet private var entryValueLabel: UILabel!

    func configure(with viewModel: EntryViewModel) {
        entryValueLabel.text = viewModel.value
        entryTitleLabel.text = viewModel.title
    }
}
