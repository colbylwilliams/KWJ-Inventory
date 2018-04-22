//
//  CustomVisionModels.swift
//  Inventory
//
//  Created by Colby L Williams on 4/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

public struct ApiKeys: Codable {
    public let TrainingKeys: KeyPair?
    public let PredictionKeys: KeyPair?    
}

public struct KeyPair: Codable {
    public let PrimaryKey: String?
    public let SecondaryKey: String?    
}

public struct Account: Codable {
    public let UserName: String?
    public let Email: String?
    public let Keys: ApiKeys?
    public let Quotas: AccountQuota?    
}

public struct AccountQuota: Codable {
    public let Tier: String?
    public let Projects: Quota?
    public let Predictions: Quota?
    public let PerProject: [PerProjectQuota]?    
}

public struct Quota: Codable {
    public let Total: Int
    public let Used: Int
    public let TimeUntilReset: String?    
}

public struct PerProjectQuota: Codable {
    public let ProjectId: String
    public let Iterations: Quota?
    public let Images: Quota?
    public let Tags: Quota?    
}

public struct Domain: Codable {
    public let Id: String
    public let Name: String?
    public let Exportable: Bool    
}

public struct Image: Codable {
    public let Id: String
    public let Created: Date
    public let Width: Int
    public let Height: Int
    public let ImageUrl: URL?
    public let ThumbnailUri: URL?
    public let Tags: [ImageTag]?
    public let Predictions: [PredictionTag]?    
}

public struct ImageTag: Codable {
    public let TagId: String
    public let Created: Date    
}

public struct PredictionTag: Codable {
    public let TagId: String
    public let Tag: String?
    public let Probability: Float    
}

public struct ImageCreateSummary: Codable {
    public let IsBatchSuccessful: Bool
    public let Images: [ImageCreateResult]?    
}

public struct ImageCreateResult: Codable {
    public let SourceUrl: URL?
    public let Status: Status
    public let Image: Image?
    
    public enum Status: String, Codable {
        case ok = "OK"
        case okDuplicate = "OKDuplicate"
        case errorSource = "ErrorSource"
        case errorImageFormat = "ErrorImageFormat"
        case errorImageSize = "ErrorImageSize"
        case errorStorage = "ErrorStorage"
        case errorLimitExceed = "ErrorLimitExceed"
        case errorTagLimitExceed = "ErrorTagLimitExceed"
        case errorUnknown = "ErrorUnknown"
    }    
}

public struct ImageFileCreateBatch: Codable {
    public let Images: [ImageFileCreateEntry]?
    public let TagIds: [String]?    
}

public struct ImageFileCreateEntry: Codable {
    public let Name: String?
    public let Contents: String?
    public let TagIds: [String]?    
}

public struct ImageUrlCreateBatch: Codable {
    public let Images: [ImageUrlCreateEntry]?
    public let TagIds: [String]?    
}

public struct ImageUrlCreateEntry: Codable {
    public let Url: URL?
    public let TagIds: [String]?    
}

public struct ImageIdCreateBatch: Codable {
    public let Images: [ImageIdCreateEntry]?
    public let TagIds: [String]?    
}

public struct ImageIdCreateEntry: Codable {
    public let Id: String?
    public let TagIds: [String]?    
}

public struct ImageTagCreateBatch: Codable {
    public let Tags: [ImageTagCreateEntry]?    
}

public struct ImageTagCreateEntry: Codable {
    public let ImageId: String
    public let TagId: String    
}


public struct ImageTagCreateSummary: Codable {
    public let Created: [ImageTagCreateEntry]?
    public let Duplicated: [ImageTagCreateEntry]?
    public let Exceeded: [ImageTagCreateEntry]?    
}

public struct PredictionQueryToken: Codable {
    public let Session: String?
    public let Continuation: String?
    public let MaxCount: Int
    public let OrderBy: OrderBy
    public let Tags: [PredictionQueryTag]?
    public let IterationId: String?
    public let StartTime: Date?
    public let EndTime: Date?
    public let Application: String?
    
    public enum OrderBy: String, Codable {
        case newest     = "Newest"
        case oldest     = "Oldest"
        case suggested  = "Suggested"
    }    
}

public enum OrderBy: String, Codable {
    case newest     = "Newest"
    case oldest     = "Oldest"
}

public struct PredictionQueryTag: Codable {
    public let Id: String
    public let MinThreshold: Float
    public let MaxThreshold: Float    
}

