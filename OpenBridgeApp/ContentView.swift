//
//  ContentView.swift
//

import SwiftUI
import BridgeClientExtension
import BridgeClientUI
import AssessmentModel
import AssessmentModelUI
import SharedOpenBridgeApp
import WashUArcWrapper_iOS

let kAssessmentInfoMap: AssessmentInfoMap = .init(extensions: ARCIdentifier.allCases)

struct ContentView: OpenBridgeContentView {
    var body: some View {
        AppContentView<PresenterView>()
            .assessmentInfoMap(kAssessmentInfoMap)
    }
}

struct PresenterView : AssessmentPresenterView {
    @ObservedObject var todayViewModel: TodayTimelineViewModel
    
    var body: some View {
        switch todayViewModel.selectedAssessmentViewType {
        case .survey(let info):
            SurveyView<AssessmentView>(info, handler: todayViewModel)
        case .arc(let info):
            ARCAssessmentView(info, handler: todayViewModel)
        default:
            emptyAssessment()
        }
    }
    
    @ViewBuilder
    func emptyAssessment() -> some View {
        VStack {
            Text("This assessment is not supported by this app version")
            Button("Dismiss", action: { todayViewModel.isPresentingAssessment = false })
        }
    }
}

enum AssessmentViewType {
    case arc(AssessmentScheduleInfo)
    case survey(AssessmentScheduleInfo)
    case empty
}

extension TodayTimelineViewModel {
    
    var selectedAssessmentViewType : AssessmentViewType {
        guard let info = selectedAssessment else { return .empty }
        
        let assessmentId = info.assessmentInfo.identifier
        if ArcAssessmentManager.shared.hasAssessment(with: assessmentId) {
            return .arc(info)
        }
        else {
            return .survey(info)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(SingleStudyAppManager(mockType: .preview))
        }
    }
}
