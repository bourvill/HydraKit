//
//  URLSessionProtocol.swift
//  HydraKit
//
//  Created by maxime marinel on 21/06/2017.
//
public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
