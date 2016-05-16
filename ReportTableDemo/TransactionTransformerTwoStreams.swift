//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit



class TransactionTransformerTwoStreams {
    
    private let dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate
    
    private var index = 0
    private var data: [Transaction]!

    init( dataSourceDelegate: AccountDetailsTransactionListDataSourceDelegate ) {
        self.dataSourceDelegate = dataSourceDelegate
    }
    
    
    func transformTransactions( data: [Transaction], title: String ) {
        
        dataSourceDelegate.appendHeaderWithTitle(title, subtitle: "")
        
        var currentTransaction = firstTransaction( data: data )
        
        if currentTransaction == nil {
            dataSourceDelegate.appendMessage( "\(title) are not currently Available. You might want to call us and tell us what you think ")
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
                currentTransaction = nextTransaction()
            }
            dataSourceDelegate.appendSubfooter()
        }
        dataSourceDelegate.appendFooterWithTotal(total)
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
}
