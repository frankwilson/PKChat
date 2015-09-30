//
//  AwadStyles.h
//  Awad2
//
//  Created by Svyatoslav Ivanov on 20.08.13.
//  Copyright (c) 2013 anywayanyday. All rights reserved.
//

#ifndef Awad2_AwadStyles_h
#define Awad2_AwadStyles_h

#define awadColorIpadBlue UIColorFromHex(0x39AEE0)
#define awadColorIpadOrange UIColorFromHex(0xFFA742)
#define awadColorIpadRed UIColorFromHex(0xFF6A5D)
#define awadColorIpadGrey UIColorFromHex(0x818997)
#define awadColorIpadGreen UIColorFromHex(0x7BC452)
#define awadColorIpadPink UIColorFromHex(0xEB6289)

#define awadIpadSegmentColors \
@[awadColorIpadBlue, \
  awadColorIpadPink, \
  awadColorIpadGreen, \
  awadColorIpadOrange, \
  awadColorIpadGrey]

#define awadIpadRouteLinesColors \
@[[UIColor colorWithRed:0.227 green:0.643 blue:0.867 alpha:1.000], \
    [UIColor colorWithRed:0.922 green:0.384 blue:0.537 alpha:1.000], \
    [UIColor colorWithRed:0.361 green:0.729 blue:0.157 alpha:1.000], \
    [UIColor colorWithRed:0.992 green:0.624 blue:0.259 alpha:1.000]]


#define awadIpadBubbleBorderColors \
@[[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.000], \
    [UIColor colorWithRed:235.0/255.0 green:98.0/255.0 blue:137.0/255.0 alpha:1.000], \
    [UIColor colorWithRed:123.0/255.0 green:196.0/255.0 blue:82.0/255.0 alpha:1.000], \
    [UIColor colorWithRed:255.0/255.0 green:159.0/255.0 blue:55.0/255.0 alpha:1.000]]

#define ipadOrderW 728.0

#define awadIpadDefaultRegularFontName @"HelveticaNeue"
#define awadIpadDefaultMediumFontName @"HelveticaNeue-Medium"
#define awadIpadDefaultBoldFontName @"HelveticaNeue-Bold"
#define awadIpadDefaultLightFontName @"HelveticaNeue-Light"
#define awadPriceRegularFontName @"APPMSymbals-Regular"
#define awadPriceLightFontName @"APPMSymbals-Light"

#define awadColorMediumGray [UIColor colorWithRed:0.506 green:0.537 blue:0.596 alpha:1.000]
#define awadColorDarkerGray [UIColor colorWithRed:0.255 green:0.271 blue:0.302 alpha:1.000]
#define awadColorDarkDarkGray UIColorFromHex(0x4A515E)
#define awadColorGrayLine [UIColor colorWithRed:0.251 green:0.275 blue:0.310 alpha:1.000]
#define awadColorGraySeparator UIColorFromHex(0x535A67)
#define awadColorIpadDarkGray [UIColor colorWithRed:0.157 green:0.176 blue:0.200 alpha:1.000]
#define awadColorRedWarning UIColorFromHex(0xED5A82)
#define awadColorRedDestructive UIColorFromHex(0xFF6A5D)

#define awadColorIphoneBlue awadColorIpadBlue
#define awadColorIphoneMagenta awadColorIpadPink
#define awadColorIphoneGreen awadColorIpadGreen
#define awadColorIphoneOrange awadColorIpadOrange
#define awadColorIphoneTrout UIColorFromHex(0x4A515F)
#define awadColorIphoneMainGray UIColorFromHex(0x818998)
#define awadColorIphoneMainBG   UIColorFromHex(0x272D33)
#define awadColorIphoneDarkBG   UIColorFromHex(0x20252A)
#define awadColorIphoneAttentionYellow UIColorFromHex(0xFFA833)
#define awadColorIphoneTicketGrey UIColorFromHex(0xE8EBF0)
#define awadColorIphoneBonusGreen UIColorFromHex(0x79C64A)
#define awadColorIphoneChangeRequestYellow UIColorFromHex(0xEAE4DD)

