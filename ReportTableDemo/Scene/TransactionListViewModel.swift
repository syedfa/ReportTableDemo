
//  Created by Lyle Resnick on 2016-05-20.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit


typealias TransactionViewModelGenerator = AnyGenerator<TransactionViewModel>

func transactionViewModelGenerator( transactions transactions: [TransactionModel]) -> TransactionViewModelGenerator {
    
    var generator = transactions.generate()
    
    return AnyGenerator {
        return TransactionViewModel(transaction: generator.next() )
    }
}
