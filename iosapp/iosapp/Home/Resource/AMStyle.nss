@primaryFontName: AppleGothic;
@secondaryFontName: HelveticaNeue-Light;
@secondaryFontNameBold: HelveticaNeue;
@secondaryFontNameStrong: HelveticaNeue-Medium;
@inputFontName: HelveticaNeue;
@primaryFontColor: #666666;
@secondaryFontColor: #999999;
@primaryBackgroundColor: #E6E6E6;
@primaryBackgroundTintColor: #ECECEC;
@primaryBackgroundColorTop: #FF6060;
@primaryBackgroundColorBottom: #FF6060;
@primaryBackgroundColorBottomStrong: #FF6060;
@secondaryBackgroundColorTop: #FCFCFC;
@secondaryBackgroundColorBottom: #F9F9F9;
@primaryBorderColor: #A2A2A2;
@primaryBorderWidth: 1;

@amWhite: #FFFFFF;
@amYellow: #FFDE00;
@amYellowDark: #FFCC00;
@amBlack: #666666;

BarButton {
    background-color: @primaryBackgroundColor;
    background-color-highlighted: #CCCCCC;
    border-color: @primaryBorderColor;
    border-width: @primaryBorderWidth;
    corner-radius: 7;
    font-name: @secondaryFontNameBold;
    font-color: @primaryFontColor;
    font-color-disabled: @secondaryFontColor;
    font-size: 13;
    text-shadow-color: clear;
}
Button {
    background-color: @amYellow;
    background-color-highlighted: @amYellowDark;
    font-color: @amBlack;
    font-name: @secondaryFontName;
    font-size: 18;
    content-insets: 10;
    corner-radius: 7;
    exclude-views: UIAlertButton;
    exclude-subviews: UITableViewCell,UITextField;
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
    font-name: @secondaryFontName;
    font-size: 20;
    font-color: @primaryFontColor;
    text-auto-fit: false;
}
LargeLabel {
    font-size: 24;
}
SmallLabel {
    font-size: 15;
}
NavigationBar {
    font-name: @secondaryFontName;
    font-size: 20;
    font-color: @primaryFontColor;
    text-shadow-color: clear;
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottomStrong;
}
Progress {
    progress-tint-color: @primaryBackgroundTintColor;
    track-tint-color: @secondaryBackgroundColorTop;
}
SearchBar {
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottom;
    scope-background-color: #FFFFFF;
}
SegmentedControl {
    background-color: @primaryBackgroundColorTop;
    background-color-selected: @primaryBackgroundColorBottomStrong;
    border-color: @primaryBorderColor;
    border-width: @primaryBorderWidth;
    corner-radius: 7;
    font-name: @secondaryFontNameBold;
    font-size: 13;
    font-color: @primaryFontColor;
    text-shadow-color: clear;
}
Switch {
    on-tint-color: @primaryBackgroundTintColor;
}
TabBar {
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottom;
}
TabBarItem {
    font-name: @secondaryFontName;
    font-color: #FFFFFF;
    font-size: 18;
    text-offset: 0,-11;
}
TableCell {
    font-color: @primaryFontColor;
    font-name: @secondaryFontNameBold;
    font-size: 17;
}
TableCellDetail {
    font-name: @secondaryFontName;
    font-size: 14;
    font-color: @secondaryFontColor;
}
TextField {
    height: 37;
    font-name: @inputFontName;
    font-size: 18;
    border-style: rounded;
    vertical-align: center;
}
TextView {
    font-name: @primaryFontName;
    font-color: @primaryFontColor;
    font-size: 14;
}
LargeTextField {
    height: 50;
    font-size: 28;
}