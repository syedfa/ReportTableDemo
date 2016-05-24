
//  Created by Lyle Resnick on 2016-05-06.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class AccountDetailsTransactionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSourceDelegate = AccountDetailsTransactionListDataSourceDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transformer = SingleGroupTransactionTransformer( dataSourceDelegate: dataSourceDelegate )
        transformer.transformTransactions( TransactionListViewModel( transactions: authorizedData ), group: .Authorized )
        transformer.transformTransactions( TransactionListViewModel( transactions: postedData ), group: .Posted )
        
//        let transformer = MultipleGroupTransactionTransformer( dataSourceDelegate: dataSourceDelegate )
//        transformer.transformTransactions( TransactionListViewModel( transactions: allData ), groupList: TransactionViewModel.groupList)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
    }
}

