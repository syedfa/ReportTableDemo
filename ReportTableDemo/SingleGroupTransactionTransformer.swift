//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class SingleGroupTransactionTransformer {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: [TransactionModel], group: TransactionModel.Group ) {
        
        var transactionStream = data.generate()
        var currentTransactionModel = transactionStream.next()
        
        dataSourceDelegate.appendHeaderWithTitle(group.rawValue, subtitle: "")
        
        if currentTransactionModel == nil {
            
            dataSourceDelegate.appendMessage( "\(group.rawValue) TransactionModels are not currently available. You might want to call us and tell us what you think of that!")
            return
        }
        
        var total = 0.0
        while currentTransactionModel != nil {
            
            let curDate = currentTransactionModel!.date
            dataSourceDelegate.appendSubheaderWithDate(curDate)
            
            while (currentTransactionModel != nil) && (currentTransactionModel!.date == curDate) {
                
                if currentTransactionModel!.debit == "D" {
                    total += currentTransactionModel!.amount
                }
                else {
                    total -= currentTransactionModel!.amount
                }
                dataSourceDelegate.appendDetailWithDescription(currentTransactionModel!.description, amount: currentTransactionModel!.amount, debit: currentTransactionModel!.debit)
                currentTransactionModel = transactionStream.next()
            }
            dataSourceDelegate.appendSubfooter()
        }
        dataSourceDelegate.appendFooterWithTotal(total)
    }
}