#define awadColorBlueDarken UIColorFromHex(0x306E8A)
#define awadColorMagentaDarken UIColorFromHex(0x89485E)
#define awadColorGreenDarken UIColorFromHex(0x517943)
#define awadColorOrangeDarken UIColorFromHex(0x936A3B)

//#define awadColorIOS7ButtonBlue [UIColor colorWithRed:(13.0 / 255.0) green:(151.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0]
//#define awadColorIOS7ButtonBlueHighlighted [UIColor colorWithRed:(13.0 / 255.0) green:(151.0 / 255.0) blue:(255.0 / 255.0) alpha:0.5]
//#define awadColorIOS7ButtonBlueDisabled [UIColor colorWithRed:(13.0 / 255.0) green:(151.0 / 255.0) blue:(255.0 / 255.0) alpha:0.5]
//#define awadColorIOS7ButtonBlue [UIColor colorWithRed:(0.0 / 255.0) green:(123.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0]
#define awadColorIOS7ButtonBlue awadColorIpadBlue
#define awadColorLargeButtonBlue awadColorIpadBlue
#define awadColorLargeButtonBlueDisabled UIColorFromHex(0xB8C8D1)
#define awadColorIpadNavigationBarBackground UIColorFromHex(0x1c1e20) //[UIColor colorWithRed:(25.0 / 255.0) green:(27.0 / 255.0) blue:(28.0 / 255.0) alpha:1.0]
#define awadColorIpadNavigationBarBottomBorder [UIColor colorWithRed:(49.0 / 255.0) green:(53.0 / 255.0) blue:(61.0 / 255.0) alpha:1.0]
#define awadColorIpadNavigationBarSubtitle UIColorFromHex(0x818998)
//#define awadColorIpadNavigationBarBackButton [UIColor colorWithRed:(13.0 / 255.0) green:(151.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0]
//#define awadColorIpadNavigationBarBackButtonHighlighted [UIColor colorWithRed:(13.0 / 255.0) green:(151.0 / 255.0) blue:(255.0 / 255.0) alpha:0.5]
#define awadColorIpadNavigationBarBackButton awadColorIpadBlue
#define awadColorIpadNavigationBarBackButtonHighlighted [awadColorIpadNavigationBarBackButton colorWithAlphaComponent:0.5]
#define awadDirectionColorBlue UIColorFromHex(0x1DA7EA)
#define awadDirectionColorPink UIColorFromHex(0xF56992)
#define awadDirectionColorGreen awadColorIpadGreen
#define awadDirectionColorOrange UIColorFromHex(0xFB9526)
#define awadDirectionColorGray UIColorFromHex(0x9CA4B2)
#define awadColorIpadDefaultBackground UIColorFromHex(0x272D33)
#define awadColorIpadSearchResultsGroupHeaderTitleLabel UIColorFromHex(0x818998)
#define awadColorIpadSearchResultsBlockBorder [UIColor colorWithRed:(66.0 / 255.0) green:(73.0 / 255.0) blue:(82.0 / 255.0) alpha:1.0]
#define awadColorIpadSearchResultsBlockHeaderBackground [UIColor colorWithRed:(40.0 / 255.0) green:(45.0 / 255.0) blue:(51.0 / 255.0) alpha:1.0]
#define awadColorIpadSearchResultsPrice [UIColor whiteColor]
#define awadColorIpadSearchResultsSelectedPrice awadColorIpadBlue
#define awadColorIpadSearchResultsMoreVariants [UIColor whiteColor]
#define awadColorIpadCurrencyNameInPicker [UIColor whiteColor]
#define awadColorIpadCurrencySelectedNameInPicker UIColorFromHex(0x2ECCFF)
#define awadColorIpadCurrencySymbolInPicker UIColorFromHex(0x6E7586)
#define awadColorIpadCurrencySelectedSymbolInPicker UIColorFromHex(0x2ECCFF)
#define awadColorIpadMapBoxPopupBackground UIColorFromHex(0x3E424B)
#define awadColorIpadMapBoxLabel UIColorFromHex(0x393F4C)
#define awadColorIpadMapboxOcean [UIColor colorWithRed:0.792 green:0.890 blue:0.984 alpha:1.000]
#define awadColorTabName awadColorIpadGrey
#define awadColorSelectedTabName [UIColor whiteColor]
#define awadColorIpadTimeFilterLabel awadColorIpadGrey
#define awadColorIpadFiltersRouteLabel awadColorIpadGrey
#define awadColorIpadMapBoxPopupText [UIColor whiteColor]
#define awadColorIpadMapBoxPopupOfftopText awadColorIpadGrey
#define awadColorIpadFaresTableSectionHeader UIColorFromHex(0x818998)
#define awadColorIpadPopoverHeaderBackgroundColor UIColorFromHex(0x3D434A)
#define awadColorIpadPopoverBackgroundColor UIColorFromHex(0x2B3137)
#define awadColorIpadPopoverSeparatorColor UIColorFromHex(0x666D79)
#define awadColorFaresListAirlineName UIColorFromHex(0xE9EBF0)
#define awadColorTicketTableBackground UIColorFromHex(0xE9EBF0)
#define awadColorTicketTableSelectedRow UIColorFromHex(0xDCE1E8)
#define awadColorIpadOrderTitle [UIColor whiteColor]
#define awadColorTFLightRounded UIColorFromHex(0xCED5E0)
#define awadIpadVoiceSearchBlue awadColorIpadBlue
#define awadIpadVoiceSearchButtonOk awadColorIpadBlue
#define awadIpadVoiceSearchButtonBadInput awadColorIpadOrange
#define awadIpadVoiceSearchButtonNoConnection awadColorIpadRed
#define awadIpadVoiceSearchBG UIColorFromHex(0x8B8386)
#define awadIpadVoiceSearchBubbleGray UIColorFromHex(0x7E8694)
#define awadIpadVoiceSearchControlsBg UIColorFromHex(0x282D33)
#define awadIpadVoiceSearchControlsText [UIColor whiteColor]
#define awadIpadVoiceSearchControlsSeparator UIColorFromHex(0x5a6173)
#define awadIpadVoiceSearchPopupBG UIColorFromHex(0x2B3037)
#define awadIpadVoiceSearchPopupLines UIColorFromHex(0x525964)
#define awadIpadVoiceSearchPopupText [UIColor whiteColor]
#define awadIpadVoiceSearchWrongData awadColorIpadRed
#define awadColorIpadConnectionsIconDefault UIColorFromHex(0x5A626C)
#define awadColorPopupBkgr [UIColor colorWithRed:0.208 green:0.224 blue:0.259 alpha:1.000]
#define awadColorPopoverSelectedCellBackground UIColorFromRGB(63, 70, 80)
#define awadColorPopoverGrayText UIColorFromRGB(131, 139, 160)
#define awadColorPopoverCarrotText UIColorFromRGB(245, 73, 56)
#define awadColorUnauthenticatedFieldsBorder UIColorFromRGB(64, 71, 79)
#define awadColorUnauthenticatedFieldsPlaceholder UIColorFromRGB(139, 146, 163)
#define awadColorPaxEditBkgr UIColorFromRGB(32, 37, 42)
#define awadColorPaxEditHeaderBkgr UIColorFromRGB(56, 62, 72)
#define awadColorIpadBonusGreen awadColorIpadGreen
#define awadColorIpadBonusGray awadColorIpadGrey
#define awadColorIpadBonusPopupBG UIColorFromHex(0x2B3137)
#define awadColorIpadBonusMapPopupBG UIColorFromHex(0x383e48)
#define awadColorIpadBonusTableCellLines UIColorFromHex(0x2b3037)
#define awadColorIpadBonusTableHeadersLines awadColorIpadDefaultBackground
#define awadColorIpadBonusTableCellHeaders awadColorIpadGrey
#define awadColorIpadBonusRed awadColorIpadRed
#define awadColorIpadBonusDatePickerNavbar UIColorFromHex(0x49505A)
#define awadColorIpadAuthCabinet awadColorIpadNavigationBarBackground
#define awadColorIpadBonusGreenTitles awadColorIpadGreen
#define awadColorIpadHotelSearchTableSeparatorsGrey UIColorFromHex(0x666D79)
#define awadColorIpadHotelSearchTableHeaderTextGrey UIColorFromHex(0xB1B3B6)
#define awadColorIpadHotelSearchOrange UIColorFromHex(0xF39E36)
#define awadColorIpadBonusPopupGrey UIColorFromHex(0xB5BDC9)
#define awadColorIpadMATableHeaderBackground UIColorFromHex(0x4C525A)
#define awadColorIpadTicketSilverBG UIColorFromHex(0xE4E6EC)
#define awadColorIpadChangeRequestBG UIColorFromHex(0xE2DBCE)

