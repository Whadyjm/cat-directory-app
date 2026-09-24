import '../../features/breeds/domain/entities/breed.dart';
import 'app_language.dart';

abstract final class BreedTranslator {
  static const Map<String, String> _countries = {
    'Egypt': 'Egipto',
    'United States': 'Estados Unidos',
    'United Kingdom': 'Reino Unido',
    'Canada': 'Canadá',
    'Russia': 'Rusia',
    'France': 'Francia',
    'Japan': 'Japón',
    'Thailand': 'Tailandia',
    'Burma': 'Birmania',
    'China': 'China',
    'Australia': 'Australia',
    'Singapore': 'Singapur',
    'Isle of Man': 'Isla de Man',
    'Turkey': 'Turquía',
    'Norway': 'Noruega',
    'Sweden': 'Suecia',
    'Germany': 'Alemania',
    'Italy': 'Italia',
    'Greece': 'Grecia',
    'Iran': 'Irán',
    'Iran (Persia)': 'Irán (Persia)',
    'United Kingdom (England)': 'Reino Unido (Inglaterra)',
    'United Kingdom (Scotland)': 'Reino Unido (Escocia)',
    'Cyprus': 'Chipre',
    'Somalia': 'Somalia',
    'Ethiopia': 'Etiopía',
  };

  static const Map<String, String> _countryFlags = {
    'Egypt': '🇪🇬',
    'Egipto': '🇪🇬',
    'United States': '🇺🇸',
    'Estados Unidos': '🇺🇸',
    'United Kingdom': '🇬🇧',
    'Reino Unido': '🇬🇧',
    'United Kingdom (England)': '🇬🇧',
    'Reino Unido (Inglaterra)': '🇬🇧',
    'United Kingdom (Scotland)': '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    'Reino Unido (Escocia)': '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    'Canada': '🇨🇦',
    'Canadá': '🇨🇦',
    'Russia': '🇷🇺',
    'Rusia': '🇷🇺',
    'France': '🇫🇷',
    'Francia': '🇫🇷',
    'Japan': '🇯🇵',
    'Japón': '🇯🇵',
    'Thailand': '🇹🇭',
    'Tailandia': '🇹🇭',
    'Burma': '🇲🇲',
    'Birmania': '🇲🇲',
    'China': '🇨🇳',
    'Australia': '🇦🇺',
    'Singapore': '🇸🇬',
    'Singapur': '🇸🇬',
    'Isle of Man': '🇮🇲',
    'Isla de Man': '🇮🇲',
    'Turkey': '🇹🇷',
    'Turquía': '🇹🇷',
    'Norway': '🇳🇴',
    'Noruega': '🇳🇴',
    'Sweden': '🇸🇪',
    'Suecia': '🇸🇪',
    'Germany': '🇩🇪',
    'Alemania': '🇩🇪',
    'Italy': '🇮🇹',
    'Italia': '🇮🇹',
    'Greece': '🇬🇷',
    'Grecia': '🇬🇷',
    'Iran': '🇮🇷',
    'Irán': '🇮🇷',
    'Iran (Persia)': '🇮🇷',
    'Cyprus': '🇨🇾',
    'Chipre': '🇨🇾',
    'Somalia': '🇸🇴',
    'Ethiopia': '🇪🇹',
    'Etiopía': '🇪🇹',
  };

  static const Map<String, String> _origins = {
    'Natural': 'Natural',
    'Mutation': 'Mutación',
    'Hybrid': 'Híbrido',
    'Crossbreed': 'Cruce',
    'Natural/Mutation': 'Natural / Mutación',
  };

  static const Map<String, String> _coats = {
    'Short': 'Corto',
    'Long': 'Largo',
    'Medium': 'Medio',
    'Hairless': 'Sin pelo',
    'Rex': 'Rex (Ondulado)',
    'Semi-long': 'Semilargo',
    'All': 'Todos',
  };

  static const Map<String, String> _patterns = {
    'Solid': 'Sólido',
    'Ticked': 'Jaspeado (Ticked)',
    'Tabby': 'Atigrado (Tabby)',
    'Colorpoint': 'Punto de color (Colorpoint)',
    'Spotted': 'Moteado',
    'Bicolor': 'Bicolor',
    'Tortoiseshell': 'Carey',
    'Calico': 'Calicó',
    'Shaded': 'Sombreado',
    'Van': 'Van',
    'All': 'Todos los patrones',
  };

  static String getCountryFlag(String country) {
    final trimmed = country.trim();
    if (_countryFlags.containsKey(trimmed)) {
      return _countryFlags[trimmed]!;
    }
    for (final entry in _countryFlags.entries) {
      if (trimmed.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return '🌍';
  }

  static String translateCountry(String country, AppLanguage language) {
    if (language.isEnglish) return country;
    return _countries[country.trim()] ?? country;
  }

  static String translateOrigin(String origin, AppLanguage language) {
    if (language.isEnglish) return origin;
    return _origins[origin.trim()] ?? origin;
  }

  static String translateCoat(String coat, AppLanguage language) {
    if (language.isEnglish) return coat;
    return _coats[coat.trim()] ?? coat;
  }

  static String translatePattern(String pattern, AppLanguage language) {
    if (language.isEnglish) return pattern;
    return _patterns[pattern.trim()] ?? pattern;
  }

  static Breed translateBreed(Breed breed, AppLanguage language) {
    if (language.isEnglish) return breed;
    return Breed(
      breed: breed.breed,
      country: translateCountry(breed.country, language),
      origin: translateOrigin(breed.origin, language),
      coat: translateCoat(breed.coat, language),
      pattern: translatePattern(breed.pattern, language),
    );
  }
}
