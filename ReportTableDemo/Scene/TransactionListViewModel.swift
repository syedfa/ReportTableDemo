
//  Created by Lyle Resnick on 2016-05-20.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit


struct TransactionViewModelSequence: SequenceType {
    
    let transactions: [TransactionModel]
    
    func generate() -> TransactionViewModelGenerator {
        return TransactionViewModelGenerator (transactions: transactions )
    }
}

struct TransactionViewModelGenerator: GeneratorType {
    
    private var transactions: [TransactionModel]
    private var index = 0
    
    init( transactions: [TransactionModel] ) {
        self.transactions = transactions
    }
    
    mutating func next() -> TransactionViewModel? {
        
        guard index < transactions.count else { return nil }
        
        let transactionModel =  transactions[ index ]
        index += 1
        return TransactionViewModel(transaction: transactionModel )
    }
}
