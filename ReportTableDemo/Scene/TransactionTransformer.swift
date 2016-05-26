//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class TransactionTransformer {
    
    private let output: TransactionTransformerOutput
    
    init( output: TransactionTransformerOutput ) {
        self.output = output
    }
    
    func transformTransactions( data: AnyGenerator<TransactionViewModel>, group: TransactionViewModel.Group ) {
        
        let transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        output.appendHeader(group.rawValue, subtitle: "")
        
        if currentTransaction == nil {
            
            output.appendMessage( "\(group.rawValue) Transactions are not currently available. You might want to call us and tell us what you think of that!")
            return
        }
        
        var currentTransactionGroup = TransactionGroupViewModel()
        
        while currentTransaction != nil {
            
            let currentDate = currentTransaction!.date
            output.appendSubheader(currentDate)
            
            while (currentTransaction != nil) && (currentTransaction!.date == currentDate) {
                
                currentTransactionGroup.addAmount(currentTransaction!.amountDouble)
                output.appendDetail(currentTransaction!.description, amount: currentTransaction!.amount)
                currentTransaction = transactionStream.next()
            }
            output.appendSubfooter()
        }
        output.appendFooter(currentTransactionGroup.total)
    }
}
