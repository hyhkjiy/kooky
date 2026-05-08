import SwiftUI

/// Per-pane tab strip — each split region renders its own. The "+" button
/// targets the pane it sits in.
struct TabBarView: View {
    @Bindable var pane: Pane
    @Bindable var workspace: Workspace
    let store: WorkspaceStore

    @State private var isAddMenuOpen = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(Array(pane.tabs.enumerated()), id: \.element.id) { index, tab in
                    TabBarItem(
                        tab: tab,
                        isActive: pane.activeTabId == tab.id,
                        canCloseToRight: index < pane.tabs.count - 1,
                        onActivate: { store.activateTab(tab, in: workspace) },
                        onClose: { store.closeTab(tab, in: workspace) },
                        onCloseOthers: { store.closeOtherTabs(keeping: tab, in: workspace) },
                        onCloseToRight: { store.closeTabsToRight(of: tab, in: workspace) },
                        onDuplicate: { store.duplicateTab(tab, in: workspace) },
                        onSplit: { store.splitPane(pane, orientation: $0, in: workspace) }
                    )
                }
                addButton
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Theme.space2)
        }
        .frame(height: 40)
    }

    private var addButton: some View {
        HoverableIconButton(
            systemName: "plus",
            fontSize: 11,
            size: 28,
            help: "New tab"
        ) {
            isAddMenuOpen.toggle()
        }
        .popover(isPresented: $isAddMenuOpen, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(AgentTemplate.all) { template in
                    KookyMenuRow(title: template.title) {
                        AgentIconView(asset: template.iconAsset, fallbackSymbol: template.symbol, size: 16)
                    } action: {
                        store.addTab(in: workspace, pane: pane, template: template)
                        isAddMenuOpen = false
                    }
                }
            }
            .padding(Theme.space1)
            .frame(minWidth: 220)
            .background(Theme.chromeBackground)
        }
    }
}
