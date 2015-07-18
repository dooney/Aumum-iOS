@amWhite: #FFFFFF;
@amRed: #FF6060;
@amYellow: #FFDE00;
@amYellowDark: #FFCC00;
@amBlack: #666666;
@amDarkGrey: #999999;

Button {
    background-color: @amYellow;
    background-color-highlighted: @amYellowDark;
    font-color: @amBlack;
    font-size: 18;
    content-insets: 10;
    corner-radius: 7;
    exclude-views: UIAlertButton;
    exclude-subviews: UITableViewCell,UITextField;
}
BarButtonBack {
    font-color: @amWhite;
    background-color: @amRed;
}
LargeButton {
    height: 50;
    font-size: 20;
    corner-radius: 10;
}
SmallButton {
    height: 24;
    font-size: 14;
    corner-radius: 5;
}
Label {
    font-size: 20;
    font-color: @amBlack;
    text-auto-fit: false;
}
LargeLabel {
    font-size: 24;
}
SmallLabel {
    font-size: 15;
}
NavigationBar {
    text-shadow-color: clear;
    background-color: @amRed;
}
TabBar {
    background-color: @amRed;
}
TableCell {
    font-color: @amBlack;
    font-size: 17;
}
TextField {
    font-size: 18;
}