import AppKit
import SwiftUI

struct ContentView: View {
    let store: WorkspaceStore

    var body: some View {
        HStack(spacing: 0) {
            SidebarView(store: store)
            Rectangle().fill(Theme.chromeHairline).frame(width: 1)
            mainPane
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(chromeBackground)
        .ignoresSafeArea(.all)
        .onChange(of: store.workspaces.isEmpty) { _, isEmpty in
            if isEmpty { NSApplication.shared.keyWindow?.close() }
        }
    }

    @ViewBuilder
    private var mainPane: some View {
        if let workspace = store.active {
            PaneTreeView(node: workspace.root, workspace: workspace, store: store)
                .id(workspace.id)
        } else {
            Color.clear
        }
    }

    private var chromeBackground: Color {
        let color = store.active?.activeSession?.engine.backgroundColor ?? Theme.terminalSurface
        return Color(nsColor: color)
    }
}
