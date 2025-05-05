//
//  MoviesViewController.swift
//  ReelSpin
//
//  Created by mike liu on 2025/5/3.
//


import UIKit

final class MoviesViewController: UIViewController {

    // UI
    private let loader = CircleStrokeView()
    private let posterView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        fetchData()
    }

    private func setupViews() {
        // Loader
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 120),
            loader.heightAnchor.constraint(equalTo: loader.widthAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Content stack (hidden before data)
        posterView.contentMode = .scaleAspectFit
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        overviewLabel.numberOfLines = 0
        overviewLabel.font = .systemFont(ofSize: 15)

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        stack.addArrangedSubview(posterView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(overviewLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func fetchData() {
        loader.animateOnce { [weak self] in
            // 當動畫真正結束時才會呼叫這裡
            guard let self else { return }
            
            // 呼叫 API → 拿到資料 → 顯示電影
            MovieService.shared.fetchPopularMovies { [weak self] result in
                DispatchQueue.main.async {
                    guard let self else { return }
                    switch result {
                    case .success(let movies):
                        // 只挑第一筆有 poster 的
                        let firstWithPoster = movies.first { $0.posterPath != nil }
                        self.show(movie: firstWithPoster)

                    case .failure(let err):
                        print("🔴 API error:", err)
                        // TODO: show error UI
                    }
                }
            }
        }
    }


    private func show(movie: Movie?) {
        loader.isHidden = true
        stack.isHidden  = false

        titleLabel.text = movie?.title
        overviewLabel.text = movie?.overview

        if let path = movie?.posterPath,
           let url  = MovieService.shared.posterURL(path: path) {
            loadImage(url: url)
        }
    }

    // 簡易 image loader
    private func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                print("🔴 image download error:", err)          // DEBUG
                return
            }
            guard
                let http = resp as? HTTPURLResponse,
                (200...299).contains(http.statusCode)
            else {
                print("🔴 bad HTTP code:",
                      (resp as? HTTPURLResponse)?.statusCode ?? -1)   // DEBUG
                return
            }
            guard let data else {
                print("🔴 image data nil")                      // DEBUG
                return
            }
            print("🟢 image downloaded:", data.count, "bytes")  // DEBUG

            DispatchQueue.main.async {
                self.posterView.image = UIImage(data: data)
            }
        }.resume()
    }

}