public struct PredictionQuery: Codable {
    public let Results: [Prediction]?
    public let Token: PredictionQueryToken?    
}

public struct Prediction: Codable {
    public let Id: String
    public let Project: String
    public let Iteration: String
    public let Created: Date
    public let Predictions: [PredictionTag]?
    public let ImageUri: URL?
    public let ThumbnailUri: URL?    
}

public struct ImageUrl: Codable {
    public let Url: URL?    
}

public struct ImagePredictionResult: Codable {
    public let Id: String
    public let Project: String
    public let Iteration: String
    public let Created: Date
    public let Predictions: [ImageTagPrediction]?    
}

public struct ImageTagPrediction: Codable {
    public let TagId: String
    public let Tag: String?
    public let Probability: Double
}

public struct Project: Codable {
    public let Id: String
    public let Name: String?
    public let Description: String?
    public let Settings: ProjectSettings?
    public let CurrentIterationId: String?
    public let Created: Date
    public let LastModified: Date
    public let ThumbnailUri: URL?    
}

public struct ProjectSettings: Codable {
    public let DomainId: String?    
}

public struct Iteration: Codable {
    public let Id: String
    public let Name: String?
    public let IsDefault: Bool
    public let Status: String?
    public let Created: Date
    public let LastModified: Date
    public let TrainedAt: Date?
    public let ProjectId: String
    public let Exportable: Bool
    public let DomainId: String?    
}

public struct IterationPerformance: Codable {
    public let PerTagPerformance: [TagPerformance]?
    public let Precision: Double
    public let PrecisionStdDeviation: Double
    public let Recall: Double
    public let RecallStdDeviation: Double    
}

public struct TagPerformance: Codable {
    public let Id: String
    public let Name: String?
    public let Precision: Double
    public let PrecisionStdDeviation: Double
    public let Recall: Double
    public let RecallStdDeviation: Double    
}

public struct Export: Codable {
    public let Platform: Platform
    public let Status: Status
    public let DownloadUri: URL?
    
    public enum Platform: String, Codable {
        case coreML     = "CoreML"
        case tensorFlow = "TensorFlow"
    }
    public enum Status: String, Codable {
        case exporting  = "Exporting"
        case failed     = "Failed"
        case done       = "Done"
    }    
}

public struct TagList: Codable {
    public let Tags: [Tag]?
    public let TotalTaggedImages: Int
    public let TotalUntaggedImages: Int    
}

public struct Tag: Codable {
    public let Id: String
    public let Name: String?
    public let Description: String?
    public let ImageCount: Int    
}


fileprivate extension Optional where Wrapped: CustomStringConvertible {
    
    var valueOrNilString: String {
        return self?.description ?? "nil"
    }
}


fileprivate extension Optional where Wrapped == Date {
    
    var valueOrEmpty: String {
        return self != nil ? "\(self!.timeIntervalSince1970)" : ""
    }
    
    var valueOrNilString: String {
        return self != nil ? "\(self!.timeIntervalSince1970)" : "nil"
    }
}


// MARK - CustomStringConvertible

extension ApiKeys: CustomStringConvertible {
    public var description: String {
        return "ApiKeys\n\tTrainingKeys: \(TrainingKeys.valueOrNilString)\n\tPredictionKeys: \(PredictionKeys.valueOrNilString)\n..."
    }
}

extension KeyPair: CustomStringConvertible {
    public var description: String {
        return "KeyPair\n\tPrimaryKey: \(PrimaryKey.valueOrNilString)\n\tSecondaryKey: \(SecondaryKey.valueOrNilString)\n..."
    }
}

extension Account: CustomStringConvertible {
    public var description: String {
        return "Account\n\tUserName: \(UserName.valueOrNilString)\n\tEmail: \(Email.valueOrNilString)\n\tKeys: \(Keys.valueOrNilString)\n\tQuotas: \(Quotas.valueOrNilString)\n..."
    }
}

extension AccountQuota: CustomStringConvertible {
    public var description: String {
        return "AccountQuota\n\tTier: \(Tier.valueOrNilString)\n\tProjects: \(Projects.valueOrNilString)\n\tPredictions: \(Predictions.valueOrNilString)\n\tPerProject: \(PerProject.valueOrNilString)\n..."
    }
}

extension Quota: CustomStringConvertible {
    public var description: String {
        return "Quota\n\tTotal: \(Total)\n\tUsed: \(Used)\n\tTimeUntilReset: \(TimeUntilReset.valueOrNilString)\n..."
    }
}

