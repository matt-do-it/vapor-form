import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders
import GRPC

struct CassandraConnectCommand: AsyncCommand {
    struct Signature: CommandSignature { }
    
    var help: String {
        "Read sample message"
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
       let conf = GRPCTLSConfiguration.makeClientDefault(compatibleWith: context.application.eventLoopGroup)
        
        let channel = try GRPCChannelPool.with(
                target: .host("81e2a359-c50d-4230-bb7a-ec24766cbc66-us-east1.apps.astra.datastax.com"),
                transportSecurity: .tls(conf),
                eventLoopGroup: context.application.eventLoopGroup
            )
        
        var hpackHeaders = HPACKHeaders()
        hpackHeaders.add(name: "X-Cassandra-Token", value: "AstraCS:eyMhzdIkluucJNIfiepKcRER:22a58d00758057f3d633e75ca63bd198c269cbae8ee8ecacea973f6bd7153d38")
        
        let callOptions = CallOptions(customMetadata: hpackHeaders)
        
        
        let client = Stargate_StargateAsyncClient(channel: channel, defaultCallOptions: callOptions)
       /*
        var query = Stargate_Query()
        query.cql = """
CREATE TABLE default_keyspace.contacts (
   id uuid, 
   name varchar, 
   email varchar, 
   message varchar,
   created_at timestamp,
   updated_at timestamp, 
   PRIMARY KEY (id));
"""
        */
        
        var query = Stargate_Query()
        query.cql = """
INSERT INTO default_keyspace.contacts (id, name, email, messsage, created_at, updated_at) 
            VALUES (UUID(), ?, ?, ?, dateof(now()), dateof(now()))
"""
        
        var name = Stargate_Value()
        name.string = "Matt"

        var email = Stargate_Value()
        email.string = "mail@matt-herold.de"

        var message = Stargate_Value()
        message.string = "help"

        var values = Stargate_Values()
        values.values = [name, email, message]
                
        query.values = values
        
        let response = try await client.executeQuery(query)
        print(response)

    }
}
