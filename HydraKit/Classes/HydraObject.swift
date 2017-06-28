//
//  HydraObject
//  HydraKit
//
//  Created by maxime marinel on 26/06/2017.
//
import Foundation

/**
 Object passed to Hydra method must be conform to this protocol
 */
public protocol HydraObject {
    var hydraId: String {get}
    /**
     In this method you define how your object will be hydrated
     Typically the dictionnary is the "hydra:member" json
     */
    init(hydra:[String: Any])
    /**
     This method define the endpoint api to retrieve ressource
     */
    static func hydraPoint() -> String
}
