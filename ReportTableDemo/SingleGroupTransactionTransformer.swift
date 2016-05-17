//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class SingleGroupTransactionTransformer {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: [Transaction], group: Transaction.Group ) {
        
        var transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        dataSourceDelegate.appendHeaderWithTitle(group.rawValue, subtitle: "")
        
        if currentTransaction == nil {
            
            dataSourceDelegate.appendMessage( "\(group.rawValue) Transactions are not currently available. You might want to call us and tell us what you think of that!")
            return
        }
        
        var total = 0.0
        while currentTransaction != nil {
            
            let curDate = currentTransaction!.date
            dataSourceDelegate.appendSubheaderWithDate(curDate)
            
            while (currentTransaction != nil) && (currentTransaction!.date == curDate) {
                
                if currentTransaction!.debit == "D" {
                    total += currentTransaction!.amount
                }
                else {
                    total -= currentTransaction!.amount
                }
                dataSourceDelegate.appendDetailWithDescription(currentTransaction!.description, amount: currentTransaction!.amount, debit: currentTransaction!.debit)
                currentTransaction = transactionStream.next()
            }
            dataSourceDelegate.appendSubfooter()
        }
        dataSourceDelegate.appendFooterWithTotal(total)
    }
}
