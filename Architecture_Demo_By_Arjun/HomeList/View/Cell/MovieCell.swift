//
//  MovieCell.swift
//  Architecture_Demo_By_Arjun
//
//  Created by Arjun Thakur on 16/11/24.
//

import UIKit

class MovieCell: UITableViewCell {
    
    lazy var customView: UIView = {[unowned self] in
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var titleLabel: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        label.textColor = .white
        return label
    }()
    
    lazy var ratingView: RatingView = { [unowned self] in
        var view = RatingView(frame: CGRect(x: 00, y: 0, width: 38, height: 55))
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var movieLogo: UIImageView = { [unowned self] in
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        return imgView
    }()

    static let identifier = "MovieCell"
    
    private struct Constants {
        //keys
        struct Keys {
            static let titleMovie : String = "title"
            static let releaseDate : String = "release_date"
            static let voteAverage : String = "vote_average"
            static let runTime : String = "runtime"
        }
        
        //date format
        struct DateFormat {
            static let inputFormatter : String = "YYYY-MM-dd"
            static let outputFormatter : String = "MMM dd, YYYY"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUIElementsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUIElementsConstraints() {
        contentView.addSubview(customView)
        let constantSpacing = 10.0
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.spacing = 10
        hStackView.distribution = .fill
        
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.spacing = 5
        vStackView.distribution = .fill

        customView.addSubview(hStackView)
        hStackView.addArrangedSubview(movieLogo)
        hStackView.addArrangedSubview(vStackView)
        hStackView.addArrangedSubview(ratingView)
        
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(releaseDateLabel)
        vStackView.addArrangedSubview(UIView())
                
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constantSpacing),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(constantSpacing)),
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constantSpacing),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(constantSpacing)),
            
            hStackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: constantSpacing),
            hStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -(constantSpacing)),
            hStackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: constantSpacing),
            hStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -(constantSpacing)),
            
            movieLogo.heightAnchor.constraint(equalToConstant: 55),
            movieLogo.widthAnchor.constraint(equalToConstant: 55),
            
            ratingView.heightAnchor.constraint(equalToConstant: 55),
            ratingView.widthAnchor.constraint(equalToConstant: 38),
        ])
    }
    
    //MARK: - Public functions
    func configureCellElements(movieDictionary: [String: Any]) {
        //Update UI
        self.backgroundColor = .clear
        
        //Update Data
        titleLabel.text = movieDictionary[Constants.Keys.titleMovie] as? String ?? ""
        releaseDateLabel.text = updateReleaseDate(movieDictionary: movieDictionary)
        
        //update percentage
        let voteAverage : Double = movieDictionary[Constants.Keys.voteAverage] as? Double ?? 0
        ratingView.updateCirclePercentage(percent: voteAverage)
    }
    
    private func updateReleaseDate(movieDictionary: [String: Any]) -> String {
        //release date
        let releaseDateString = movieDictionary["release_date"] as? String ?? "" //"2024-11-08"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.DateFormat.inputFormatter  //"YYYY-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constants.DateFormat.outputFormatter
        
        guard let showDate = inputFormatter.date(from: releaseDateString) else { return "NA"}
        let movieReleaseDate = outputFormatter.string(from: showDate)
        
        //Runtime value
        let movieRunTime = movieDictionary[Constants.Keys.runTime] as? Int ?? 0
        let (hour, minutes) = minutesToHours(minutes: movieRunTime)
        let runtimeString = movieRunTime > 0 ? "\(hour)h \(minutes)m" : "NA"
        
        return movieReleaseDate + " - " + runtimeString
    }
    
    private func minutesToHours (minutes : Int) -> (Int, Int) {
      return (minutes / 60, (minutes % 60))
    }
    
    func configureImage( _ image : UIImage) {
        movieLogo.image = image
    }
}
