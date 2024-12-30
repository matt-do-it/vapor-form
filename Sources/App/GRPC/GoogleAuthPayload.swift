//
//  GoogleAuthPayload.swift
//  VaporForm
//
//  Created by Matt Herold on 29.12.24.
//
import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders

struct GoogleAuthPayload: JWTPayload {
    var iss: IssuerClaim
    var scope: String
    
    var aud: AudienceClaim
    var sub: SubjectClaim
    var email: SubjectClaim
    
    var exp: ExpirationClaim
    var iat: IssuedAtClaim
    
    func verify(using key: some JWTAlgorithm) throws {
        try self.exp.verifyNotExpired()
    }
}
