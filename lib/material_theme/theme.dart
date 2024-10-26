import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278216827),
      surfaceTint: Color(4278216827),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289654015),
      onPrimaryContainer: Color(4278198054),
      secondary: Color(4283130473),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291749871),
      onSecondaryContainer: Color(4278591269),
      tertiary: Color(4283915390),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292796671),
      onTertiaryContainer: Color(4279507255),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294310652),
      onSurface: Color(4279704606),
      onSurfaceVariant: Color(4282337355),
      outline: Color(4285560956),
      outlineVariant: Color(4290758859),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086259),
      inversePrimary: Color(4286960360),
      primaryFixed: Color(4289654015),
      onPrimaryFixed: Color(4278198054),
      primaryFixedDim: Color(4286960360),
      onPrimaryFixedVariant: Color(4278210141),
      secondaryFixed: Color(4291749871),
      onSecondaryFixed: Color(4278591269),
      secondaryFixedDim: Color(4289907667),
      onSecondaryFixedVariant: Color(4281616977),
      tertiaryFixed: Color(4292796671),
      onTertiaryFixed: Color(4279507255),
      tertiaryFixedDim: Color(4290823403),
      onTertiaryFixedVariant: Color(4282402149),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915895),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278209112),
      surfaceTint: Color(4278216827),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280974995),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281353805),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284577920),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282138977),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285362837),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294310652),
      onSurface: Color(4279704606),
      onSurfaceVariant: Color(4282139719),
      outline: Color(4283981924),
      outlineVariant: Color(4285758591),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086259),
      inversePrimary: Color(4286960360),
      primaryFixed: Color(4280974995),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278216056),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284577920),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282998887),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285362837),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283783803),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915895),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278199855),
      surfaceTint: Color(4278216827),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209112),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279117100),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281353805),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279967806),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282138977),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294310652),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280100136),
      outline: Color(4282139719),
      outlineVariant: Color(4282139719),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086259),
      inversePrimary: Color(4291621631),
      primaryFixed: Color(4278209112),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202940),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281353805),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279840822),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282138977),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280625993),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205533),
      surfaceBright: Color(4294310652),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293915895),
      surfaceContainer: Color(4293521393),
      surfaceContainerHigh: Color(4293192171),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286960360),
      surfaceTint: Color(4286960360),
      onPrimary: Color(4278203969),
      primaryContainer: Color(4278210141),
      onPrimaryContainer: Color(4289654015),
      secondary: Color(4289907667),
      onSecondary: Color(4280103994),
      secondaryContainer: Color(4281616977),
      onSecondaryContainer: Color(4291749871),
      tertiary: Color(4290823403),
      onTertiary: Color(4280888909),
      tertiaryContainer: Color(4282402149),
      onTertiaryContainer: Color(4292796671),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279178262),
      onSurface: Color(4292797414),
      onSurfaceVariant: Color(4290758859),
      outline: Color(4287206037),
      outlineVariant: Color(4282337355),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inversePrimary: Color(4278216827),
      primaryFixed: Color(4289654015),
      onPrimaryFixed: Color(4278198054),
      primaryFixedDim: Color(4286960360),
      onPrimaryFixedVariant: Color(4278210141),
      secondaryFixed: Color(4291749871),
      onSecondaryFixed: Color(4278591269),
      secondaryFixedDim: Color(4289907667),
      onSecondaryFixedVariant: Color(4281616977),
      tertiaryFixed: Color(4292796671),
      onTertiaryFixed: Color(4279507255),
      tertiaryFixedDim: Color(4290823403),
      onTertiaryFixedVariant: Color(4282402149),
      surfaceDim: Color(4279178262),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704606),
      surfaceContainer: Color(4279967778),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4287223532),
      surfaceTint: Color(4286960360),
      onPrimary: Color(4278196512),
      primaryContainer: Color(4283210672),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290170839),
      onSecondary: Color(4278262047),
      secondaryContainer: Color(4286420380),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291086575),
      onTertiary: Color(4279112753),
      tertiaryContainer: Color(4287270835),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279178262),
      onSurface: Color(4294376446),
      onSurfaceVariant: Color(4291022032),
      outline: Color(4288390312),
      outlineVariant: Color(4286350728),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inversePrimary: Color(4278210399),
      primaryFixed: Color(4289654015),
      onPrimaryFixed: Color(4278195225),
      primaryFixedDim: Color(4286960360),
      onPrimaryFixedVariant: Color(4278205512),
      secondaryFixed: Color(4291749871),
      onSecondaryFixed: Color(4278195225),
      secondaryFixedDim: Color(4289907667),
      onSecondaryFixedVariant: Color(4280498496),
      tertiaryFixed: Color(4292796671),
      onTertiaryFixed: Color(4278783532),
      tertiaryFixedDim: Color(4290823403),
      onTertiaryFixedVariant: Color(4281283667),
      surfaceDim: Color(4279178262),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704606),
      surfaceContainer: Color(4279967778),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294245631),
      surfaceTint: Color(4286960360),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4287223532),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294245631),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290170839),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294834943),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291086575),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279178262),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294245631),
      outline: Color(4291022032),
      outlineVariant: Color(4291022032),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inversePrimary: Color(4278202169),
      primaryFixed: Color(4290572287),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4287223532),
      onPrimaryFixedVariant: Color(4278196512),
      secondaryFixed: Color(4292013043),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290170839),
      onSecondaryFixedVariant: Color(4278262047),
      tertiaryFixed: Color(4293125631),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291086575),
      onTertiaryFixedVariant: Color(4279112753),
      surfaceDim: Color(4279178262),
      surfaceBright: Color(4281612860),
      surfaceContainerLowest: Color(4278783761),
      surfaceContainerLow: Color(4279704606),
      surfaceContainer: Color(4279967778),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,

  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
