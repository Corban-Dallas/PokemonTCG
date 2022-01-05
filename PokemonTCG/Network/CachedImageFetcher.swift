//
//  CachedImageFetcher.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 23.08.2021.
//
import Foundation
import Combine
import UIKit

/// CachedImageFetcher  reads image from cache or fetches it from network if needed.
/// Cache is implemented by custome cached URLSession and is unique for each
/// CachedImageFetcher instance.
public class CachedImageFetcher {
    //
    // MARK: - Singleton
    //
    static let shared = CachedImageFetcher()
    //
    // MARK: - Parameters
    //
    private let cachedSession: URLSession
    private let cache: URLCache
    //
    // MARK: - Initialization
    //
    private init(memoryCapacity: Int = 10_000_000, diskCapacity: Int = 1_000_000_000) {
        // Create URLCache
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("PokemonLibraryCache")
        self.cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, directory: diskCacheURL)
        
        // Create cached URLSession
        let config = URLSessionConfiguration.default
        config.urlCache = self.cache
        self.cachedSession = URLSession(configuration: config)
        
        print("Current cache disk usage: \(cache.currentDiskUsage)")
    }
    //
    // MARK: Public methods
    //
    // Get image from network or cache.
    func fetchImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) =  try await cachedSession.data(from: url)
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Error> {
        let request = URLRequest(url: url)
        return cachedSession
            .dataTaskPublisher(for: request)
            .tryMap { result -> UIImage? in
                if let image = UIImage(data: result.data) {
                    return image
                }
                else { return nil }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Returns UIImage if it is already in chache
    func getImageFromCache(url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        guard let response = cache.cachedResponse(for: request) else { return nil }
        return UIImage(data: response.data)
    }
    
    // Clear cache
    func clearCache() {
        cache.removeAllCachedResponses()
    }
}