#define awadFontIOS7Button [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIOS7ButtonBold [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
#define awadFontIpadAviaCalendarTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadAviaCalendarMonthTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadAviaCalendarWeekdays [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadAviaCalendarCellMonth [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadAviaCalendarMonthSelector [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define awadFontIpadAviaFlightDirTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadAviaFlightDay [UIFont fontWithName:@"HelveticaNeue-Light" size:32.0]
#define awadFontIpadAviaFlightMonth [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
#define awadFontIpadAviaReturnContinueFlightTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define awadFontIpadAviaPaxType [UIFont fontWithName:@"HelveticaNeue" size:12.0]
#define awadFontIpadAviaPaxCount [UIFont fontWithName:@"HelveticaNeue-Light" size:36.0]
#define awadFontIpadAviaFlightClass [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadAviaSearchProgressTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadAviaSearchProgressHint [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadLargeButton [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadNavigationBarTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadNavigationBarSubtitle [UIFont fontWithName:@"HelveticaNeue" size:13.0]
#define awadFontIpadNavigationBarBackButton [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadSearchResultsGroupHeaderTitleLabel [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadSearchResultsPrice [UIFont fontWithName:@"APPMSymbals-Light" size:20.0]
#define awadFontIpadSearchResultsSelectedPrice [UIFont fontWithName:@"APPMSymbals-Regular" size:20.0]
#define awadFontIpadSearchResultsMoreVariants [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadCurrencyPickerNavBarButton [UIFont fontWithName:@"APPMSymbals-Light" size:22.0]
#define awadFontIpadBarButton [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadCurrencyPickerTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadCurrencyPickerOkButtonTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadCurrencyNameInPicker [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadCurrencySymbolInPicker [UIFont fontWithName:@"APPMSymbals-Light" size:24.0]
#define awadFontIpadMapBoxLabel [UIFont fontWithName:@"HelveticaNeue" size:24.0]
#define awadFontDirectionView [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define awadFontTabName [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
#define awadFontIpadTimeFilterLabel [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadFiltersRouteLabel [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
#define awadFontIpadMapBoxPopupTitle [UIFont fontWithName:@"HelveticaNeue" size:24.0]
#define awadFontIpadMapBoxPopupCountry [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadMapBoxPopupSectionTitle [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadMapBoxPopupSectionText [UIFont fontWithName:@"HelveticaNeue" size:28.0]
#define awadFontIpadMapBoxPopupTemperatureText [UIFont fontWithName:@"HelveticaNeue-Light" size:44.0]
#define awadFontIpadMapBoxPopupTemperatureSymbolText [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadMapBoxPopupSmallCurrencies [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0]
#define awadFontIpadFaresTableSectionHeader [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadFaresListAirlineName [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
#define awadFontIpadTicketHeaderAirlineName [UIFont fontWithName:@"HelveticaNeue" size:32.0]
#define awadFontIpadTicketHeaderBuyButtonTitle [UIFont fontWithName:@"APPMSymbals-Regular" size:20.0]
#define awadFontIpadOrderTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0]
#define awadFontIpadOrderNormal [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontTFUnderlined [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadVoiceSearchButtonText [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadVoiceSearchNavbarButton [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontChooserSectionHeader [UIFont fontWithName:@"HelveticaNeue" size:18.0]
#define awadFontIpadPriceCalc [UIFont fontWithName:@"APPMSymbals-Regular" size:20.0]
#define awadFontIpadVoiceSearchTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadVoiceLineText [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadVoicePlainText [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadVoiceControls [UIFont fontWithName:@"HelveticaNeue" size:18.0]
#define awadFontIpadVoiceControlsDay [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]
#define awadFontIpadVoiceControlsBubbleText [UIFont fontWithName:@"HelveticaNeue-Light" size:18]
#define awadFontIpadVoicePopupTitle [UIFont fontWithName:@"HelveticaNeue-Medium" size:16]
#define awadFontIpadVoicePopupText [UIFont fontWithName:@"HelveticaNeue" size:13]
#define awadFontIpadVoicePopupButtonsText [UIFont fontWithName:@"HelveticaNeue" size:16]
#define awadFontIpadVoicePopupButtonsTextRepeat [UIFont fontWithName:@"HelveticaNeue-Medium" size:16]
#define awadFontIpadBonusesInfo [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]
#define awadFontIpadBonusesHeaderText [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadBonusesSmallLabels [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define awadFontIpadBonusesBigLabels [UIFont fontWithName:@"HelveticaNeue" size:18.0]
#define awadFontIpadBonusesTableText [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadBonusesInfoBlocksHeader [UIFont fontWithName:@"HelveticaNeue" size:25.0]
#define awadFontIpadBonusesInfoHeaderText [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
#define awadFontIpadHotelSearchTableCell [UIFont fontWithName:@"HelveticaNeue" size:16.0]
#define awadFontIpadHotelSearchFromToText [UIFont fontWithName:@"HelveticaNeue" size:18.0]

