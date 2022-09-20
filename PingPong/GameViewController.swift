//
//  GameViewController.swift
//  PingPong
//
//  Created by Мария Хатунцева on 18.09.2022.
//

import UIKit
import SpriteKit
import GameplayKit
import Combine

class GameViewController: UIViewController {
    
    private var store = [AnyCancellable]()
    
    private lazy var background: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "menu")
        imageView.image = image
        imageView.contentMode = .redraw
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Играть", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "orange")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var backButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Назад", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        return button
    }()
    
    private lazy var againButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Заново", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        return button
    }()
    
    private lazy var countStartTimeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 150)
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.textColor = .white
        label.text = "3"
        label.clipsToBounds = true
        label.layer.cornerRadius = 150
        label.alpha = 0
        return label
    }()
    
    private lazy var circle: CircleModel! = {
        let circle = CircleModel(frame: CGRect(x: (view.frame.size.width / 2) - 150, y: (view.frame.size.height / 2) - 150, width: 300, height: 300))
        circle.trackColor = .gray
        circle.progressColor = .systemMint
        circle.applyShadow(cornerRadius: 150)
        circle.alpha = 0
        return circle
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(background)
        view.addSubview(playButton)
        view.addSubview(backButton)
        view.addSubview(againButton)
        view.addSubview(countStartTimeLabel)
        view.addSubview(circle)
        setupConstraints()
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        againButton.addTarget(self, action: #selector(didTapAgainButton), for: .touchUpInside)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @objc private func didTapPlayButton() {
        self.background.alpha = 0
        self.playButton.alpha = 0
        self.backButton.alpha = 1
        self.againButton.alpha = 1
        startCount()
    }
    
    @objc private func didTapBackButton() {
        self.background.alpha = 1
        self.playButton.alpha = 1
        self.backButton.alpha = 0
        self.againButton.alpha = 0
        UserSettings.shared.reset = true
    }
    
    @objc private func didTapAgainButton() {
        UserSettings.shared.reset = true
        startCount()
    }
    
    private func startCount() {
        self.countStartTimeLabel.alpha = 1
        self.circle.alpha = 1
        self.circle.setProgressWithAnimation(duration: 5.1, value: 2)
        let colors: [UIColor] = [.systemIndigo, .systemPink, .systemGreen, .cyan, .systemBlue, .systemRed, .systemBrown, .systemTeal]
        let stopPoint = -1
        Timer.publish(every: 0.7, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .scan(3) { i, _ in i - 1 }
            .prefix(while: { stopPoint <= $0 })
            .sink { [weak self] value in
                self?.countStartTimeLabel.backgroundColor = colors.randomElement()
                let stringValue = String(value)
                if value >= 0 {
                    self?.countStartTimeLabel.text = stringValue
                } else {
                    self?.countStartTimeLabel.alpha = 0
                    self?.circle.alpha = 0
                    self?.countStartTimeLabel.backgroundColor = .orange
                    self?.countStartTimeLabel.text = "3"
                    self?.againButton.setTitle("Заново", for: .normal)
                    UserSettings.shared.reset = true
                }
            }.store(in: &store)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 150),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            againButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            againButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            againButton.widthAnchor.constraint(equalToConstant: 150),
            againButton.heightAnchor.constraint(equalToConstant: 40),
            
            countStartTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countStartTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countStartTimeLabel.widthAnchor.constraint(equalToConstant: 300),
            countStartTimeLabel.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
}
var currentGameType = gameType.medium
