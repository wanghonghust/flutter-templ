import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'tree_node.dart';
part 'treeview_state.dart';

/// A customizable tree view widget for Flutter applications.
///
/// [TreeView] displays hierarchical data in a tree structure, allowing for
/// selection, expansion, and collapse of nodes. It supports various features
/// such as multi-selection, filtering, sorting, and customization of appearance.
///
/// The widget is generic over type [T], which represents the type of value
/// associated with each node in the tree.
///
/// Key features:
/// - Hierarchical data display
/// - Node selection (single or multi)
/// - Expandable/collapsible nodes
/// - Optional "Select All" functionality
/// - Customizable node appearance
/// - Filtering and sorting capabilities
/// - Expand/collapse all functionality
///
/// Example usage:
/// ```dart
/// TreeView<String>(
///   nodes: [
///     TreeNode(
///       label: const Text('Root'),
///       children: [
///         TreeNode(label: const Text('Child 1'), value: 'child1'),
///         TreeNode(label: const Text('Child 2'), value: 'child2'),
///       ],
///     ),
///   ],
///   onSelectionChanged: (selectedValues) {
///     print('Selected values: $selectedValues');
///   },
/// )
/// ```
typedef VoidCallback<T> = void Function(TreeNode<T> node);
class TreeView<T> extends StatefulWidget {
  /// The root nodes of the tree.
  final List<TreeNode<T>> nodes;

  /// Callback function called when the selection state changes.
  final Function(List<T?>) onSelectionChanged;

  /// Optional theme data for the tree view.
  final ThemeData? theme;

  /// Whether to show the expand/collapse all button.
  final bool expandFirstRootNode;

  /// Callback function called when a node is tapped.
  final VoidCallback<T>? onNodeTapped;

  /// Callback function called when a node is double tapped.
  final VoidCallback<T>? onNodeDbTapped;

  /// Creates a [TreeView] widget.
  ///
  /// The [nodes] and [onSelectionChanged] parameters are required.
  ///
  /// The [theme] parameter can be used to customize the appearance of the tree view.
  ///
  /// Use [initialExpandedLevels] to control how many levels of the tree are initially expanded.
  /// If null, no nodes are expanded. If set to 0, all nodes are expanded.
  /// If set to 1, only the root nodes are expanded, if set to 2, the root nodes and their direct children are expanded, and so on.
  ///
  /// Set [showExpandCollapseButton] to true to display a button that expands or collapses all nodes.
  const TreeView({
    super.key,
    required this.nodes,
    required this.onSelectionChanged,
    this.theme,
    this.expandFirstRootNode = false,
    this.onNodeTapped,
    this.onNodeDbTapped,
  });
  
  @override
  TreeViewState<T> createState() => TreeViewState<T>();
}