extension PerProjectQuota: CustomStringConvertible {
    public var description: String {
        return "PerProjectQuota\n\tProjectId: \(ProjectId)\n\tIterations: \(Iterations.valueOrNilString)\n\tImages: \(Images.valueOrNilString)\n\tTags: \(Tags.valueOrNilString)\n..."
    }
}

extension Domain: CustomStringConvertible {
    public var description: String {
        return "Domain\n\tId: \(Id)\n\tName: \(Name.valueOrNilString)\n\tExportable: \(Exportable)\n..."
    }
}

extension Image: CustomStringConvertible {
    public var description: String {
        return "Image\n\tId: \(Id)\n\tCreated: \(Created)\n\tWidth: \(Width)\n\tHeight: \(Height)\n\tImageUrl: \(ImageUrl.valueOrNilString)\n\tThumbnailUri: \(ThumbnailUri.valueOrNilString)\n\tTags: \(Tags.valueOrNilString)\n\tPredictions: \(Predictions.valueOrNilString)\n..."
    }
}

extension ImageTag: CustomStringConvertible {
    public var description: String {
        return "ImageTag\n\tTagId: \(TagId)\n\tCreated: \(Created)\n..."
    }
}

extension PredictionTag: CustomStringConvertible {
    public var description: String {
        return "PredictionTag\n\tTagId: \(TagId)\n\tTag: \(Tag.valueOrNilString)\n\tProbability: \(Probability)\n..."
    }
}

extension ImageCreateSummary: CustomStringConvertible {
    public var description: String {
        return "ImageCreateSummary\n\tIsBatchSuccessful: \(IsBatchSuccessful)\n\tImages: \(Images.valueOrNilString)\n..."
    }
}

extension ImageCreateResult: CustomStringConvertible {
    public var description: String {
        return "ImageCreateResult\n\tSourceUrl: \(SourceUrl.valueOrNilString)\n\tStatus: \(self.Status.rawValue)\n\tImage: \(Image.valueOrNilString)\n..."
    }
}

