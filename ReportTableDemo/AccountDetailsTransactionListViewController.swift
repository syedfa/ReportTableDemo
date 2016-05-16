
//  Created by Lyle Resnick on 2016-05-06.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class AccountDetailsTransactionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSourceDelegate = AccountDetailsTransactionListDataSourceDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let transformer = SingleGroupTransactionTransformer( dataSourceDelegate: dataSourceDelegate )
//        transformer.transformTransactions( authorizedData, title: "Authorized" )
//        transformer.transformTransactions( postedData, title: "Posted" )
        
        let transformer = MultipleGroupTransactionTransformer( dataSourceDelegate: dataSourceDelegate )
        transformer.transformTransactions(allData, groupList: groupList)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
    }
}

