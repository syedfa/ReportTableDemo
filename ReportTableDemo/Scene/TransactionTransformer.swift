//  Created by Lyle Resnick on 2016-05-13.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

class TransactionTransformer {
    
    private let output: TransactionTransformerOutput
    
    init( output: TransactionTransformerOutput ) {
        self.output = output
    }
    
    func transformTransactions( data: TransactionViewModelGenerator, group: TransactionViewModel.Group ) {
        
        let transactionStream = data.generate()
        var currentTransaction = transactionStream.next()
        
        output.appendHeader(group.rawValue, subtitle: "")
        
        if currentTransaction == nil {
            
            output.appendMessage( "\(group.rawValue) Transactions are not currently available. You might want to call us and tell us what you think of that!")
            return
        }
        
        let transactionReport = TransactionReportViewModel()
        
        while let localCurrentTransaction = currentTransaction {
            
            let currentDate = localCurrentTransaction.date
            output.appendSubheader(currentDate)
            
            while let localCurrentTransaction = currentTransaction where localCurrentTransaction.date == currentDate {
                
                localCurrentTransaction.addAmountToReport(transactionReport)
                output.appendDetail(localCurrentTransaction.description, amount: localCurrentTransaction.amount)
                currentTransaction = transactionStream.next()
            }
            output.appendSubfooter()
        }
        output.appendFooter(transactionReport.total)
    }
}
