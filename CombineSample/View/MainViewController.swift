//
//  MainViewController.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var prefectureLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!

    func setup(_ weather: PrefectureWeather) {
        iconImageView.image = UIImage(named: weather.icon)
        prefectureLabel.text = weather.name
        tempLabel.text = "\(weather.temp)°"
    }
}

class MainViewController: UITableViewController {
    var presenter: MainViewPresenter?
    var prefectures: [PrefectureWeather] {
        return presenter?.outputs.prefectures ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        presenter?.inputs.fetch.send(())

        let _ = presenter?.outputs.didChange.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell

        let prefecture = prefectures[indexPath.row]
        cell.setup(prefecture)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prefecture = prefectures[indexPath.row]
        presenter?.inputs.showDetail.send(prefecture.id)
    }
}
