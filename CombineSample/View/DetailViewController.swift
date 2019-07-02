//
//  DetailViewController.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!

    func setup(_ weather: HourlyWeather) {
        hourLabel.text = "\(weather.hour)時"
        iconImageView.image = UIImage(named: weather.weather.icon)
        weatherDescriptionLabel.text = weather.weather.weatherDescription
        tempLabel.text = String(weather.temp)
    }
}

class DetailViewController: UITableViewController {
    var presenter: DetailViewPresenter?
    var weatherList: [DailyWeather] {
        return presenter?.outputs.weatherList ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        presenter?.inputs.fetch.send(())

        let _ = presenter?.outputs.didChange.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                if let errorMessage = self?.presenter?.outputs.errorMessage {
                    self?.showErrorMessage(errorMessage)
                    return
                }
                self?.tableView.reloadData()
            }
        })
    }

    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.presenter?.inputs.dismiss.send(())
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return weatherList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let daily = weatherList[section]
        return daily.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as! DetailViewCell

        let weather = weatherList[indexPath.section].list[indexPath.row]
        cell.setup(weather)

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weatherList[section].date
    }
}
