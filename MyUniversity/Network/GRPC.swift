//
//  GRPC.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 5. 16..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import ProtoRPC

class GRPC{
    static let sharedInstance = GRPC()
    //let HOST = "osegyuns-MacBook-Pro.local:9000"
    //let image_endpoint = "osegyuns-MacBook-Pro.local:9001"
    let HOST = "52.9.201.178:9000"
    let image_endpoint = "52.9.201.178:9001"
    var user : Main!
    var authorizedUser: AuthorizedMain!
    var rpcCall : GRPCProtoCall!
    init(){
        
        //if this is not set, GRPC doesn't work
        //GRPCCall.useInsecureConnections(forHost: HOST)
        GRPCProtoCall.useInsecureConnections(forHost: HOST)
        user = Main(host: HOST)
        authorizedUser = AuthorizedMain(host: HOST)
        
    }
}
/*//chatViewMessage's getMessage()
 let method = GRPCProtoMethod(package: "proto.main", service: "AuthorizedMain", method: "ChatStream")
 let request = ChatStreamRequest()
 request.conversationId = Int64((object?.conversation_id)!)
 request.receiverId = Int64(userDefault.integer(forKey: "user_id"))
 
 requestsWriter = GRXWriter(value: request.data())
 
 call = GRPCCall(host: GRPC.sharedInstance.HOST, path: method?.httpPath, requestsWriter: requestsWriter)!
 
 call.start(with: GRXWriteable { response, error in
 if let response = response as? NSData {
 self.log.debug("3. Received response:\n\(response)")
 } else {
 self.log.debug("3. Finished with error: \(error!)")
 }
 self.log.debug("3. Response headers: \(self.call.responseHeaders)")
 self.log.debug("3. Response trailers: \(self.call.responseTrailers)")
 })
 */