extension ImageFileCreateBatch: CustomStringConvertible {
    public var description: String {
        return "ImageFileCreateBatch\n\tImages: \(Images.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageFileCreateEntry: CustomStringConvertible {
    public var description: String {
        return "ImageFileCreateEntry\n\tName: \(Name.valueOrNilString)\n\tContents: \(Contents.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageUrlCreateBatch: CustomStringConvertible {
    public var description: String {
        return "ImageUrlCreateBatch\n\tImages: \(Images.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageUrlCreateEntry: CustomStringConvertible {
    public var description: String {
        return "ImageUrlCreateEntry\n\tUrl: \(Url.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageIdCreateBatch: CustomStringConvertible {
    public var description: String {
        return "ImageIdCreateBatch\n\tImages: \(Images.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageIdCreateEntry: CustomStringConvertible {
    public var description: String {
        return "ImageIdCreateEntry\n\tId: \(Id.valueOrNilString)\n\tTagIds: \(TagIds.valueOrNilString)\n..."
    }
}

extension ImageTagCreateBatch: CustomStringConvertible {
    public var description: String {
        return "ImageTagCreateBatch\n\tTags: \(Tags.valueOrNilString)\n..."
    }
}

extension ImageTagCreateEntry: CustomStringConvertible {
    public var description: String {
        return "ImageTagCreateEntry\n\tImageId: \(ImageId)\n\tTagId: \(TagId)\n..."
    }
}


extension ImageTagCreateSummary: CustomStringConvertible {
    public var description: String {
        return "ImageTagCreateSummary\n\tCreated: \(Created.valueOrNilString)\n\tDuplicated: \(Duplicated.valueOrNilString)\n\tExceeded: \(Exceeded.valueOrNilString)\n..."
    }
}

extension PredictionQueryToken: CustomStringConvertible {
    public var description: String {
        return "PredictionQueryToken\n\tSession: \(Session.valueOrNilString)\n\tContinuation: \(Continuation.valueOrNilString)\n\tMaxCount: \(MaxCount)\n\tOrderBy: \(self.OrderBy.rawValue)\n\tTags: \(Tags.valueOrNilString)\n\tIterationId: \(IterationId.valueOrNilString)\n\tStartTime: \(StartTime.valueOrNilString)\n\tEndTime: \(EndTime.valueOrNilString)\n\tApplication: \(Application.valueOrNilString)\n..."
    }
}

extension PredictionQueryTag: CustomStringConvertible {
    public var description: String {
        return "PredictionQueryTag\n\tId: \(Id)\n\tMinThreshold: \(MinThreshold)\n\tMaxThreshold: \(MaxThreshold)\n..."
    }
}

extension PredictionQuery: CustomStringConvertible {
    public var description: String {
        return "PredictionQuery\n\tResults: \(Results.valueOrNilString)\n\tToken: \(Token.valueOrNilString)\n..."
    }
}

extension Prediction: CustomStringConvertible {
    public var description: String {
        return "Prediction\n\tId: \(Id)\n\tProject: \(Project)\n\tIteration: \(Iteration)\n\tCreated: \(Created)\n\tPredictions: \(Predictions.valueOrNilString)\n\tImageUri: \(ImageUri.valueOrNilString)\n\tThumbnailUri: \(ThumbnailUri.valueOrNilString)\n..."
    }
}

extension ImageUrl: CustomStringConvertible {
    public var description: String {
        return "ImageUrl\n\tUrl: \(Url.valueOrNilString)\n..."
    }
}

extension ImagePredictionResult: CustomStringConvertible {
    public var description: String {
        return "ImagePredictionResult\n\tId: \(Id)\n\tProject: \(Project)\n\tIteration: \(Iteration)\n\tCreated: \(Created)\n\tPredictions: \(Predictions.valueOrNilString)\n..."
    }
}

extension ImageTagPrediction: CustomStringConvertible {
    public var description: String {
        return "ImageTagPrediction\n\tTagId: \(TagId)\n\tTag: \(Tag.valueOrNilString)\n\tProbability: \(Probability)\n..."
    }
}

extension Project: CustomStringConvertible {
    public var description: String {
        return "Project\n\tId: \(Id)\n\tName: \(Name.valueOrNilString)\n\tDescription: \(Description.valueOrNilString)\n\tSettings: \(Settings.valueOrNilString)\n\tCurrentIterationId: \(CurrentIterationId.valueOrNilString)\n\tCreated: \(Created)\n\tLastModified: \(LastModified)\n\tThumbnailUri: \(ThumbnailUri.valueOrNilString)\n..."
    }
}

extension ProjectSettings: CustomStringConvertible {
    public var description: String {
        return "ProjectSettings\n\tDomainId: \(DomainId.valueOrNilString)\n..."
    }
}

extension Iteration: CustomStringConvertible {
    public var description: String {
        return "Iteration\n\tId: \(Id)\n\tName: \(Name.valueOrNilString)\n\tIsDefault: \(IsDefault)\n\tStatus: \(Status.valueOrNilString)\n\tCreated: \(Created)\n\tLastModified: \(LastModified)\n\tTrainedAt: \(TrainedAt.valueOrNilString)\n\tProjectId: \(ProjectId)\n\tExportable: \(Exportable)\n\tDomainId: \(DomainId.valueOrNilString)\n..."
    }
}

extension IterationPerformance: CustomStringConvertible {
    public var description: String {
        return "IterationPerformance\n\tPerTagPerformance: \(PerTagPerformance.valueOrNilString)\n\tPrecision: \(Precision)\n\tPrecisionStdDeviation: \(PrecisionStdDeviation)\n\tRecall: \(Recall)\n\tRecallStdDeviation: \(RecallStdDeviation)\n..."
    }
}

extension TagPerformance: CustomStringConvertible {
    public var description: String {
        return "TagPerformance\n\tId: \(Id)\n\tName: \(Name.valueOrNilString)\n\tPrecision: \(Precision)\n\tPrecisionStdDeviation: \(PrecisionStdDeviation)\n\tRecall: \(Recall)\n\tRecallStdDeviation: \(RecallStdDeviation)\n..."
    }
}

extension Export: CustomStringConvertible {
    public var description: String {
        return "Export\n\tPlatform: \(self.Platform.rawValue)\n\tStatus: \(self.Status.rawValue)\n\tDownloadUri: \(DownloadUri.valueOrNilString)\n..."
    }
}

extension TagList: CustomStringConvertible {
    public var description: String {
        return "TagList\n\tTags: \(Tags.valueOrNilString)\n\tTotalTaggedImages: \(TotalTaggedImages)\n\tTotalUntaggedImages: \(TotalUntaggedImages)\n..."
    }
}

extension Tag: CustomStringConvertible {
    public var description: String {
        return "Tag\n\tId: \(Id)\n\tName: \(Name.valueOrNilString)\n\tDescription: \(Description.valueOrNilString)\n\tImageCount: \(ImageCount)\n..."
    }
}

