//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class MultipleGroupTransactionTransformer {
    
    private let output: TransactionTransformerOutput
    
    init( output: TransactionTransformerOutput ) {
        self.output = output
    }
    
    func transformTransactions( data: AnyGenerator<TransactionViewModel>, groupList: [TransactionViewModel.Group] ) {
        
        var groupStream = groupList.generate()
        var currentGroup = groupStream.next()
        
        let transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        var minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )

        while minGroup != nil {
            
            output.appendHeader(currentGroup!.rawValue, subtitle: "")
            
            if (currentTransaction == nil) || (minGroup != currentTransaction!.group) {
                
                output.appendMessage( "\(currentGroup!.rawValue) Transactions are not currently Available. You might want to call us and tell us what you think of that!")
                currentGroup = groupStream.next()
                minGroup = determineMinGroup( currentGroup, transaction: currentTransaction )
            }
            else {
            
                var currentTransactionGroup = TransactionGroupViewModel()
                while (currentTransaction != nil) && ( currentTransaction!.group == minGroup  ){
                    
                    let currentDate = currentTransaction!.date
                    output.appendSubheader(currentDate)
                    
                    while (currentTransaction != nil) && (currentTransaction!.group == minGroup) && (currentTransaction!.date == currentDate) {
                        
                        currentTransactionGroup.addAmount(currentTransaction!.amountDouble)
                        output.appendDetail(currentTransaction!.description, amount: currentTransaction!.amount)
                        
                        currentTransaction = transactionStream.next()
                    }
                    output.appendSubfooter()
                }
                output.appendFooter(currentTransactionGroup.total)
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
