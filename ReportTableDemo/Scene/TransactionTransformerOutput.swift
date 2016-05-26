
//  Created by Lyle Resnick on 2016-05-25.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//


protocol TransactionTransformerOutput {
    func appendHeader( title: String , subtitle: String )
    func appendSubheader( date: String )
    func appendDetail( description: String, amount: String)
    func appendSubfooter()
    func appendFooter( total: String)
    func appendMessage( message: String)

    
}
