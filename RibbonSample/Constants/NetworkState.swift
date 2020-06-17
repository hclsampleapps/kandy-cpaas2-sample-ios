
import UIKit

class NetworkState {
    class func isConnected() ->Bool {
        if Reachability.isConnectedToNetwork(){
            return true
        }else{
            return false
        }
    }
}
