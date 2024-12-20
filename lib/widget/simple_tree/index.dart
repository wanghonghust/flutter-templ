import 'package:flutter/material.dart';
import 'package:kms/widget/custom_tree/src/treeview.dart';

class SimpleTreeView<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;
  final void Function(TreeNode<T> node)? onNodeTap;

  const SimpleTreeView({Key? key, required this.nodes, this.onNodeTap}) : super(key: key);
  @override
  _SimpleTreeViewState createState() => _SimpleTreeViewState<T>();
}

class _SimpleTreeViewState<T> extends State<SimpleTreeView<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.nodes.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: SizedBox(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...widget.nodes.map((node) => _buildNode(node))])),
    );
  }

  Widget _buildNode(TreeNode<T> node, {int depth = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
                onTap: () {
                  widget.onNodeTap?.call(node);
                },
                child: Row(children: [
                  SizedBox(
                    width: depth * 10,
                  ),
                  node.label
                ]))),
        if (node.children.isNotEmpty)
          ...node.children
              .map((child) => _buildNode(child, depth: depth + 1))
              .toList()
      ],
    );
  }
}
