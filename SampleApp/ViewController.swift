//
//  ViewController.swift
//  SampleApp
//
//  Created by Jan Chaloupecky on 14.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import UIKit
import CoreLocation

import AVWXKit
import AVWXKitRx

import RxCocoa
import RxSwift
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var icaoTextField: UITextField!
    @IBOutlet var coordinatesTextField: UITextField!
    @IBOutlet var metarRequestButton: UIButton!
    @IBOutlet var coordinatesRequestButton: UIButton!
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    
    let client = AVWXClient(baseURL: URL(string: "https://avwx.aeronavmap.com/")!)

    let disposeBag = DisposeBag()
    
    var metar: Metar?
    var viewModel: MetarViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidation()
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

    // MARK: - Actions

    @IBAction func requestByCoordinatesAction(sender: Any) {
        
        SVProgressHUD.show()
        
        guard let coordinates = CLLocationCoordinate2D(coordinatesString: coordinatesTextField.text!) else { return }
        
        client.fetchMetar(at: coordinates, options: [.speech, .info])
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] metar in

                guard let sself = self else { return }
                sself.viewModel =  MetarViewModel(metar: metar)
                sself.tableView.reloadData()
                SVProgressHUD.dismiss()
                
                }, onError: { [weak self] error in
                    
                    guard let sself = self else { return }
                    SVProgressHUD.dismiss()
                    sself.showMessage("Error", description: error.localizedDescription)
                    
            }).disposed(by: disposeBag)
    }
    
    @IBAction func fetchAction(sender: Any) {
        
        SVProgressHUD.show()
        
        client.fetchMetar(forIcao: icaoTextField.text!, options: [.speech, .info, .translate])
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] metar in
                
                guard let sself = self else { return }
                sself.metar = metar
                sself.viewModel =  MetarViewModel(metar: metar)
                sself.tableView.reloadData()
                SVProgressHUD.dismiss()
                
            }, onError: { [weak self] error in
                
                guard let sself = self else { return }
                SVProgressHUD.dismiss()
                sself.showMessage("Error", description: error.localizedDescription)
                
            }).disposed(by: disposeBag)
    }

    @IBAction func speakAction(sender: Any) {
        if
            let speech = metar?.speech
        {
            speak(phrase: speech.replacingOccurrences(of: "kt", with: "knots"))
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowsCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError("no view model") }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { fatalError() }

        cell.configure(with: viewModel.viewModel(at: indexPath))

        return cell
    }
}

