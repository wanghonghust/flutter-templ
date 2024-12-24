part of 'treeview.dart';

/// The state management class for the [TreeView] widget.
///
/// This class handles the internal logic and state of the tree view, including:
/// - Node selection and deselection
/// - Expansion and collapse of nodes
/// - Filtering and sorting of nodes
/// - Handling of "Select All" functionality
/// - Managing the overall tree structure
///
/// It also provides methods for external manipulation of the tree, such as:
/// - [filter] for applying filters to the tree nodes
/// - [sort] for sorting the tree nodes
/// - [setSelectAll] for selecting or deselecting all nodes
/// - [expandAll] and [collapseAll] for expanding or collapsing all nodes
/// - [getSelectedNodes] and [getSelectedValues] for retrieving selected items
///
/// This class is not intended to be used directly by users of the [TreeView] widget,
/// but rather serves as the internal state management mechanism.
class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  HeaderDelegate({required this.child});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => 24;

  @override
  double get minExtent => 24;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class TreeViewState<T> extends State<TreeView<T>> {
  late bool _isAllExpanded;

  @override
  void initState() {
    super.initState();
    _initializeNodes(widget.nodes, null);
    _updateAllNodesSelectionState();
    _isAllExpanded = false;
  }

  /// Filters the tree nodes based on the provided filter function.
  ///
  /// The [filterFunction] should return true for nodes that should be visible.
  void filter(bool Function(TreeNode<T>) filterFunction) {
    setState(() {
      _applyFilter(widget.nodes, filterFunction);
      _updateAllNodesSelectionState();
    });
  }

  /// Sorts the tree nodes based on the provided compare function.
  ///
  /// If [compareFunction] is null, the original order is restored.
  void sort(int Function(TreeNode<T>, TreeNode<T>)? compareFunction) {
    setState(() {
      if (compareFunction == null) {
        _applySort(widget.nodes,
            (a, b) => a._originalIndex.compareTo(b._originalIndex));
      } else {
        _applySort(widget.nodes, compareFunction);
      }
    });
  }

  /// Sets the selection state of all nodes.
  void setSelectAll(bool isSelected) {
    setState(() {
      _setAllNodesSelection(isSelected);
    });
    _notifySelectionChanged();
  }

  /// Expands all nodes in the tree.
  void expandAll() {
    setState(() {
      _setExpansionState(widget.nodes, true);
    });
  }

  /// Collapses all nodes in the tree.
  void collapseAll() {
    setState(() {
      _setExpansionState(widget.nodes, false);
    });
  }

  /// Returns a list of all selected nodes in the tree.
  List<TreeNode<T>> getSelectedNodes() {
    return _getSelectedNodesRecursive(widget.nodes);
  }

  /// Returns a list of all selected values in the tree.
  List<T?> getSelectedValues() {
    return _getSelectedValues(widget.nodes);
  }

  void _initializeNodes(List<TreeNode<T>> nodes, TreeNode<T>? parent) {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i]._originalIndex = i;
      nodes[i]._parent = parent;
      _initializeNodes(nodes[i].children, nodes[i]);
    }
  }

  void _applySort(List<TreeNode<T>> nodes,
      int Function(TreeNode<T>, TreeNode<T>) compareFunction) {
    nodes.sort(compareFunction);
    for (var node in nodes) {
      if (node.children.isNotEmpty) {
        _applySort(node.children, compareFunction);
      }
    }
  }

  void _applyFilter(
      List<TreeNode<T>> nodes, bool Function(TreeNode<T>) filterFunction) {
    for (var node in nodes) {
      bool shouldShow =
          filterFunction(node) || _hasVisibleDescendant(node, filterFunction);
      node._hidden = !shouldShow;
      _applyFilter(node.children, filterFunction);
    }
  }

  void _updateAllNodesSelectionState() {
    for (var root in widget.nodes) {
      _updateNodeSelectionStateBottomUp(root);
    }
  }

  void _updateNodeSelectionStateBottomUp(TreeNode<T> node) {
    for (var child in node.children) {
      _updateNodeSelectionStateBottomUp(child);
    }
    _updateSingleNodeSelectionState(node);
  }

  void _updateNodeSelection(TreeNode<T> node, bool? isSelected) {
    setState(() {
      if (isSelected != null) {
        _updateNodeAndDescendants(node, isSelected);
      }
      _updateAncestorsRecursively(node);
    });
    _notifySelectionChanged();
  }

  void _updateNodeAndDescendants(TreeNode<T> node, bool isSelected) {
    if (!node._hidden) {
      setSelectAll(false);
      node._isSelected = isSelected;
    }
  }

  void _updateAncestorsRecursively(TreeNode<T> node) {
    TreeNode<T>? parent = node._parent;
    if (parent != null) {
      _updateSingleNodeSelectionState(parent);
      _updateAncestorsRecursively(parent);
    }
  }

  void _notifySelectionChanged() {
    List<T?> selectedValues = _getSelectedValues(widget.nodes);
    widget.onSelectionChanged(selectedValues);
  }

  List<T?> _getSelectedValues(List<TreeNode<T>> nodes) {
    List<T?> selectedValues = [];
    for (var node in nodes) {
      if (node._isSelected && !node._hidden) {
        selectedValues.add(node.value);
      }
      selectedValues.addAll(_getSelectedValues(node.children));
    }
    return selectedValues;
  }

  Widget _buildTreeNode(TreeNode<T> node, {int depth = 0}) {
    if (node._hidden) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              key: ObjectKey(node),
              color: node._isSelected
                  ? Theme.of(context)
                      .focusColor
                  : Colors.transparent,
              child: InkWell(
                onTap: () {
                  _updateNodeSelection(node, true);
                  if (node.children.isNotEmpty) {
                    _toggleNodeExpansion(node);
                  }
                  if (widget.onNodeTapped != null) {
                    widget.onNodeTapped!(node);
                  }
                },
                onDoubleTap: () => {
                  if (widget.onNodeDbTapped != null)
                    {widget.onNodeDbTapped!(node)}
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: depth * 24,
                    ),
                    SizedBox(
                      width: 24,
                      child: node.children.isNotEmpty
                          ? Icon(
                              node._isExpanded
                                  ? Icons.expand_more
                                  : Icons.chevron_right,
                            )
                          : null,
                    ),
                    node.icon!,
                    const SizedBox(width: 4),
                    Expanded(child: node.label),
                  ],
                ),
              ),
            ),
          ),
          if (node._isExpanded)
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuart,
              tween: Tween<double>(
                begin: node._isExpanded ? 0 : 1,
                end: node._isExpanded ? 1 : 0,
              ),
              builder: (context, value, child) {
                return ClipRect(
                  child: Align(
                    heightFactor: value,
                    child: child,
                  ),
                );
              },
              child: node.children.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: node.children
                            .map((child) => _buildTreeNode(child,
                                depth: depth + 1)) // 递归调用时增加深度
                            .toList(),
                      ),
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  void _toggleNodeExpansion(TreeNode<T> node) {
    setState(() {
      node._isExpanded = !node._isExpanded;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _hasVisibleDescendant(
      TreeNode<T> node, bool Function(TreeNode<T>) filterFunction) {
    for (var child in node.children) {
      if (filterFunction(child) ||
          _hasVisibleDescendant(child, filterFunction)) {
        return true;
      }
    }
    return false;
  }

  void _updateSingleNodeSelectionState(TreeNode<T> node) {
    if (node.children.isEmpty ||
        node.children.every((child) => child._hidden)) {
      return;
    }

    List<TreeNode<T>> visibleChildren =
        node.children.where((child) => !child._hidden).toList();
    bool anySelected = visibleChildren.any((child) => child._isSelected);

    if (anySelected) {
      node._isSelected = false;
    } else {
      node._isSelected = false;
    }
  }

  void _setExpansionState(List<TreeNode<T>> nodes, bool isExpanded) {
    for (var node in nodes) {
      node._isExpanded = isExpanded;
      _setExpansionState(node.children, isExpanded);
    }
  }

  bool _isNodeFullySelected(TreeNode<T> node) {
    if (node._hidden) return true;
    if (!node._isSelected) return false;
    return node.children
        .where((child) => !child._hidden)
        .every(_isNodeFullySelected);
  }

  void _handleSelectAll(bool? value) {
    if (value == null) return;
    _setAllNodesSelection(value);
    _notifySelectionChanged();
  }

  void _setAllNodesSelection(bool isSelected) {
    for (var root in widget.nodes) {
      _setNodeAndDescendantsSelection(root, isSelected);
    }
  }

  void _setNodeAndDescendantsSelection(TreeNode<T> node, bool isSelected) {
    if (node._hidden) return;
    node._isSelected = isSelected;
    for (var child in node.children) {
      _setNodeAndDescendantsSelection(child, isSelected);
    }
  }

  void _toggleExpandCollapseAll() {
    setState(() {
      _isAllExpanded = !_isAllExpanded;
      _setExpansionState(widget.nodes, _isAllExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.nodes.map((root) => _buildTreeNode(root)),
        ],
      ),
    );
  }

  List<TreeNode<T>> _getSelectedNodesRecursive(List<TreeNode<T>> nodes) {
    List<TreeNode<T>> selectedNodes = [];
    for (var node in nodes) {
      if (node._isSelected && !node._hidden) {
        selectedNodes.add(node);
      }
      if (node.children.isNotEmpty) {
        selectedNodes.addAll(_getSelectedNodesRecursive(node.children));
      }
    }
    return selectedNodes;
  }
}
