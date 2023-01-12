//
//  SchoolSATDetailsViewController.swift
//  NYCSchools
//
//  Created by Nicholas Kraft on 1/11/23.
//

import UIKit

class SchoolSATDetailsViewController: UIViewController {
    static let storyboardName: String = "Main"
    
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    private(set) var dataSource: SATScoreQuery?
    
    static func newViewController(withDataSource dataSource: SATScoreQuery) -> SchoolSATDetailsViewController? {
        let storyboard = UIStoryboard.init(name: Self.storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SchoolSATDetailsViewController.self))
        
        guard let viewController = viewController as? SchoolSATDetailsViewController else {
            return nil
        }
        
        viewController.dataSource = dataSource
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dataSource = dataSource else {
            return
        }
        
        title = dataSource.schoolName()
        
        mathLabel.text = dataSource.mathAverage()
        readingLabel.text = dataSource.criticalReadingAverage()
        writingLabel.text = dataSource.writingAverage()
        
        if let numberOfTestTakers = dataSource.numberOfTestTakers() {
            bottomLabel.text = "Scores are the average of \(numberOfTestTakers) student(s)"
        }
    }
}
