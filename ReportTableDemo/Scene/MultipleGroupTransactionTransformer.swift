//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class MultipleGroupTransactionTransformer {
    
    private let output: TransactionTransformerOutput
    
    init( output: TransactionTransformerOutput ) {
        self.output = output
    }
    
    func transformTransactions( data: TransactionViewModelGenerator, groupList: [TransactionViewModel.Group] ) {
        
        var groupStream = groupList.generate()
        var currentGroup = groupStream.next()
        
        let transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        var minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )

        while let localMinGroup = minGroup {
            
            output.appendHeader(localMinGroup.rawValue, subtitle: "")
            
            if (currentTransaction == nil) || (localMinGroup != currentTransaction!.group) {
                
                output.appendMessage( "\(currentGroup!.rawValue) Transactions are not currently Available. You might want to call us and tell us what you think of that!")
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
            else {
            
                let transactionReport = TransactionReportViewModel()
                while let localCurrentTransaction = currentTransaction where localCurrentTransaction.group == localMinGroup {
                    
                    let currentDate = localCurrentTransaction.date
                    output.appendSubheader(currentDate)
                    
                    while let localCurrentTransaction = currentTransaction where (localCurrentTransaction.group == localMinGroup) && (localCurrentTransaction.date == currentDate) {
                        
                        localCurrentTransaction.addAmountToReport(transactionReport)
                        output.appendDetail(localCurrentTransaction.description, amount: localCurrentTransaction.amount)
                        
                        currentTransaction = transactionStream.next()
                    }
                    output.appendSubfooter()
                }
                output.appendFooter(transactionReport.total)
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
