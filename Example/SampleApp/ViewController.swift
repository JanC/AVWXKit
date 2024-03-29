//
//  ViewController.swift
//  SampleApp
//
//  Created by Jan Chaloupecky on 14.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import AVWXKit
import CoreLocation
import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var icaoTextField: UITextField!
    @IBOutlet private var coordinatesTextField: UITextField!
    @IBOutlet private var metarRequestButton: UIButton!
    @IBOutlet private var coordinatesRequestButton: UIButton!
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!

    // Token from https://account.avwx.rest/
    let client = AVWXClient(token: "token")

    var metar: Metar?
    var viewModel: MetarViewModel?

    // MARK: - Actions

    @IBAction func requestByCoordinatesAction(sender: Any) {
        guard let coordinates = CLLocationCoordinate2D(coordinatesString: coordinatesTextField.text!) else { return }
        client.fetchMetar(at: coordinates, options: [.speech, .info], completion: handleResult(_:))
    }
    
    @IBAction func fetchAction(sender: Any) {
        guard let icao = icaoTextField.text else { return }
        client.fetchMetar(at: icao, options: [.speech, .info, .translate], completion: handleResult(_:))
    }

    // MARK: - Private

    private func handleResult(_ result: Result<Metar, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let metar):
                self.viewModel = MetarViewModel(metar: metar)
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage("Error", description: error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowsCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { fatalError("no view model") }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { fatalError() }

        cell.configure(with: viewModel.viewModel(at: indexPath))

        return cell
    }
}
