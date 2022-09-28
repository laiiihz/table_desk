# table_desk 🛋

## Features

* [x] auto resize table when content change  

## Usage

```dart
TableDesk(
    child: TableDeskColumn(
        children: [
            TableDeskRow(
                gaps: [
                    TableGap.width(100),
                    TableGap.weight(),
                ],
                children: [
                    WidgetA(),
                    WidgetB(),
                ]
            ),
            TableDeskRow(
                gaps: [
                    TableGap.width(100),
                    TableGap.weight(),
                ],
                children: [
                    WidgetA(),
                    WidgetB(),
                ]
            ),
        ]
    ),
)
```
