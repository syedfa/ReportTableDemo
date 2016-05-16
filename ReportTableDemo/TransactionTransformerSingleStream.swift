//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit



class TransactionTransformerSingleStream {
    
    private var groupList: [Transaction.TransactionType] = [.Authorized, .Posted]
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    private var index = 0
    private var data: [Transaction]!
    
    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    func transformTransactions( data: [Transaction] ) {
        
        var groupStream = groupList.generate()
        
        var currentGroup = groupStream.next()
        var currentTransaction = firstTransaction( data: data )
        var minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )

        while minGroup != nil {
            
            dataSourceDelegate.appendHeaderWithTitle(currentGroup!.rawValue, subtitle: "")
            
            if (currentTransaction == nil) || (minGroup != currentTransaction!.type) {
                dataSourceDelegate.appendMessage( "\(currentGroup!.rawValue) Transactions are not currently Available. You might want to call us and tell us what you think ")
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )

            }
            else {
            
                var total = 0.0
                while (currentTransaction != nil) && ( currentTransaction!.type == minGroup  ){
                    
                    let curDate = currentTransaction!.date
                    dataSourceDelegate.appendSubheaderWithDate(curDate)
                    
                    while (currentTransaction != nil) && (currentTransaction!.type == minGroup) && (currentTransaction!.date == curDate) {
                        
                        if currentTransaction!.debit == "D" {
                            total += currentTransaction!.amount
                        }
                        else {
                            total -= currentTransaction!.amount
                        }
                        dataSourceDelegate.appendDetailWithDescription(currentTransaction!.description, amount: currentTransaction!.amount, debit: currentTransaction!.debit)
                        
                        currentTransaction = nextTransaction()
                    }
                    dataSourceDelegate.appendSubfooter()
                }
                dataSourceDelegate.appendFooterWithTotal(total)
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
        }
    }
    
    
    private func firstTransaction( data data: [Transaction] ) -> Transaction? {
        
        index = 0
        self.data = data
        return nextTransaction()
    }
    
    
    // before ++ was deprecated, one could have written
    // currentTransaction = (index < data.count) ? data[index++] : nil
    
    private func nextTransaction() -> Transaction? {
        var transaction: Transaction? = nil
        
        if index < data.count {
            transaction = data[index]
            index += 1
        }
        return transaction
    }
    
    
    func determineMinGroup( group: Transaction.TransactionType?, transaction: Transaction? ) -> Transaction.TransactionType? {
        
        if (group == nil) && (transaction == nil) {
            return nil
        }
        else if group == nil {
            return transaction!.type
        }
        else if transaction == nil {
            return group
        }
        else {
            if group!.rawValue < transaction!.type.rawValue {
                return group
            }
            else {
                return transaction!.type
            }
        }
    }
}
