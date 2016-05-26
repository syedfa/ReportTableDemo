
//  Created by Lyle Resnick on 2016-05-20.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit


typealias TransactionViewModelGenerator = AnyGenerator<TransactionViewModel>

func transactionViewModelGenerator( transactions transactions: [TransactionModel]) -> TransactionViewModelGenerator {
    
    var index = 0
    
    return AnyGenerator {
        
        guard index < transactions.count else { return nil }
        
        let transactionModel =  transactions[ index ]
        index += 1
        return TransactionViewModel(transaction: transactionModel )
    }
}
