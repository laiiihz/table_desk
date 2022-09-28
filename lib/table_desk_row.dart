part of 'table_desk.dart';

class TableGap {
  TableGap.weight([double value = 1])
      : weight = value,
        width = null,
        assert(value > 0, 'value must more then 0');

  TableGap.width(double value)
      : width = value,
        weight = null;

  final double? width;
  final double? weight;

  bool get hasWeight => weight != null;
  bool get hasWidth => width != null;
}

class TableDeskRow extends MultiChildRenderObjectWidget {
  TableDeskRow({super.key, super.children, required this.gaps, this.border})
      : assert(children.length == gaps.length,
            'children count must same as gaps count');

  final List<TableGap> gaps;
  final BorderSide? border;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTableDeskRow()
      .._gaps = gaps
      ..borderSide = border;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderTableDeskRow renderObject) {
    renderObject
      .._gaps = gaps
      ..borderSide = border;
  }
}

class RenderTableDeskRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, RenderTableDeskRowData>,
        RenderBoxContainerDefaultsMixin<RenderBox, RenderTableDeskRowData> {
  RenderTableDeskRow();
  late List<TableGap> _gaps;
  BorderSide? _borderSide;
  set gaps(List<TableGap> tableGaps) {
    _gaps = tableGaps;
    markNeedsLayout();
  }

  set borderSide(BorderSide? side) {
    _borderSide = side;
    markNeedsLayout();
  }

  double get parentWidth => constraints.maxWidth;

  List<double> get calculatedGaps {
    double totalWeight = 0;
    double surplusWidth = parentWidth;
    List<double> resultList = List.filled(childCount, 0);
    bool isAllWidth = true;
    for (var element in _gaps) {
      if (element.hasWeight) {
        totalWeight += element.weight!;
        isAllWidth = false;
      } else if (element.hasWidth) {
        surplusWidth -= element.width!;
      }
    }
    if (isAllWidth) return _gaps.map((e) => e.width!).toList();

    for (var i = 0; i < childCount; i++) {
      var gapWeightWidth = 0.0;
      var gapWidthWidth = _gaps[i].width ?? 0.0;
      final gapWeight = _gaps[i].weight;
      if (gapWeight != null) {
        gapWeightWidth = gapWeight / totalWeight * surplusWidth;
      }
      resultList[i] = max(gapWeightWidth, gapWidthWidth);
    }
    return resultList;
  }

  @override
  void setupParentData(RenderBox child) {
    child.parentData ??= RenderTableDeskRowData();
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.constrain(const Size(double.infinity, 0));
      return;
    }

    final calGaps = calculatedGaps;
    int childPosition = 0;
    double currentWidth = 0;
    RenderBox? child = firstChild;

    double maxheight = 0;

    while (child != null) {
      RenderTableDeskRowData parentData =
          child.parentData as RenderTableDeskRowData;
      child.layout(
        BoxConstraints(
          maxWidth: calGaps[childPosition],
          maxHeight: double.infinity,
        ),
        parentUsesSize: true,
      );
      final childSize = child.size;
      parentData.offset = Offset(currentWidth, 0);
      maxheight = max(maxheight, childSize.height);

      // move to next child
      child = parentData.nextSibling;
      currentWidth += calGaps[childPosition];
      childPosition++;
    }

    size = constraints.constrain(Size(double.infinity, maxheight));

    /// relayout

    child = firstChild;
    childPosition = 0;
    double nextHeight = maxheight;
    if (constraints.isTight) {
      nextHeight = max(maxheight, constraints.maxHeight);
    }
    while (child != null) {
      RenderTableDeskRowData parentData =
          child.parentData as RenderTableDeskRowData;
      child.layout(
          BoxConstraints.tight(Size(calGaps[childPosition], nextHeight)));
      child = parentData.nextSibling;
      childPosition++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    Paint? paint;

    startPaint(Offset offset) {
      if (paint != null) {
        context.canvas.drawLine(
          offset,
          offset + Offset(0, size.height),
          paint,
        );
      }
    }

    if (_borderSide != null) {
      paint = _borderSide!.toPaint();
    }
    while (child != null) {
      RenderTableDeskRowData parentData =
          child.parentData as RenderTableDeskRowData;
      context.paintChild(child, offset + parentData.offset);

      if (child != firstChild) {
        startPaint(offset + parentData.offset);
      }
      child = parentData.nextSibling;
    }
  }
}

class RenderTableDeskRowData extends ContainerBoxParentData<RenderBox> {}
