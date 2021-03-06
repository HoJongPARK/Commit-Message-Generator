//
//  ContentView.swift
//  CommitGenerator
//
//  Created by 박종호 on 2022/02/25.
//

import SwiftUI
import AlertToast

// MARK: - 커밋 작성 뷰
struct CommitWriteHost: View {

    @EnvironmentObject private var commitViewModel: CommitViewModel
    @EnvironmentObject private var tagViewModel: TagViewModel
    @State private var showingResetAlert: Bool = false

    @State private var showSuccess: Bool = false
    @State private var showError: Bool = false

    var body: some View {
        content
        .navigationTitle("커밋 작성")
        .toolbar(content: toolbar)
        .alert("변경 내용이 초기화됩니다.", isPresented: $showingResetAlert) {
            Button("초기화", role: .destructive) {
                commitViewModel.reset()
            }
        } message: {
            Text("계속하시겠습니까?")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.background1.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        .toast(isPresenting: $showSuccess) {
            AlertToast(type: .systemImage("doc.on.clipboard.fill", .gray), title: "클립보드\n복사완료")
        }
        .toast(isPresenting: $showError) {
            AlertToast(type: .error(.error), title: "복사 실패!\n양식을 지켜주세요")
        }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("제목")
                        .font(.title2).fontWeight(.semibold)
                    HStack(spacing: 16) {
                        TagSelector(selected: $commitViewModel.selectedTag, placeholder: "태그", tags: tagViewModel.tags)
                        TagSelector(selected: $commitViewModel.selectedFunction, placeholder: "기능", tags: tagViewModel.functions)
                    }

                    RoundedTextField(.title, $commitViewModel.title) {
                        HStack(spacing: 16) {
                            TagSelector(selected: $commitViewModel.selectedTag, placeholder: "태그", tags: tagViewModel.tags)
                            TagSelector(selected: $commitViewModel.selectedFunction, placeholder: "기능", tags: tagViewModel.functions)
                        }
                    }
                }

                Divider().background(Color.white)

                Group {
                    Text("본문")
                        .font(.title2).fontWeight(.semibold)
                    RoundedTextField(.body, $commitViewModel.body) {}
                }

                Divider().background(Color.white)

                Group {
                    Text("이슈 트래커")
                        .font(.title2).fontWeight(.semibold)
                    SelectedIssueList(issueType: .resolved, issues: $commitViewModel.resolvedIssues)
                    SelectedIssueList(issueType: .fixing, issues: $commitViewModel.fixingIssues)
                    SelectedIssueList(issueType: .ref, issues: $commitViewModel.refIssues)
                    SelectedIssueList(issueType: .related, issues: $commitViewModel.relatedIssues)
                }
            }
            .padding()
        }
    }
}
// MARK: - 툴바 모음
extension CommitWriteHost {
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            SaveButton {
                showCopyResult(commitViewModel.copyToClipboard($0))
            }
            .disabled(!commitViewModel.correctForm)
        }
        ToolbarItem(placement: .cancellationAction) {
            ResetButton(onClick: {showingResetAlert = true})
        }
    }
}
// MARK: - 토스트 함수
extension CommitWriteHost {
    private func showCopyResult(_ result: Bool) {
        if result {
            showSuccess = true
        } else {
            showError = true
        }
    }
}
// MARK: - 커밋 작성 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommitWriteHost()
                .environmentObject(CommitViewModel())
                .environmentObject(TagViewModel())
        }
    }
}
