
public protocol HydraObject {
    var hydraId: String {get}
    init(hydra:[String: Any])
    static func hydraPoint() -> String
}
