//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class MultipleGroupTransactionTransformer {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: TransactionListViewModel, groupList: [TransactionViewModel.Group] ) {
        
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
            
                var currentTransactionGroup = TransactionGroupViewModel()
                while (currentTransaction != nil) && ( currentTransaction!.group == minGroup  ){
                    
                    let currentDate = currentTransaction!.date
                    dataSourceDelegate.appendSubheaderWithDate(currentDate)
                    
                    while (currentTransaction != nil) && (currentTransaction!.group == minGroup) && (currentTransaction!.date == currentDate) {
                        
                        currentTransactionGroup.addAmount(currentTransaction!.amountDouble)
                        dataSourceDelegate.appendDetailWithDescription(currentTransaction!.description, amount: currentTransaction!.amount)
                        
                        currentTransaction = transactionStream.next()
                    }
                    dataSourceDelegate.appendSubfooter()
                }
                dataSourceDelegate.appendFooterWithTotal(currentTransactionGroup.total)
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
        }
    }
    
    func determineMinGroup( group: TransactionViewModel.Group?, transaction: TransactionViewModel? ) -> TransactionViewModel.Group? {
        
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
