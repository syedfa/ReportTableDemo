//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class SingleGroupTransactionTransformer {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: TransactionListViewModel, group: TransactionViewModel.Group ) {
        
        var transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        dataSourceDelegate.appendHeaderWithTitle(group.rawValue, subtitle: "")
        
        if currentTransaction == nil {
            
            dataSourceDelegate.appendMessage( "\(group.rawValue) Transactions are not currently available. You might want to call us and tell us what you think of that!")
            return
        }
        
        var currentTransactionGroup = TransactionGroupViewModel()
        
        while currentTransaction != nil {
            
            let currentDate = currentTransaction!.date
            dataSourceDelegate.appendSubheaderWithDate(currentDate)
            
            while (currentTransaction != nil) && (currentTransaction!.date == currentDate) {
                
                currentTransactionGroup.addAmount(currentTransaction!.amountDouble)
                dataSourceDelegate.appendDetailWithDescription(currentTransaction!.description, amount: currentTransaction!.amount)
                currentTransaction = transactionStream.next()
            }
            dataSourceDelegate.appendSubfooter()
        }
        dataSourceDelegate.appendFooterWithTotal(currentTransactionGroup.total)
    }
}
