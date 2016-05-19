//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class MultipleGroupTransactionTransformer {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: [TransactionModel], groupList: [TransactionModel.Group] ) {
        
        var groupStream = groupList.generate()
        var currentGroup = groupStream.next()
        
        var transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        var minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )

        while minGroup != nil {
            
            dataSourceDelegate.appendHeaderWithTitle(currentGroup!.rawValue, subtitle: "")
            
            if (currentTransaction == nil) || (minGroup != currentTransaction!.group) {
                
                dataSourceDelegate.appendMessage( "\(currentGroup!.rawValue) Transactions are not currently Available. You might want to call us and tell us what you think of that!")
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
            else {
            
                var total = 0.0
                while (currentTransaction != nil) && ( currentTransaction!.group == minGroup  ){
                    
                    let curDate = currentTransaction!.date
                    dataSourceDelegate.appendSubheaderWithDate(curDate)
                    
                    while (currentTransaction != nil) && (currentTransaction!.group == minGroup) && (currentTransaction!.date == curDate) {
                        
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
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
        }
    }
    
    func determineMinGroup( group: TransactionModel.Group?, transaction: TransactionModel? ) -> TransactionModel.Group? {
        
        if (group == nil) && (transaction == nil) {
            return nil
        }
        else if group == nil {
            return transaction!.group
        }
        else if transaction == nil {
            return group
        }
        else {
            return (group!.rawValue < transaction!.group.rawValue) ? group : transaction!.group
        }
    }
}
