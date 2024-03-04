// Created 11/16/22
// swift-version:5.0

import SwiftUI
import BridgeClient
import BridgeClientExtension
import BridgeClientUI

struct AssessmentIconPreview: View {
    @State var assessments: [TodayTimelineAssessment] = previewAssessments
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(assessments) {
                    AssessmentTimelineCardView($0)
                }
            }
        }
        .assessmentInfoMap(kAssessmentInfoMap)
    }
}

struct AssessmentIconPreview_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentIconPreview()
    }
}

let previewNativeAssessments = [NativeScheduledAssessment(identifier: "Example Survey")]

let previewAssessments: [TodayTimelineAssessment] = previewNativeAssessments.map {
    TodayTimelineAssessment($0)
}

extension NativeScheduledAssessment {    
    fileprivate convenience init(identifier: String, isCompleted: Bool = false) {
        self.init(instanceGuid: UUID().uuidString,
                  assessmentInfo: AssessmentInfo(identifier: identifier),
                  isCompleted: isCompleted,
                  isDeclined: false,
                  adherenceRecords: nil)
    }
}

extension AssessmentInfo {
    fileprivate convenience init(identifier: String, label: String? = nil, background: String? = nil) {
        let colorScheme: BridgeClient.ColorScheme? = background.map {
            .init(foreground: $0, background: $0, activated: nil, inactivated: nil, type: nil)
        }
        self.init(key: identifier,
                  guid: UUID().uuidString,
                  appId: kPreviewStudyId,
                  identifier: identifier,
                  revision: nil,
                  label: label ?? identifier,
                  minutesToComplete: 3,
                  colorScheme: colorScheme,
                  configUrl: "nil",
                  imageResource: nil,
                  type: "AssessmentInfo")
    }
}

