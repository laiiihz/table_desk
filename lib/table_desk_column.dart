part of 'table_desk.dart';

class TableDeskColumn extends MultiChildRenderObjectWidget {
  TableDeskColumn({super.key, required super.children, this.border});

  final BorderSide? border;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTableDeskColumn()..borderSide = border;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderTableDeskColumn renderObject) {
    renderObject.borderSide = border;
  }
}

class RenderTableDeskColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, RenderTableDeskColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            RenderTableDeskColumnParentData> {
  BorderSide? _borderSide;
  set borderSide(BorderSide? side) {
    _borderSide = side;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    child.parentData ??= RenderTableDeskColumnParentData();
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.constrain(const Size(double.infinity, 0));
      return;
    }

    double currentHeight = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      RenderTableDeskColumnParentData parentData =
          child.parentData as RenderTableDeskColumnParentData;

      child.layout(
        BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: constraints.maxWidth,
          minWidth: constraints.maxWidth,
        ),
        parentUsesSize: true,
      );

      final childSize = child.size;
      parentData.offset = Offset(0, currentHeight);

      child = parentData.nextSibling;
      currentHeight += childSize.height;
    }

    double calculateHeight = 0;
    if (constraints.maxHeight == double.infinity) {
      calculateHeight = currentHeight;
    } else {
      calculateHeight = max(currentHeight, constraints.maxHeight);
      if (currentHeight < constraints.maxHeight) {
        /// relayout children
        child = firstChild;
        int currentPosition = 0;
        while (child != null) {
          RenderTableDeskColumnParentData parentData =
              child.parentData as RenderTableDeskColumnParentData;
          child.layout(
            BoxConstraints.tight(
                Size(constraints.maxWidth, calculateHeight / childCount)),
            parentUsesSize: true,
          );
          parentData.offset =
              Offset(0, currentPosition * calculateHeight / childCount);
          child = parentData.nextSibling;
          currentPosition++;
        }
      }
    }

    size = constraints.constrain(Size(double.infinity, calculateHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Paint? paint;

    startPaint(Offset offset) {
      if (paint != null) {
        context.canvas.drawLine(
          offset,
          offset + Offset(size.width, 0),
          paint,
        );
      }
    }

    if (_borderSide != null) {
      paint = _borderSide!.toPaint();
    }

    RenderBox? child = firstChild;

    while (child != null) {
      RenderTableDeskColumnParentData parentData =
          child.parentData as RenderTableDeskColumnParentData;
      context.paintChild(child, offset + parentData.offset);
      if (child != firstChild) {
        startPaint(offset + parentData.offset);
      }
      child = parentData.nextSibling;
    }
  }
}

class RenderTableDeskColumnParentData
    extends ContainerBoxParentData<RenderBox> {}
