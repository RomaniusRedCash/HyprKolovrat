import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Layouts

PopupWindow {
    id: calendarContainer
    required property Item anchorItem
    required property bool isHovering

    signal hoverStatusChanged(bool isHovered)

    visible: isHovering

    // Окно автоматически подстроится под размер контента (заголовки + сетка месяцев)
    implicitWidth: mainLayout.implicitWidth + 5
    implicitHeight: mainLayout.implicitHeight + 5
    color: Theme.bg2

    anchor {
        window: anchorItem.QsWindow.window
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom | Edges.Right

        onAnchoring: {
            const pos = anchorItem.QsWindow.contentItem.mapFromItem(
                anchorItem,
                anchorItem.width / 2 - calendarContainer.width,
                anchorItem.height + 7
            );
            anchor.rect.x = pos.x;
            anchor.rect.y = pos.y;
        }
    }

    // Состояние календаря
    property int currentYear: new Date().getFullYear()
    property date today: new Date()

    // Функция форматирования месяца на русском языке с использованием Qt.locale()
    function getLocaleMonthName(monthIndex) {
        let testDate = new Date(currentYear, monthIndex, 1);
        // Форматируем используя русскую локаль (или системную Qt.locale())
        let name = testDate.toLocaleString(Qt.locale("ru_RU"), "MMMM");
        return name.charAt(0).toUpperCase() + name.slice(1);
    }

    Column {
        id: mainLayout
        // spacing: 5
        anchors.centerIn: parent

        // Панель навигации по годам (Вернул стрелочки!)
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            // Стрелка НАЗАД (Предыдущий год)
            BaseText {
                text: "❮"
                font.pointSize: 10
                font.bold: true
                color: Theme.textOff

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5 // Увеличиваем хитбокс для клика
                    onClicked: calendarContainer.currentYear--
                }
            }

            // Отображение текущего просматриваемого года
            BaseText {
                text: calendarContainer.currentYear
                font.pointSize: 10
                font.bold: true
                color: Theme.text
            }

            // Стрелка ВПЕРЕД (Следующий год)
            BaseText {
                text: "❯"
                font.pointSize: 10
                font.bold: true
                color: Theme.textOff

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -5
                    onClicked: calendarContainer.currentYear++
                }
            }
        }
        // Сетка из 12 месяцев (3 колонки на 4 строки)
        Grid {
            id: gridOfMonths
            columns: 4
            spacing: 5

            Repeater {
                model: 12
                Column {
                    id: monthColumn
                    spacing: 5
                    // Явно сохраняем индекс текущего месяца из Repeater
                    property int monthIndex: index
                    // Название конкретного месяца
                    BaseText {
                        text: calendarContainer.getLocaleMonthName(monthColumn.monthIndex)
                        font.bold: true
                        font.pointSize: 8
                        color: Theme.text
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    // Дни недели (Пн-Вс)
                    Item{

                    }
                    Grid {
                        columns: 7
                        spacing: 0
                        Repeater {
                            model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                            BaseText {
                                text: modelData
                                font.pointSize: 8
                                font.bold: true
                                color: (modelData === "Сб" || modelData === "Вс") ? "#ffff00" : Theme.textOff
                                width: 18
                                horizontalAlignment: BaseText.AlignHCenter
                            }
                        }
                    }
                    // Сетка дней (42 ячейки)
                    Grid {
                        id: daysGrid
                        columns: 7

                        property int firstDayOffset: {
                            let day = new Date(calendarContainer.currentYear, monthColumn.monthIndex, 1).getDay();
                            return day === 0 ? 6 : day - 1;
                        }
                        property int daysInThisMonth: new Date(calendarContainer.currentYear, monthColumn.monthIndex + 1, 0).getDate()
                        Repeater {
                            model: 42
                            Rectangle {
                                width: 18
                                height: 18
                                radius: 4

                                property int dayNumber: index - daysGrid.firstDayOffset + 1
                                property bool isValidDay: dayNumber > 0 && dayNumber <= daysGrid.daysInThisMonth

                                // ТЕПЕРЬ ПРОВЕРКА ОДНОЗНАЧНАЯ И РАБОТАЕТ НА 100%:
                                property bool isToday: isValidDay &&
                                dayNumber === calendarContainer.today.getDate() &&
                                monthColumn.monthIndex === calendarContainer.today.getMonth() &&
                                calendarContainer.currentYear === calendarContainer.today.getFullYear()

                                // Заливка кружка для сегодняшней даты
                                color: isToday ? Theme.focusedWS : "transparent"

                                BaseText {
                                    anchors.centerIn: parent
                                    text: parent.isValidDay ? parent.dayNumber : ""
                                    font.pointSize: 8
                                    font.bold: parent.isToday
                                    color: Theme.text
                                    opacity: parent.isValidDay ? 1.0 : 0.0
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Прозрачный слой трекинга мыши, который не перехватывает клики по стрелочкам года
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton

        onContainsMouseChanged: {
            calendarContainer.hoverStatusChanged(containsMouse);
        }
    }
}
