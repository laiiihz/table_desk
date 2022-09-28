# table_desk 🛋

a simple way to create merge cells table.

![Pub Version](https://img.shields.io/pub/v/table_desk)

> this package is WIP(work-in-progress).🚧
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

## WIP
* [ ] some test.
* [ ] set decoration in `TableDesk` widget.