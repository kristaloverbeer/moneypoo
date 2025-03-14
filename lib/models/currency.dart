enum Currency {
  usd(name: 'US Dollar', symbol: '\$', code: 'USD'),
  eur(name: 'Euro', symbol: '€', code: 'EUR'),
  gbp(name: 'British Pound', symbol: '£', code: 'GBP'),
  jpy(name: 'Japanese Yen', symbol: '¥', code: 'JPY'),
  cad(name: 'Canadian Dollar', symbol: 'CA\$', code: 'CAD'),
  aud(name: 'Australian Dollar', symbol: 'AU\$', code: 'AUD'),
  chf(name: 'Swiss Franc', symbol: 'CHF', code: 'CHF'),
  cny(name: 'Chinese Yuan', symbol: 'CN¥', code: 'CNY'),
  sek(name: 'Swedish Krona', symbol: 'kr', code: 'SEK'),
  nzd(name: 'New Zealand Dollar', symbol: 'NZ\$', code: 'NZD');

  const Currency({required this.name, required this.symbol, required this.code});

  final String name;
  final String symbol;
  final String code;
}
