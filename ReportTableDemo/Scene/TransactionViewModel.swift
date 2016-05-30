
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
    
    
     private static func dateFormat( format: String ) -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    private static let inboundDateFormat = TransactionViewModel.dateFormat( "yyyy'-'MM'-'dd" )
    private static let outboundDateFormat = TransactionViewModel.dateFormat( "MMM' 'dd', 'yyyy" )
    
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
    
    private let transaction: TransactionModel
    
    init?( transaction: TransactionModel? ) {
        guard let transaction = transaction else { return nil }
        self.transaction = transaction
    }
    
    func addAmountToReport( reportModel: TransactionReportViewModel )  {
        reportModel.addAmount(Double( amount )!)
    }
    
}