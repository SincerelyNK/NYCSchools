//
//  SchoolListViewController.swift
//  NYCSchools
//
//  Created by Nicholas Kraft on 1/11/23.
//

import UIKit

class SchoolListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: SchoolDirectoryQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SchoolDirectoryQuery.newSchoolQuery({ [weak self] (results: SchoolDirectoryQuery) in
            guard let self = self else {
                return
            }
            self.dataSource = results
            self.tableView.reloadData()
        })
    }
}

extension SchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SchoolListTableViewCell.self), for: indexPath) as? SchoolListTableViewCell {
            if let schoolNameString: String = dataSource?.schoolName(forIndex: indexPath.item) {
                cell.schoolName.text = schoolNameString
            }
            return cell
        }
        assert(false, "A table view cell could not be allocated.")
        return UITableViewCell.init()
    }
}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dbnString: String = dataSource?.dbn(forIndex: indexPath.item) as? String {
            SATScoreQuery.satResultsQuery(forDBN: dbnString, { [weak self] (results: SATScoreQuery) in
                guard let self = self else {
                    return
                }
                if (results.error == nil && results.data != nil) {
                    if let schoolSATDetailsViewController = SchoolSATDetailsViewController.newViewController(withDataSource: results) {
                        self.navigationController?.pushViewController(schoolSATDetailsViewController, animated: true)
                    }
                }
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
