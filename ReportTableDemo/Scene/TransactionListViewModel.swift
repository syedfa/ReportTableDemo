
//  Created by Lyle Resnick on 2016-05-20.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit


struct TransactionListViewModel: GeneratorType {
    
    private var transactionStream: IndexingGenerator<[TransactionModel]>
    
    init( transactions: [TransactionModel] ) {
        transactionStream = transactions.generate()
    }
    
    mutating func next() -> TransactionViewModel? {
        return TransactionViewModel(transaction: transactionStream.next() )
    }
    
}
