import Foundation
import UIKit

class TableViewController: UITableViewController {
    var _refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _refreshControl = UIRefreshControl()
        _refreshControl.addTarget(self, action: #selector(TableViewController.updateData(_:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = _refreshControl
        
        AppSettingsManager.getInstance().masterViewControllerObserver = self
        CityCollectionManager.getInstance().setMasterPageObserver(self)
        CityCollectionManager.getInstance().tryLoadData()
        updateLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.setDetailItem(CityCollectionManager.getInstance().getItem(indexPath.row), autoUpdate: false)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityCollectionManager.getInstance().getItemsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            fatalError("Unable to get table view cell")
        }
        
        cell.configureWith(CityCollectionManager.getInstance().getItem(indexPath.row))
        return cell
    }
    
    @objc func updateData(_ sender: UIRefreshControl) {
        let cityCollectionManager = CityCollectionManager.getInstance()
        
        if (cityCollectionManager.getItemsCount() > 0) {
            cityCollectionManager.loadWeather()
        } else {
            cityCollectionManager.tryLoadData()
        }
        
        _refreshControl.endRefreshing()
    }
}

extension TableViewController: CollectionItemsKeeper {
    func collectionUpdateAfter() {
        self.tableView.reloadData()
    }
}

extension TableViewController: SettingsObserver {
    func updateLanguage() {
        title = AppSettingsManager.getInstance().localizeString(key: "MASTER_VIEW_CONTROLLER_TITLE")
    }
    
    func updateFont() {
        self.tableView.reloadData()
    }
}
