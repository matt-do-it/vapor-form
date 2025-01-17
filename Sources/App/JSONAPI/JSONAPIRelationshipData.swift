import Vapor


struct JSONAPIRelationshipData : Content  {
    var type : String
    var id : UUID
}

