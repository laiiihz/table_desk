# table_desk 🛋

a simple way to create merge cells table.


> this package is WIP(work-in-progress).
> 
> PERFER NOT USE THIS PACKAGE IN YOUR PRODUCT.
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
