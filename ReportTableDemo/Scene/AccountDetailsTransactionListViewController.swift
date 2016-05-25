
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
        transformer.transformTransactions( transactionViewModelGenerator( transactions: authorizedData ), group: .Authorized )
        transformer.transformTransactions( transactionViewModelGenerator( transactions: postedData ), group: .Posted )
        
//        let transformer = MultipleGroupTransactionTransformer( dataSourceDelegate: dataSourceDelegate )
//        transformer.transformTransactions( transactionViewModelGenerator( transactions: allData ), groupList: TransactionViewModel.groupList)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
    }
}

