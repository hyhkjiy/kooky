import SwiftUI

struct SidebarView: View {
    static let width: CGFloat = 220

    @Bindable var store: WorkspaceStore
    /// Id of the workspace currently being dragged. Set by `.onDrag`, cleared
    /// on drop. Lets each row compute whether the drag origin is above or
    /// below it so the drop indicator can flip edges.
    @State private var draggingWorkspaceId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            header
            list
            Spacer(minLength: 0)
        }
        .frame(width: Self.width)
        .background(Theme.chromeBackground)
    }

    private var header: some View {
        HStack(spacing: 0) {
            Text("kooky")
                .font(Theme.display(15, weight: .medium))
                .foregroundStyle(Theme.chromeForeground)
            Spacer()
            HoverableIconButton(
                systemName: "plus",
                fontSize: 12,
                size: 26,
                help: "New workspace"
            ) {
                store.addWorkspace()
            }
        }
        .padding(.horizontal, Theme.space4)
        // Top padding clears the traffic-light area (window is full-content;
        // there's no real title bar to push us down).
        .padding(.top, 32)
        .padding(.bottom, Theme.space3)
    }

    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 2) {
                ForEach(Array(store.workspaces.enumerated()), id: \.element.id) { index, workspace in
                    DraggableWorkspaceRow(
                        workspace: workspace,
                        store: store,
                        myIndex: index,
                        draggingId: $draggingWorkspaceId
                    )
                }
            }
            .padding(.horizontal, Theme.space2)
            .padding(.bottom, Theme.space2)
        }
    }
}

/// Drag source + drop target with a direction-aware edge indicator —
/// `top` when origin is below (dragging up), `bottom` when origin is above
/// (dragging down), so the line always shows where the dropped row will land.
private struct DraggableWorkspaceRow: View {
    @Bindable var workspace: Workspace
    @Bindable var store: WorkspaceStore
    let myIndex: Int
    @Binding var draggingId: UUID?

    @State private var isTargeted = false

    var body: some View {
        let originIndex: Int? = {
            guard let id = draggingId, id != workspace.id else { return nil }
            return store.workspaces.firstIndex(where: { $0.id == id })
        }()
        let dragsDownward = (originIndex ?? Int.max) < myIndex
        let edge: Alignment = dragsDownward ? .bottom : .top
        let isSelfDrag = draggingId == workspace.id

        SidebarWorkspaceRow(
            workspace: workspace,
            isActive: workspace.id == store.activeWorkspaceId,
            canCloseOthers: store.workspaces.count > 1,
            onActivate: { store.activateWorkspace(workspace) },
            onClose: { store.closeWorkspace(workspace) },
            onCloseOthers: { store.closeOtherWorkspaces(keeping: workspace) },
            onDuplicate: { store.duplicateWorkspace(workspace) }
        )
        .dropIndicator(active: isTargeted && !isSelfDrag, on: edge)
        .onDrag {
            draggingId = workspace.id
            return NSItemProvider(object: workspace.id.uuidString as NSString)
        }
        .dropDestination(for: String.self) { dropped, _ in
            defer { draggingId = nil }
            guard let id = dropped.first.flatMap(UUID.init),
                  let from = store.workspaces.firstIndex(where: { $0.id == id })
            else { return false }
            withAnimation(.easeInOut(duration: 0.18)) {
                store.moveWorkspace(from: from, to: myIndex)
            }
            return true
        } isTargeted: { isTargeted = $0 }
    }
}
