
//  Created by Lyle Resnick on 2016-05-19.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//


class TransactionReportViewModel {
    private var totalDouble = 0.0
    
    var total: String { return String( format: "%.2f", totalDouble) }
    
    func addAmount( amount: Double ) {
        totalDouble += amount
    }
    
    
}