// iPhone redesign styles

// colors:

#define awadColorIphoneMainNavbar UIColorFromHex(0x1F2123)
#define awadColorIphoneDarkBG UIColorFromHex(0x20252A)
#define awadColorIphoneMainBG UIColorFromHex(0x272D33)
#define awadColorIphoneFieldGray UIColorFromHex(0x30373d)

#define awadColorIphoneMainGray UIColorFromHex(0x818998)
#define awadColorIphoneSelectionGray UIColorFromHex(0x3C424B)
#define awadColorIphoneGeyser UIColorFromHex(0xCDD5DF)
#define awadColorIphoneWhite UIColorFromHex(0xFFFFFF)
#define awadColorIphoneMainBlue UIColorFromHex(0x30ADE2)
#define awadColorIphonePink UIColorFromHex(0xEB6289)
#define awadColorIphoneMainOrange UIColorFromHex(0xFFA833)
#define awadColorIphoneTicketGray UIColorFromHex(0xE8EBF0)
#define awadColorIphonebonusGreen UIColorFromHex(0x79C64A)
#define awadColorIphoneTrout UIColorFromHex(0x4A515F)
#define awadColorIphoneRedBanner UIColorFromHex(0xFF6958)
#define awadColorIphoneDestructiveRed UIColorFromHex(0xFF6A5D)
#define awadColorIphoneHotelsConfirmWhiteBackGround UIColorFromHex(0xF7F8FA)
#define awadColorIphoneCancellationPink UIColorFromHex(0xED6088)

// fonts:

#define awadFontIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-Light" size:a]
#define awadFontRomanIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue" size:a]
#define awadFontBoldIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-Bold" size:a]
#define awadFontMediumIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-Medium" size:a]
#define awadFontThinIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-Thin" size:a]
#define awadFontItalicIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-Italic" size:a]
#define awadFontLightItalicIphoneWithSize(a) [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:a]


#endif
