
//  Created by Lyle Resnick on 2016-05-19.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

struct TransactionViewModel {
    
    enum Group: String {
        case Authorized
        case Posted
    }
    
    static let groupList: [Group] = [.Authorized, .Posted]
    
    private static let inboundDateFormat = NSDateFormatter()
    private static let outboundDateFormat = NSDateFormatter()
    
    var group: Group { return transaction.group == "A" ? .Authorized : .Posted }
    
    var date: String {
        guard let dateAsDate = TransactionViewModel.inboundDateFormat.dateFromString( transaction.date )
        else {
            NSLog("Format of Transaction Date is incorrect")
            abort()
        }
        return TransactionViewModel.outboundDateFormat.stringFromDate(dateAsDate)
    }
    
    var description: String { return transaction.description }
    
    var amount: String {
        return (transaction.debit == "D" ? transaction.amount : "-" + transaction.amount )
    }
    
    var amountDouble: Double {
        return Double( amount )!
    }
    
    private let transaction: TransactionModel
    
    private var once = dispatch_once_t()

    init?( transaction: TransactionModel? ) {
        guard let transaction = transaction else { return nil }
        dispatch_once(&once) {
            TransactionViewModel.inboundDateFormat.dateFormat = "yyyy'-'MM'-'dd"
            TransactionViewModel.outboundDateFormat.dateFormat = "MMM' 'dd', 'yyyy"
        }
        self.transaction = transaction
    }
    
}