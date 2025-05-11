import Foundation
final class MovieService {

    static let shared = MovieService()
    private init() {}

    private let apiKey = ""
    private let session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.waitsForConnectivity = true            // iOS 13+: 若無網路會等
        cfg.httpMaximumConnectionsPerHost = 2
        if #available(iOS 15.0, *) {
            cfg.allowsConstrainedNetworkAccess = true
            cfg.allowsExpensiveNetworkAccess   = true
        }
        return URLSession(configuration: cfg)
    }()

    func fetchPopularMovies(
        retry left: Int = 2,
        completion: @escaping (Result<[Movie], Error>) -> Void
    ) {

        let urlStr =
            "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlStr) else { return }

        session.dataTask(with: url) { data, resp, err in
            if let err = err as NSError? {
                // 對 -1005/-1001 的 network error 做遞迴重試
                if left > 0, err.domain == NSURLErrorDomain,
                   [NSURLErrorNetworkConnectionLost,
                    NSURLErrorTimedOut].contains(err.code) {

                    print("🔄 retry left:", left, "error:", err.code)
                    self.fetchPopularMovies(retry: left - 1, completion: completion)
                    return
                }
                return completion(.failure(err))
            }

            guard let data,
                  let http = resp as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                return completion(.failure(
                    NSError(domain: "HTTP", code: (resp as? HTTPURLResponse)?.statusCode ?? -1)
                ))
            }

            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                print("🟢 fetched \(response.results.count) movies")       // DEBUG
                completion(.success(response.results))
            } catch {
                print("🔴 JSON decode error:", error)                     // DEBUG
                completion(.failure(error))
            }
        }.resume()
    }
    
    // 取海報全尺寸 URL（TMDB 建議 domains） :contentReference[oaicite:1]{index=1}
    func posterURL(path: String, width: Int = 500) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }
}
